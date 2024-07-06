import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:yuanmo_link/common/mihoyo_utils.dart';
import 'package:yuanmo_link/model/qrcode.dart';

class QRCodeWidget extends StatefulWidget {
  @override
  _QRCodeWidgetState createState() => _QRCodeWidgetState();
}

class _QRCodeWidgetState extends State<QRCodeWidget> {
  late String data;
  bool isLoading = true;
  bool isScanned = false; // 新增变量，表示是否扫码成功
  Timer? _pollingTimer;
  Timer? _timeoutTimer;

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _timeoutTimer?.cancel();
    super.dispose();
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
          data = "无法加载二维码";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        data = "加载二维码时出错: ${e.toString()}";
      });
    }
  }

  void startPolling(QrCodeResult qrCodeResp) {
    _pollingTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      final miHoYoUtils = MiHoYoUtils();
      final scanStatus = await miHoYoUtils.checkScanStatus(qrCodeResp);
      if (scanStatus != null && scanStatus == "1") {
        setState(() {
          isScanned = true;
        });
        timer.cancel();
        _timeoutTimer?.cancel(); // 如果扫码成功，取消超时定时器
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
            if (isLoading)
              const CircularProgressIndicator()
            else if (isScanned)
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100.0,
              )
            else
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
