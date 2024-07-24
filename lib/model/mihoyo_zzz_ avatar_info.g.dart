// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mihoyo_zzz_ avatar_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvatarModel _$AvatarModelFromJson(Map<String, dynamic> json) => AvatarModel(
      avatarList: (json['avatar_list'] as List<dynamic>)
          .map((e) => Character.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AvatarModelToJson(AvatarModel instance) =>
    <String, dynamic>{
      'avatar_list': instance.avatarList,
    };

Equip _$EquipFromJson(Map<String, dynamic> json) => Equip(
      id: (json['id'] as num).toInt(),
      level: (json['level'] as num).toInt(),
      name: json['name'] as String,
      icon: json['icon'] as String,
      rarity: json['rarity'] as String,
      properties: (json['properties'] as List<dynamic>)
          .map((e) => Property.fromJson(e as Map<String, dynamic>))
          .toList(),
      mainProperties: (json['main_properties'] as List<dynamic>)
          .map((e) => Property.fromJson(e as Map<String, dynamic>))
          .toList(),
      equipSuit: EquipSuit.fromJson(json['equip_suit'] as Map<String, dynamic>),
      equipmentType: (json['equipment_type'] as num).toInt(),
    );

Map<String, dynamic> _$EquipToJson(Equip instance) => <String, dynamic>{
      'id': instance.id,
      'level': instance.level,
      'name': instance.name,
      'icon': instance.icon,
      'rarity': instance.rarity,
      'properties': instance.properties,
      'main_properties': instance.mainProperties,
      'equip_suit': instance.equipSuit,
      'equipment_type': instance.equipmentType,
    };

Property _$PropertyFromJson(Map<String, dynamic> json) => Property(
      propertyName: json['property_name'] as String,
      propertyId: (json['property_id'] as num).toInt(),
      base: json['base'] as String,
      add: json['add'] as String?,
      finalValue: json['final'] as String?,
    );

Map<String, dynamic> _$PropertyToJson(Property instance) => <String, dynamic>{
      'property_name': instance.propertyName,
      'property_id': instance.propertyId,
      'base': instance.base,
      'add': instance.add,
      'final': instance.finalValue,
    };

EquipSuit _$EquipSuitFromJson(Map<String, dynamic> json) => EquipSuit(
      suitId: (json['suit_id'] as num).toInt(),
      name: json['name'] as String,
      own: (json['own'] as num).toInt(),
      desc1: json['desc1'] as String,
      desc2: json['desc2'] as String,
    );

Map<String, dynamic> _$EquipSuitToJson(EquipSuit instance) => <String, dynamic>{
      'suit_id': instance.suitId,
      'name': instance.name,
      'own': instance.own,
      'desc1': instance.desc1,
      'desc2': instance.desc2,
    };

Weapon _$WeaponFromJson(Map<String, dynamic> json) => Weapon(
      id: (json['id'] as num).toInt(),
      level: (json['level'] as num).toInt(),
      name: json['name'] as String,
      star: (json['star'] as num).toInt(),
      icon: json['icon'] as String,
      rarity: json['rarity'] as String,
      properties: (json['properties'] as List<dynamic>)
          .map((e) => Property.fromJson(e as Map<String, dynamic>))
          .toList(),
      mainProperties: (json['main_properties'] as List<dynamic>)
          .map((e) => Property.fromJson(e as Map<String, dynamic>))
          .toList(),
      talentTitle: json['talent_title'] as String,
      talentContent: json['talent_content'] as String,
      profession: (json['profession'] as num).toInt(),
    );

Map<String, dynamic> _$WeaponToJson(Weapon instance) => <String, dynamic>{
      'id': instance.id,
      'level': instance.level,
      'name': instance.name,
      'star': instance.star,
      'icon': instance.icon,
      'rarity': instance.rarity,
      'properties': instance.properties,
      'main_properties': instance.mainProperties,
      'talent_title': instance.talentTitle,
      'talent_content': instance.talentContent,
      'profession': instance.profession,
    };

Skill _$SkillFromJson(Map<String, dynamic> json) => Skill(
      level: (json['level'] as num).toInt(),
      skillType: (json['skill_type'] as num).toInt(),
      items: (json['items'] as List<dynamic>)
          .map((e) => SkillItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SkillToJson(Skill instance) => <String, dynamic>{
      'level': instance.level,
      'skill_type': instance.skillType,
      'items': instance.items,
    };

SkillItem _$SkillItemFromJson(Map<String, dynamic> json) => SkillItem(
      title: json['title'] as String,
      text: json['text'] as String,
    );

Map<String, dynamic> _$SkillItemToJson(SkillItem instance) => <String, dynamic>{
      'title': instance.title,
      'text': instance.text,
    };

Rank _$RankFromJson(Map<String, dynamic> json) => Rank(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      desc: json['desc'] as String,
      pos: (json['pos'] as num).toInt(),
      isUnlocked: json['is_unlocked'] as bool,
    );

Map<String, dynamic> _$RankToJson(Rank instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'desc': instance.desc,
      'pos': instance.pos,
      'is_unlocked': instance.isUnlocked,
    };

Character _$CharacterFromJson(Map<String, dynamic> json) => Character(
      id: (json['id'] as num).toInt(),
      uid: (json['uid'] as num?)?.toInt(),
      level: (json['level'] as num).toInt(),
      nameMi18n: json['name_mi18n'] as String,
      fullNameMi18n: json['full_name_mi18n'] as String,
      elementType: (json['element_type'] as num).toInt(),
      campNameMi18n: json['camp_name_mi18n'] as String,
      avatarProfession: (json['avatar_profession'] as num).toInt(),
      rarity: json['rarity'] as String,
      groupIconPath: json['group_icon_path'] as String,
      hollowIconPath: json['hollow_icon_path'] as String,
      equip: (json['equip'] as List<dynamic>?)
          ?.map((e) => Equip.fromJson(e as Map<String, dynamic>))
          .toList(),
      weapon: json['weapon'] == null
          ? null
          : Weapon.fromJson(json['weapon'] as Map<String, dynamic>),
      properties: (json['properties'] as List<dynamic>?)
          ?.map((e) => Property.fromJson(e as Map<String, dynamic>))
          .toList(),
      skills: (json['skills'] as List<dynamic>?)
          ?.map((e) => Skill.fromJson(e as Map<String, dynamic>))
          .toList(),
      rank: (json['rank'] as num).toInt(),
      ranks: (json['ranks'] as List<dynamic>?)
          ?.map((e) => Rank.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CharacterToJson(Character instance) => <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'level': instance.level,
      'name_mi18n': instance.nameMi18n,
      'full_name_mi18n': instance.fullNameMi18n,
      'element_type': instance.elementType,
      'camp_name_mi18n': instance.campNameMi18n,
      'avatar_profession': instance.avatarProfession,
      'rarity': instance.rarity,
      'group_icon_path': instance.groupIconPath,
      'hollow_icon_path': instance.hollowIconPath,
      'equip': instance.equip,
      'weapon': instance.weapon,
      'properties': instance.properties,
      'skills': instance.skills,
      'rank': instance.rank,
      'ranks': instance.ranks,
    };
