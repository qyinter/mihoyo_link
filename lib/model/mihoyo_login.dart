import 'package:json_annotation/json_annotation.dart';

part 'mihoyo_login.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MmtData {
  final String mmtKey;
  final String? gt;
  final int? newCaptcha;
  final bool? useV4;
  final String? riskType;
  final int? success;
  final String? challenge;

  MmtData({
    required this.mmtKey,
    this.gt,
    this.newCaptcha,
    this.useV4,
    this.riskType,
    this.success,
    this.challenge,
  });

  factory MmtData.fromJson(Map<String, dynamic> json) => _$MmtDataFromJson(json);
  Map<String, dynamic> toJson() => _$MmtDataToJson(this);
}

class ApiLoginData {
  final MmtData mmtData;
  final int mmtType;
  final String msg;
  final int sceneType;
  final int status;

  ApiLoginData({
    required this.mmtData,
    required this.mmtType,
    required this.msg,
    required this.sceneType,
    required this.status,
  });

  factory ApiLoginData.fromJson(Map<String, dynamic> json) {
    return ApiLoginData(
      mmtData: MmtData.fromJson(json['mmt_data']),
      mmtType: json['mmt_type'],
      msg: json['msg'],
      sceneType: json['scene_type'],
      status: json['status'],
    );
  }
}

@JsonSerializable(genericArgumentFactories: true)
class ApiLoginResponse<T> {
  final int code;
  final T data;

  ApiLoginResponse({required this.code, required this.data});
  factory ApiLoginResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) =>
      _$ApiLoginResponseFromJson<T>(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) => _$ApiLoginResponseToJson<T>(this, toJsonT);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class SendPhoneModel {
  final String actionType;
  final String mmtKey;
  final String geetestChallenge;
  final String geetestValidate;
  final String geetestSeccode;
  final String mobile;
  final int t;

  SendPhoneModel({
    required this.actionType,
    required this.mmtKey,
    required this.geetestChallenge,
    required this.geetestValidate,
    required this.geetestSeccode,
    required this.mobile,
    required this.t,
  });

  factory SendPhoneModel.fromJson(Map<String, dynamic> json) => _$SendPhoneModelFromJson(json);
  Map<String, dynamic> toJson() => _$SendPhoneModelToJson(this);
}

@JsonSerializable()
class SendPhoneResponse {
  final String? info;
  final String msg;
  final int status;

  SendPhoneResponse({
    required this.info,
    required this.msg,
    required this.status,
  });

  factory SendPhoneResponse.fromJson(Map<String, dynamic> json) => _$SendPhoneResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SendPhoneResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class LoginResponse {
  ///{account_info: null, info: Captcha not match Err, msg: 验证码错误, status: -201}
  final Object? accountInfo;
  final String? info;
  final String msg;
  final int status;

  LoginResponse({
    required this.accountInfo,
    required this.info,
    required this.msg,
    required this.status,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
