import 'package:json_annotation/json_annotation.dart';

part 'mihoyo_zzz_ avatar_info.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AvatarModel {
  final List<Character> avatarList;

  AvatarModel({
    required this.avatarList,
  });

  factory AvatarModel.fromJson(Map<String, dynamic> json) => _$AvatarModelFromJson(json);
  Map<String, dynamic> toJson() => _$AvatarModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Equip {
  final int id;
  final int level;
  final String name;
  final String icon;
  final String rarity;
  final List<Property> properties;
  final List<Property> mainProperties;
  final EquipSuit equipSuit;
  final int equipmentType;

  Equip({
    required this.id,
    required this.level,
    required this.name,
    required this.icon,
    required this.rarity,
    required this.properties,
    required this.mainProperties,
    required this.equipSuit,
    required this.equipmentType,
  });

  factory Equip.fromJson(Map<String, dynamic> json) => _$EquipFromJson(json);
  Map<String, dynamic> toJson() => _$EquipToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Property {
  final String propertyName;
  final int propertyId;
  final String base;
  final String? add;
  @JsonKey(name: 'final')
  final String? finalValue;

  Property({
    required this.propertyName,
    required this.propertyId,
    required this.base,
    required this.add,
    required this.finalValue, // Use `finalValue` internally
  });

  factory Property.fromJson(Map<String, dynamic> json) => _$PropertyFromJson(json);
  Map<String, dynamic> toJson() => _$PropertyToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class EquipSuit {
  final int suitId;
  final String name;
  final int own;
  final String desc1;
  final String desc2;

  EquipSuit({
    required this.suitId,
    required this.name,
    required this.own,
    required this.desc1,
    required this.desc2,
  });

  factory EquipSuit.fromJson(Map<String, dynamic> json) => _$EquipSuitFromJson(json);
  Map<String, dynamic> toJson() => _$EquipSuitToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Weapon {
  final int id;
  final int level;
  final String name;
  final int star;
  final String icon;
  final String rarity;
  final List<Property> properties;
  final List<Property> mainProperties;
  final String talentTitle;
  final String talentContent;
  final int profession;

  Weapon({
    required this.id,
    required this.level,
    required this.name,
    required this.star,
    required this.icon,
    required this.rarity,
    required this.properties,
    required this.mainProperties,
    required this.talentTitle,
    required this.talentContent,
    required this.profession,
  });

  factory Weapon.fromJson(Map<String, dynamic> json) => _$WeaponFromJson(json);
  Map<String, dynamic> toJson() => _$WeaponToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Skill {
  final int level;
  final int skillType;
  final List<SkillItem> items;

  Skill({
    required this.level,
    required this.skillType,
    required this.items,
  });

  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);
  Map<String, dynamic> toJson() => _$SkillToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class SkillItem {
  final String title;
  final String text;

  SkillItem({
    required this.title,
    required this.text,
  });

  factory SkillItem.fromJson(Map<String, dynamic> json) => _$SkillItemFromJson(json);
  Map<String, dynamic> toJson() => _$SkillItemToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Rank {
  final int id;
  final String name;
  final String desc;
  final int pos;
  final bool isUnlocked;

  Rank({
    required this.id,
    required this.name,
    required this.desc,
    required this.pos,
    required this.isUnlocked,
  });

  factory Rank.fromJson(Map<String, dynamic> json) => _$RankFromJson(json);
  Map<String, dynamic> toJson() => _$RankToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Character {
  final int id;
  int? uid;
  final int level;
  final String nameMi18n;
  final String fullNameMi18n;
  final int elementType;
  final String campNameMi18n;
  final int avatarProfession;
  final String rarity;
  final String groupIconPath;
  final String hollowIconPath;
  final List<Equip>? equip;
  final Weapon? weapon;
  final List<Property>? properties;
  final List<Skill>? skills;
  final int rank;
  final List<Rank>? ranks;

  Character({
    required this.id,
    required this.uid,
    required this.level,
    required this.nameMi18n,
    required this.fullNameMi18n,
    required this.elementType,
    required this.campNameMi18n,
    required this.avatarProfession,
    required this.rarity,
    required this.groupIconPath,
    required this.hollowIconPath,
    required this.equip,
    required this.weapon,
    required this.properties,
    required this.skills,
    required this.rank,
    required this.ranks,
  });

  factory Character.fromJson(Map<String, dynamic> json) => _$CharacterFromJson(json);
  Map<String, dynamic> toJson() => _$CharacterToJson(this);
}
