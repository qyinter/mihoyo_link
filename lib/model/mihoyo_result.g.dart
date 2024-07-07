// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mihoyo_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MihoyoResult<T> _$MihoyoResultFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    MihoyoResult<T>(
      retcode: (json['retcode'] as num).toInt(),
      message: json['message'] as String,
      data: _$nullableGenericFromJson(json['data'], fromJsonT),
    );

Map<String, dynamic> _$MihoyoResultToJson<T>(
  MihoyoResult<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'retcode': instance.retcode,
      'message': instance.message,
      'data': _$nullableGenericToJson(instance.data, toJsonT),
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);

GameRoleInfo _$GameRoleInfoFromJson(Map<String, dynamic> json) => GameRoleInfo(
      gameName: json['game_name'] as String,
      gameIcon: json['game_icon'] as String?,
      list: (json['list'] as List<dynamic>)
          .map((e) => MihoyoGameRole.fromJson(e as Map<String, dynamic>))
          .toList(),
      baseWishUrl: json['base_wish_url'] as String?,
    );

Map<String, dynamic> _$GameRoleInfoToJson(GameRoleInfo instance) =>
    <String, dynamic>{
      'game_name': instance.gameName,
      'game_icon': instance.gameIcon,
      'base_wish_url': instance.baseWishUrl,
      'list': instance.list,
    };

AuthKeyModel _$AuthKeyModelFromJson(Map<String, dynamic> json) => AuthKeyModel(
      authAppid: json['auth_appid'] as String,
      gameBiz: json['game_biz'] as String,
      gameUid: (json['game_uid'] as num).toInt(),
      region: json['region'] as String,
    );

Map<String, dynamic> _$AuthKeyModelToJson(AuthKeyModel instance) =>
    <String, dynamic>{
      'auth_appid': instance.authAppid,
      'game_biz': instance.gameBiz,
      'game_uid': instance.gameUid,
      'region': instance.region,
    };

AuthKeyResult _$AuthKeyResultFromJson(Map<String, dynamic> json) =>
    AuthKeyResult(
      signType: (json['sign_type'] as num).toInt(),
      authkeyVer: (json['authkey_ver'] as num).toInt(),
      authkey: json['authkey'] as String,
    );

Map<String, dynamic> _$AuthKeyResultToJson(AuthKeyResult instance) =>
    <String, dynamic>{
      'sign_type': instance.signType,
      'authkey_ver': instance.authkeyVer,
      'authkey': instance.authkey,
    };
