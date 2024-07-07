// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mihoyo_mmt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MmtDataModel _$MmtDataModelFromJson(Map<String, dynamic> json) => MmtDataModel(
      success: (json['success'] as num).toInt(),
      gt: json['gt'] as String,
      challenge: json['challenge'] as String,
      newCaptcha: (json['new_captcha'] as num).toInt(),
      useV4: json['use_v4'] as bool?,
    );

Map<String, dynamic> _$MmtDataModelToJson(MmtDataModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'gt': instance.gt,
      'challenge': instance.challenge,
      'new_captcha': instance.newCaptcha,
      'use_v4': instance.useV4,
    };

MmtMainModel _$MmtMainModelFromJson(Map<String, dynamic> json) => MmtMainModel(
      sessionId: json['session_id'] as String,
      mmtType: (json['mmt_type'] as num).toInt(),
      data: _dataFromJson(json['data'] as String),
    );

Map<String, dynamic> _$MmtMainModelToJson(MmtMainModel instance) =>
    <String, dynamic>{
      'session_id': instance.sessionId,
      'mmt_type': instance.mmtType,
      'data': _dataToJson(instance.data),
    };

MmtResult _$MmtResultFromJson(Map<String, dynamic> json) => MmtResult(
      isOk: json['isOk'] as bool,
      message: json['message'] as String,
      mmtModel: json['mmtModel'] == null
          ? null
          : MmtMainModel.fromJson(json['mmtModel'] as Map<String, dynamic>),
      userInfo: json['userInfo'] == null
          ? null
          : MihoyoUserInfo.fromJson(json['userInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MmtResultToJson(MmtResult instance) => <String, dynamic>{
      'isOk': instance.isOk,
      'message': instance.message,
      'mmtModel': instance.mmtModel,
      'userInfo': instance.userInfo,
    };

Gt3Result _$Gt3ResultFromJson(Map<String, dynamic> json) => Gt3Result(
      geetestSeccode: json['geetest_seccode'] as String,
      geetestValidate: json['geetest_validate'] as String,
      geetestChallenge: json['geetest_challenge'] as String,
    );

Map<String, dynamic> _$Gt3ResultToJson(Gt3Result instance) => <String, dynamic>{
      'geetest_seccode': instance.geetestSeccode,
      'geetest_validate': instance.geetestValidate,
      'geetest_challenge': instance.geetestChallenge,
    };

CaptchaData _$CaptchaDataFromJson(Map<String, dynamic> json) => CaptchaData(
      captchaId: json['captcha_id'] as String,
      genTime: json['gen_time'] as String,
      captchaOutput: json['captcha_output'] as String,
      passToken: json['pass_token'] as String,
      lotNumber: json['lot_number'] as String,
    );

Map<String, dynamic> _$CaptchaDataToJson(CaptchaData instance) =>
    <String, dynamic>{
      'captcha_id': instance.captchaId,
      'gen_time': instance.genTime,
      'captcha_output': instance.captchaOutput,
      'pass_token': instance.passToken,
      'lot_number': instance.lotNumber,
    };

CaptchaSendData _$CaptchaSendDataFromJson(Map<String, dynamic> json) =>
    CaptchaSendData(
      sentNew: json['sent_new'] as bool,
      countdown: (json['countdown'] as num).toInt(),
      actionType: json['action_type'] as String,
    );

Map<String, dynamic> _$CaptchaSendDataToJson(CaptchaSendData instance) =>
    <String, dynamic>{
      'sent_new': instance.sentNew,
      'countdown': instance.countdown,
      'action_type': instance.actionType,
    };
