import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'package:yuanmo_link/model/mihoyo_result.dart';
import 'package:yuanmo_link/model/qrcode.dart';

const String mihoyoBaseUrl = "https://api-takumi.mihoyo.com";
const String mihoyoSdkBaseUrl = "https://hk4e-sdk.mihoyo.com";

const String mihoyoLoginQrCodePath = "/hk4e_cn/combo/panda/qrcode/fetch";

class MiHoYoUtils {
  final _dio = Dio();

  /// 获取游戏登录二维码
  Future<QrCodeResult?> getGameLodinQrCode() async {
    _dio.options = BaseOptions(
      method: "POST",
      baseUrl: mihoyoSdkBaseUrl,
      contentType: Headers.jsonContentType,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    );

    var uuid = const Uuid().v4();
    var qrcodeModel = QrcodeModel(
      appId: '4',
      device: uuid,
      ticket: '',
      payload: '',
    );

    try {
      Response response = await _dio.post(
        mihoyoLoginQrCodePath,
        data: qrcodeModel.toJson(),
      );
      if (response.statusCode == 200) {
        final MihoyoResult<QrCodeRespData> resp = MihoyoResult<QrCodeRespData>.fromJson(
          response.data,
          (json) => QrCodeRespData.fromJson(json as Map<String, dynamic>),
        );
        if (resp.retcode == 0) {
          final regex = RegExp(r'ticket=([^&]*)');
          final match = regex.firstMatch(resp.data.url);
          final tickerId = match!.group(1) ?? '';
          return QrCodeResult(url: resp.data.url, uuid: uuid, ticket: tickerId);
        } else {
          throw Exception('Failed to load QR code: ${resp.retcode}');
        }
      } else {
        throw Exception('Failed to load QR code');
      }
    } catch (e) {
      throw Exception('Failed to load QR code: $e');
    }
  }

  /// 检查扫码状态
  Future<String?> checkScanStatus(QrCodeResult qrcode) async {
    final QrcodeModel qrcodeModel = QrcodeModel(appId: "4", device: qrcode.uuid, ticket: qrcode.ticket, payload: "");
    print(qrcodeModel.toJson());

    final Response scanStatus = await _dio.post(
      "https://hk4e-sdk.mihoyo.com/hk4e_cn/combo/panda/qrcode/query",
      data: qrcodeModel.toJson(),
      options: Options(
        headers: {"Content-Type": "application/json;charset=utf-8"},
      ),
    );

    if (scanStatus.statusCode == 200) {
      final MihoyoResult<QrCodeStatus> resp = MihoyoResult<QrCodeStatus>.fromJson(
        scanStatus.data,
        (json) => QrCodeStatus.fromJson(json as Map<String, dynamic>),
      );
      if (resp.retcode == 0) {
        print(resp.data.stat);
        // 扫码成功
        if (resp.data.stat == "Confirmed") {
          print(resp.data.payload.raw);
        }
        // 成功登录
        if (resp.data.stat == "Confirmed") {
          print(resp.data.payload.raw);
        }
      } else {
        throw Exception("Failed to check scan status: ${resp.retcode}");
      }
    } else {
      throw Exception("Failed to check scan status");
    }
  }
}
