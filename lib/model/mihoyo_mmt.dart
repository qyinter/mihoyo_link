import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:yuanmo_link/model/mihoyo_user_info.dart';

part 'mihoyo_mmt.g.dart';

@JsonSerializable()
class MmtDataModel {
  final int success;
  final String gt;
  final String challenge;
  @JsonKey(name: 'new_captcha')
  final int newCaptcha;
  @JsonKey(name: 'use_v4')
  final bool? useV4;

  MmtDataModel({
    required this.success,
    required this.gt,
    required this.challenge,
    required this.newCaptcha,
    this.useV4,
  });

  factory MmtDataModel.fromJson(Map<String, dynamic> json) => _$MmtDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$MmtDataModelToJson(this);
}

@JsonSerializable()
class MmtMainModel {
  @JsonKey(name: 'session_id')
  final String sessionId;
  @JsonKey(name: 'mmt_type')
  final int mmtType;
  @JsonKey(fromJson: _dataFromJson, toJson: _dataToJson)
  final MmtDataModel data;

  MmtMainModel({
    required this.sessionId,
    required this.mmtType,
    required this.data,
  });

  factory MmtMainModel.fromJson(Map<String, dynamic> json) => _$MmtMainModelFromJson(json);
  Map<String, dynamic> toJson() => _$MmtMainModelToJson(this);
}

MmtDataModel _dataFromJson(String data) => MmtDataModel.fromJson(Map<String, dynamic>.from(jsonDecode(data)));
String _dataToJson(MmtDataModel data) => jsonEncode(data.toJson());

@JsonSerializable()
class MmtResult {
  bool isOk;
  String message;
  MmtMainModel? mmtModel;
  MihoyoUserInfo? userInfo;

  MmtResult({
    required this.isOk,
    required this.message,
    required this.mmtModel,
    required this.userInfo,
  });

  factory MmtResult.fromJson(Map<String, dynamic> json) => _$MmtResultFromJson(json);
  Map<String, dynamic> toJson() => _$MmtResultToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Gt3Result {
  final String geetestSeccode;
  final String geetestValidate;
  final String geetestChallenge;

  Gt3Result({
    required this.geetestSeccode,
    required this.geetestValidate,
    required this.geetestChallenge,
  });

  factory Gt3Result.fromJson(Map<String, dynamic> json) => _$Gt3ResultFromJson(json);
  Map<String, dynamic> toJson() => _$Gt3ResultToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CaptchaData {
  final String captchaId;
  final String genTime;
  final String captchaOutput;
  final String passToken;
  final String lotNumber;

  CaptchaData({
    required this.captchaId,
    required this.genTime,
    required this.captchaOutput,
    required this.passToken,
    required this.lotNumber,
  });

  factory CaptchaData.fromJson(Map<String, dynamic> json) => _$CaptchaDataFromJson(json);
  Map<String, dynamic> toJson() => _$CaptchaDataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CaptchaSendData {
  final bool sentNew;
  final int countdown;
  final String actionType;

  CaptchaSendData({
    required this.sentNew,
    required this.countdown,
    required this.actionType,
  });

  factory CaptchaSendData.fromJson(Map<String, dynamic> json) => _$CaptchaSendDataFromJson(json);
  Map<String, dynamic> toJson() => _$CaptchaSendDataToJson(this);
}
