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
      data: fromJsonT(json['data']),
    );

Map<String, dynamic> _$MihoyoResultToJson<T>(
  MihoyoResult<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'retcode': instance.retcode,
      'message': instance.message,
      'data': toJsonT(instance.data),
    };

GameRoleInfo _$GameRoleInfoFromJson(Map<String, dynamic> json) => GameRoleInfo(
      gameName: json['game_name'] as String,
      gameIcon: json['game_icon'] as String?,
      list: (json['list'] as List<dynamic>)
          .map((e) => MihoyoGameRole.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GameRoleInfoToJson(GameRoleInfo instance) =>
    <String, dynamic>{
      'game_name': instance.gameName,
      'game_icon': instance.gameIcon,
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
