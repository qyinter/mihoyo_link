// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mihoyo_zzz_ avatar_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ZZZAvatarList _$ZZZAvatarListFromJson(Map<String, dynamic> json) =>
    ZZZAvatarList(
      avatar_list: (json['avatar_list'] as List<dynamic>)
          .map((e) => ZZZAvatarInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ZZZAvatarListToJson(ZZZAvatarList instance) =>
    <String, dynamic>{
      'avatar_list': instance.avatar_list,
    };

ZZZAvatarInfo _$ZZZAvatarInfoFromJson(Map<String, dynamic> json) =>
    ZZZAvatarInfo(
      id: (json['id'] as num).toInt(),
      level: (json['level'] as num).toInt(),
      nameMi18n: json['name_mi18n'] as String,
      fullNameMi18n: json['full_name_mi18n'] as String,
      elementType: (json['element_type'] as num).toInt(),
      campNameMi18n: json['camp_name_mi18n'] as String,
      avatarProfession: (json['avatar_profession'] as num).toInt(),
      rarity: json['rarity'] as String,
      groupIconPath: json['group_icon_path'] as String,
      hollowIconPath: json['hollow_icon_path'] as String,
      rank: (json['rank'] as num).toInt(),
      isChosen: json['is_chosen'] as bool,
    );

Map<String, dynamic> _$ZZZAvatarInfoToJson(ZZZAvatarInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'level': instance.level,
      'name_mi18n': instance.nameMi18n,
      'full_name_mi18n': instance.fullNameMi18n,
      'element_type': instance.elementType,
      'camp_name_mi18n': instance.campNameMi18n,
      'avatar_profession': instance.avatarProfession,
      'rarity': instance.rarity,
      'group_icon_path': instance.groupIconPath,
      'hollow_icon_path': instance.hollowIconPath,
      'rank': instance.rank,
      'is_chosen': instance.isChosen,
    };
