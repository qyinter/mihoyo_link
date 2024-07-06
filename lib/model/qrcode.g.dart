// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qrcode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QrcodeModel _$QrcodeModelFromJson(Map<String, dynamic> json) => QrcodeModel(
      appId: json['appId'] as String,
      device: json['device'] as String,
      ticket: json['ticket'] as String,
      payload: json['payload'] as String,
    );

Map<String, dynamic> _$QrcodeModelToJson(QrcodeModel instance) =>
    <String, dynamic>{
      'appId': instance.appId,
      'device': instance.device,
      'ticket': instance.ticket,
      'payload': instance.payload,
    };

QrCodeRespData _$QrCodeRespDataFromJson(Map<String, dynamic> json) =>
    QrCodeRespData(
      url: json['url'] as String,
    );

Map<String, dynamic> _$QrCodeRespDataToJson(QrCodeRespData instance) =>
    <String, dynamic>{
      'url': instance.url,
    };

QrCodeResult _$QrCodeResultFromJson(Map<String, dynamic> json) => QrCodeResult(
      url: json['url'] as String,
      ticket: json['ticket'] as String,
      uuid: json['uuid'] as String,
    );

Map<String, dynamic> _$QrCodeResultToJson(QrCodeResult instance) =>
    <String, dynamic>{
      'url': instance.url,
      'ticket': instance.ticket,
      'uuid': instance.uuid,
    };

QrCodeStatus _$QrCodeStatusFromJson(Map<String, dynamic> json) => QrCodeStatus(
      stat: json['stat'] as String,
      realnameInfo: json['realnameInfo'] as String,
      payload:
          QrCodeStatusPayload.fromJson(json['payload'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QrCodeStatusToJson(QrCodeStatus instance) =>
    <String, dynamic>{
      'stat': instance.stat,
      'realnameInfo': instance.realnameInfo,
      'payload': instance.payload,
    };

QrCodeStatusPayload _$QrCodeStatusPayloadFromJson(Map<String, dynamic> json) =>
    QrCodeStatusPayload(
      proto: json['proto'] as String,
      raw: QrCodeStatusRaw.fromJson(json['raw'] as Map<String, dynamic>),
      ext: json['ext'] as String,
    );

Map<String, dynamic> _$QrCodeStatusPayloadToJson(
        QrCodeStatusPayload instance) =>
    <String, dynamic>{
      'proto': instance.proto,
      'raw': instance.raw,
      'ext': instance.ext,
    };

QrCodeStatusRaw _$QrCodeStatusRawFromJson(Map<String, dynamic> json) =>
    QrCodeStatusRaw(
      code: json['code'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$QrCodeStatusRawToJson(QrCodeStatusRaw instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
    };
