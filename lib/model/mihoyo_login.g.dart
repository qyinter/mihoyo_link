// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mihoyo_login.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MmtData _$MmtDataFromJson(Map<String, dynamic> json) => MmtData(
      mmtKey: json['mmt_key'] as String,
      gt: json['gt'] as String?,
      newCaptcha: (json['new_captcha'] as num?)?.toInt(),
      useV4: json['use_v4'] as bool?,
      riskType: json['risk_type'] as String?,
      success: (json['success'] as num?)?.toInt(),
      challenge: json['challenge'] as String?,
    );

Map<String, dynamic> _$MmtDataToJson(MmtData instance) => <String, dynamic>{
      'mmt_key': instance.mmtKey,
      'gt': instance.gt,
      'new_captcha': instance.newCaptcha,
      'use_v4': instance.useV4,
      'risk_type': instance.riskType,
      'success': instance.success,
      'challenge': instance.challenge,
    };

ApiLoginResponse<T> _$ApiLoginResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    ApiLoginResponse<T>(
      code: (json['code'] as num).toInt(),
      data: fromJsonT(json['data']),
    );

Map<String, dynamic> _$ApiLoginResponseToJson<T>(
  ApiLoginResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'code': instance.code,
      'data': toJsonT(instance.data),
    };

SendPhoneModel _$SendPhoneModelFromJson(Map<String, dynamic> json) =>
    SendPhoneModel(
      actionType: json['action_type'] as String,
      mmtKey: json['mmt_key'] as String,
      geetestChallenge: json['geetest_challenge'] as String,
      geetestValidate: json['geetest_validate'] as String,
      geetestSeccode: json['geetest_seccode'] as String,
      mobile: json['mobile'] as String,
      t: (json['t'] as num).toInt(),
    );

Map<String, dynamic> _$SendPhoneModelToJson(SendPhoneModel instance) =>
    <String, dynamic>{
      'action_type': instance.actionType,
      'mmt_key': instance.mmtKey,
      'geetest_challenge': instance.geetestChallenge,
      'geetest_validate': instance.geetestValidate,
      'geetest_seccode': instance.geetestSeccode,
      'mobile': instance.mobile,
      't': instance.t,
    };

SendPhoneResponse _$SendPhoneResponseFromJson(Map<String, dynamic> json) =>
    SendPhoneResponse(
      info: json['info'] as String?,
      msg: json['msg'] as String,
      status: (json['status'] as num).toInt(),
    );

Map<String, dynamic> _$SendPhoneResponseToJson(SendPhoneResponse instance) =>
    <String, dynamic>{
      'info': instance.info,
      'msg': instance.msg,
      'status': instance.status,
    };

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      accountInfo: json['account_info'],
      info: json['info'] as String?,
      msg: json['msg'] as String,
      status: (json['status'] as num).toInt(),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'account_info': instance.accountInfo,
      'info': instance.info,
      'msg': instance.msg,
      'status': instance.status,
    };
