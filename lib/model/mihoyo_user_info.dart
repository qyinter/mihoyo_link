import 'package:json_annotation/json_annotation.dart';

part 'mihoyo_user_info.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MihoyoUserInfo {
  final Token token;
  final UserInfo userInfo;
  dynamic realnameInfo;
  final bool needRealperson;

  MihoyoUserInfo({
    required this.token,
    required this.userInfo,
    required this.needRealperson,
  });

  factory MihoyoUserInfo.fromJson(Map<String, dynamic> json) => _$MihoyoUserInfoFromJson(json);
  Map<String, dynamic> toJson() => _$MihoyoUserInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Token {
  final int tokenType;
  final String token;

  Token({
    required this.tokenType,
    required this.token,
  });

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
  Map<String, dynamic> toJson() => _$TokenToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class UserInfo {
  final String aid;
  final String mid;
  final String accountName;
  final String email;
  final int isEmailVerify;
  final String areaCode;
  final String mobile;
  final String safeAreaCode;
  final String safeMobile;
  final String realname;
  final String identityCode;
  final String rebindAreaCode;
  final String rebindMobile;
  final String rebindMobileTime;
  final List<dynamic> links;
  final String country;
  final String unmaskedEmail;
  final int unmaskedEmailType;

  UserInfo({
    required this.aid,
    required this.mid,
    required this.accountName,
    required this.email,
    required this.isEmailVerify,
    required this.areaCode,
    required this.mobile,
    required this.safeAreaCode,
    required this.safeMobile,
    required this.realname,
    required this.identityCode,
    required this.rebindAreaCode,
    required this.rebindMobile,
    required this.rebindMobileTime,
    required this.links,
    required this.country,
    required this.unmaskedEmail,
    required this.unmaskedEmailType,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}
