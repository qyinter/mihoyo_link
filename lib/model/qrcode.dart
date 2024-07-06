import 'package:json_annotation/json_annotation.dart';

part 'qrcode.g.dart';

@JsonSerializable()
class QrcodeModel {
  final String appId;
  final String device;
  final String ticket;
  final String payload;

  QrcodeModel({required this.appId, required this.device, required this.ticket, required this.payload});

  factory QrcodeModel.fromJson(Map<String, dynamic> json) => _$QrcodeModelFromJson(json);
  Map<String, dynamic> toJson() => _$QrcodeModelToJson(this);
}

@JsonSerializable()
class QrCodeRespData {
  final String url;

  QrCodeRespData({
    required this.url,
  });

  factory QrCodeRespData.fromJson(Map<String, dynamic> json) => _$QrCodeRespDataFromJson(json);
  Map<String, dynamic> toJson() => _$QrCodeRespDataToJson(this);
}

// QrCodeResult
@JsonSerializable()
class QrCodeResult {
  final String url;
  final String ticket;
  final String uuid;
  QrCodeResult({
    required this.url,
    required this.ticket,
    required this.uuid,
  });

  factory QrCodeResult.fromJson(Map<String, dynamic> json) => _$QrCodeResultFromJson(json);
  Map<String, dynamic> toJson() => _$QrCodeResultToJson(this);
}

// 获取轮训二维码返回的结果
@JsonSerializable()
class QrCodeStatus {
  final String stat;
  final String realnameInfo;
  final QrCodeStatusPayload payload;

  QrCodeStatus({
    required this.stat,
    required this.realnameInfo,
    required this.payload,
  });

  factory QrCodeStatus.fromJson(Map<String, dynamic> json) => _$QrCodeStatusFromJson(json);
  Map<String, dynamic> toJson() => _$QrCodeStatusToJson(this);
}

@JsonSerializable(genericArgumentFactories: true)
class QrCodeStatusPayload {
  final String proto;
  final QrCodeStatusRaw raw;
  final String ext;

  QrCodeStatusPayload({
    required this.proto,
    required this.raw,
    required this.ext,
  });

  factory QrCodeStatusPayload.fromJson(Map<String, dynamic> json) => _$QrCodeStatusPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$QrCodeStatusPayloadToJson(this);
}

@JsonSerializable()
class QrCodeStatusRaw {
  final String code;
  final String message;

  QrCodeStatusRaw({
    required this.code,
    required this.message,
  });

  factory QrCodeStatusRaw.fromJson(Map<String, dynamic> json) => _$QrCodeStatusRawFromJson(json);
  Map<String, dynamic> toJson() => _$QrCodeStatusRawToJson(this);
}
