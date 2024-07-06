import 'package:json_annotation/json_annotation.dart';

part 'qrcode.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class QrcodeModel {
  final String appId;
  final String device;
  final String ticket;
  final String payload;

  QrcodeModel({required this.appId, required this.device, required this.ticket, required this.payload});

  Map<String, dynamic> toJson() {
    return {
      'app_id': appId,
      'device': device,
      'ticket': ticket,
      'payload': payload,
    };
  }
}

@JsonSerializable(genericArgumentFactories: true)
class QrCodeRespData {
  final String url;

  QrCodeRespData({
    required this.url,
  });

  // fromJson 方法
  factory QrCodeRespData.fromJson(Map<String, dynamic> json) {
    return QrCodeRespData(
      url: json['url'],
    );
  }

  // toJson 方法
  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }
}

// QrCodeResult
@JsonSerializable(genericArgumentFactories: true)
class QrCodeResult {
  final String url;
  final String ticket;
  final String uuid;
  QrCodeResult({
    required this.url,
    required this.ticket,
    required this.uuid,
  });
}

// 获取轮训二维码返回的结果
@JsonSerializable(genericArgumentFactories: true)
class QrCodeStatus {
  final String stat;
  final String realnameInfo;
  final QrCodeStatusPayload payload;

  QrCodeStatus({
    required this.stat,
    required this.realnameInfo,
    required this.payload,
  });

  // fromJson 方法
  factory QrCodeStatus.fromJson(Map<String, dynamic> json) {
    return QrCodeStatus(
      stat: json['stat'] ?? '',
      realnameInfo: json['realname_info'] ?? '',
      payload: QrCodeStatusPayload.fromJson(json['payload'] ?? {}),
    );
  }

  // toJson 方法
  Map<String, dynamic> toJson() {
    return {
      'stat': stat,
      'realname_info': realnameInfo,
      'payload': payload.toJson(),
    };
  }
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

  // fromJson 方法
  factory QrCodeStatusPayload.fromJson(Map<String, dynamic> json) {
    return QrCodeStatusPayload(
      proto: json['proto'] ?? '',
      raw: QrCodeStatusRaw.fromJson(json['raw'] ?? {}),
      ext: json['ext'] ?? '',
    );
  }

  // toJson 方法
  Map<String, dynamic> toJson() {
    return {
      'proto': proto,
      'raw': raw.toJson(),
      'ext': ext,
    };
  }
}

@JsonSerializable(genericArgumentFactories: true)
class QrCodeStatusRaw {
  final String code;
  final String message;

  QrCodeStatusRaw({
    required this.code,
    required this.message,
  });

  // fromJson 方法
  factory QrCodeStatusRaw.fromJson(Map<String, dynamic> json) {
    return QrCodeStatusRaw(
      code: json['code'] ?? '',
      message: json['message'] ?? '',
    );
  }

  // toJson 方法
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
    };
  }
}
