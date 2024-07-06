// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mihoyo_user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MihoyoUserInfo _$MihoyoUserInfoFromJson(Map<String, dynamic> json) =>
    MihoyoUserInfo(
      token: Token.fromJson(json['token'] as Map<String, dynamic>),
      userInfo: UserInfo.fromJson(json['user_info'] as Map<String, dynamic>),
      needRealperson: json['need_realperson'] as bool,
    )..realnameInfo = json['realname_info'];

Map<String, dynamic> _$MihoyoUserInfoToJson(MihoyoUserInfo instance) =>
    <String, dynamic>{
      'token': instance.token,
      'user_info': instance.userInfo,
      'realname_info': instance.realnameInfo,
      'need_realperson': instance.needRealperson,
    };

Token _$TokenFromJson(Map<String, dynamic> json) => Token(
      tokenType: (json['token_type'] as num).toInt(),
      token: json['token'] as String,
    );

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
      'token_type': instance.tokenType,
      'token': instance.token,
    };

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      aid: json['aid'] as String,
      mid: json['mid'] as String,
      accountName: json['account_name'] as String,
      email: json['email'] as String,
      isEmailVerify: (json['is_email_verify'] as num).toInt(),
      areaCode: json['area_code'] as String,
      mobile: json['mobile'] as String,
      safeAreaCode: json['safe_area_code'] as String,
      safeMobile: json['safe_mobile'] as String,
      realname: json['realname'] as String,
      identityCode: json['identity_code'] as String,
      rebindAreaCode: json['rebind_area_code'] as String,
      rebindMobile: json['rebind_mobile'] as String,
      rebindMobileTime: json['rebind_mobile_time'] as String,
      links: json['links'] as List<dynamic>,
      country: json['country'] as String,
      unmaskedEmail: json['unmasked_email'] as String,
      unmaskedEmailType: (json['unmasked_email_type'] as num).toInt(),
    );

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'aid': instance.aid,
      'mid': instance.mid,
      'account_name': instance.accountName,
      'email': instance.email,
      'is_email_verify': instance.isEmailVerify,
      'area_code': instance.areaCode,
      'mobile': instance.mobile,
      'safe_area_code': instance.safeAreaCode,
      'safe_mobile': instance.safeMobile,
      'realname': instance.realname,
      'identity_code': instance.identityCode,
      'rebind_area_code': instance.rebindAreaCode,
      'rebind_mobile': instance.rebindMobile,
      'rebind_mobile_time': instance.rebindMobileTime,
      'links': instance.links,
      'country': instance.country,
      'unmasked_email': instance.unmaskedEmail,
      'unmasked_email_type': instance.unmaskedEmailType,
    };
