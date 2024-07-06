// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mihoyo_game_role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MihoyoGameRoleData _$MihoyoGameRoleDataFromJson(Map<String, dynamic> json) =>
    MihoyoGameRoleData(
      list: (json['list'] as List<dynamic>)
          .map((e) => MihoyoGameRole.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MihoyoGameRoleDataToJson(MihoyoGameRoleData instance) =>
    <String, dynamic>{
      'list': instance.list,
    };

MihoyoGameRole _$MihoyoGameRoleFromJson(Map<String, dynamic> json) =>
    MihoyoGameRole(
      gameBiz: json['game_biz'] as String,
      gameUid: json['game_uid'] as String,
      isChosen: json['is_chosen'] as bool,
      isOfficial: json['is_official'] as bool,
      level: (json['level'] as num).toInt(),
      nickname: json['nickname'] as String,
      region: json['region'] as String,
      regionName: json['region_name'] as String,
    );

Map<String, dynamic> _$MihoyoGameRoleToJson(MihoyoGameRole instance) =>
    <String, dynamic>{
      'game_biz': instance.gameBiz,
      'game_uid': instance.gameUid,
      'is_chosen': instance.isChosen,
      'is_official': instance.isOfficial,
      'level': instance.level,
      'nickname': instance.nickname,
      'region': instance.region,
      'region_name': instance.regionName,
    };
