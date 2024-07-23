// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mihoyo_zzz_ avatar_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvatarModel _$AvatarModelFromJson(Map<String, dynamic> json) => AvatarModel(
      avatarList: (json['avatar_list'] as List<dynamic>)
          .map((e) => e as Object)
          .toList(),
      equipWiki: Map<String, String>.from(json['equip_wiki'] as Map),
      weaponWiki: Map<String, String>.from(json['weapon_wiki'] as Map),
      avatarWiki: Map<String, String>.from(json['avatar_wiki'] as Map),
      strategyWiki: Map<String, String>.from(json['strategy_wiki'] as Map),
    );

Map<String, dynamic> _$AvatarModelToJson(AvatarModel instance) =>
    <String, dynamic>{
      'avatar_list': instance.avatarList,
      'equip_wiki': instance.equipWiki,
      'weapon_wiki': instance.weaponWiki,
      'avatar_wiki': instance.avatarWiki,
      'strategy_wiki': instance.strategyWiki,
    };
