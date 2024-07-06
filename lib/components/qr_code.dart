import 'dart:async';
import 'dart:convert';
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:yuanmo_link/common/mihoyo_utils.dart';
import 'package:yuanmo_link/model/mihoyo_qrcode.dart';
import 'package:yuanmo_link/store/global.dart';

class QRCodeWidget extends StatefulWidget {
  @override
  _QRCodeWidgetState createState() => _QRCodeWidgetState();
}

class _QRCodeWidgetState extends State<QRCodeWidget> {
  late String data;
  bool isLoading = true;
  bool isScanned = false; // 新增变量，表示是否扫码成功
  bool infoStatus = false;
  late String infoText = "";

  Timer? _pollingTimer;
  Timer? _timeoutTimer;

  @override
  void initState() {
    super.initState();
    initData();
    // 如果stoken和角色信息都不为空，则表示已经登录
    if (Global.stoken.isNotEmpty && Global.gameRoleList.isNotEmpty) {
      // 不显示登录框
      closePicker();
      return;
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _timeoutTimer?.cancel();
    super.dispose();
  }

  void closePicker() {
    Navigator.of(context).pop();
  }

  void initData() async {
    try {
      setState(() {
        isLoading = true;
        isScanned = false;
      });
      final miHoYoUtils = MiHoYoUtils();
      final qrCodeResult = await miHoYoUtils.getGameLodinQrCode();
      if (qrCodeResult != null) {
        setState(() {
          data = qrCodeResult.url;
          isLoading = false;
          startPolling(qrCodeResult);
          startTimeout();
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {}
  }

  void startPolling(QrCodeResult qrCodeResp) {
    _pollingTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      final miHoYoUtils = MiHoYoUtils();
      final qrCodeStatus = await miHoYoUtils.checkScanStatus(qrCodeResp);
      if (qrCodeStatus != null) {
        // 扫码成功
        if (qrCodeStatus.stat == "Scanned") {
          setState(() {
            isScanned = true;
          });
        }
        // 成功后取消定时器
        if (qrCodeStatus.stat == "Confirmed") {
          infoStatus = true;
          timer.cancel();
          _pollingTimer?.cancel();
          _timeoutTimer?.cancel();

          setState(() {
            infoText = "扫码成功，正在获取信息中...";
          });

          if (qrCodeStatus.payload.raw.isNotEmpty) {
            // String to QrCodeStatusRaw
            Map<String, dynamic> jsonMap = jsonDecode(qrCodeStatus.payload.raw);
            final qrCodeStatusRaw = QrCodeStatusRaw.fromJson(jsonMap);
            Global.saveMiyousheAcount(qrCodeStatusRaw.uid);
            final mihoyoUserinfo = await miHoYoUtils.exchangeGameTokenForSToken(qrCodeStatusRaw);
            if (mihoyoUserinfo != null) {
              Global.saveStoken(mihoyoUserinfo.token.token);
              Global.saveMid(mihoyoUserinfo.userInfo.mid);
              // 获取cookie
              String cookie =
                  "login_uid=${Global.miyousheAcount}; account_id=${Global.miyousheAcount}; account_mid_v2=${mihoyoUserinfo.userInfo.mid}; account_id_v2=${Global.miyousheAcount}; ltmid_v2=${mihoyoUserinfo.userInfo.mid}; ltuid_v2=${Global.miyousheAcount}; ltuid=${Global.miyousheAcount}; stuid=${Global.miyousheAcount};stoken=${Global.stoken};mid=${mihoyoUserinfo.userInfo.mid}";
              // stoken 换 ltoken
              final ltoken = await miHoYoUtils.getLTokenBySToken(cookie);
              // 添加ltoken
              cookie += ";ltoken=$ltoken";
              Global.saveMihoyoCookie(cookie);
              // 获取角色信息
              await miHoYoUtils.getGameRolesInfo(cookie);
              // 获取角色信息成功
              setState(() {
                BrnToast.show(
                  "全部信息已经获取成功",
                  context,
                  preIcon: Image.asset(
                    "assets/images/icon_toast_success.png",
                    width: 24,
                    height: 24,
                  ),
                  duration: const Duration(seconds: 2),
                );
              });
              closePicker();
            }
          }
        }
      } else {
        timer.cancel();
        _pollingTimer?.cancel();
        _timeoutTimer?.cancel();
      }
    });
  }

  /// 设置超时控制，60秒后重新执行initData
  void startTimeout() {
    _timeoutTimer = Timer(Duration(seconds: 60), () {
      _pollingTimer?.cancel(); // 取消轮询定时器
      initData(); // 重新执行initData
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          children: [
            if (isLoading) // 如果正在加载，则显示加载中的圆形进度条
              const CircularProgressIndicator()
            else if (isScanned) // 如果扫码成功，则显示一个绿色的勾勾
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100.0,
              )
            else if (infoStatus) // 如果流程都显示当前进度
              Text(infoText)
            else // 否则显示二维码
              QrImageView(
                data: data,
                version: QrVersions.auto,
                size: 200.0,
                // 假设有一个扫描成功的回调
                // onScanned: onScanSuccess, // 此回调需要根据你的实际情况实现
              ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0), // 添加顶部内边距
              child: Text(isLoading ? "获取登录二维码中..." : "米游社扫码登录"),
            ),
          ],
        ),
      ),
    );
  }
}
