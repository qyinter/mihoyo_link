import 'package:json_annotation/json_annotation.dart';

part 'mihoyo_zzz_ avatar_list.g.dart';

@JsonSerializable()
class ZZZAvatarList {
  final List<ZZZAvatarInfo> avatar_list;

  ZZZAvatarList({required this.avatar_list});

  factory ZZZAvatarList.fromJson(Map<String, dynamic> json) => _$ZZZAvatarListFromJson(json);
  Map<String, dynamic> toJson() => _$ZZZAvatarListToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ZZZAvatarInfo {
  int id;
  int level;
  String nameMi18n;
  String fullNameMi18n;
  int elementType;
  String campNameMi18n;
  int avatarProfession;
  String rarity;
  String groupIconPath;
  String hollowIconPath;
  int rank;
  bool isChosen;

  ZZZAvatarInfo({
    required this.id,
    required this.level,
    required this.nameMi18n,
    required this.fullNameMi18n,
    required this.elementType,
    required this.campNameMi18n,
    required this.avatarProfession,
    required this.rarity,
    required this.groupIconPath,
    required this.hollowIconPath,
    required this.rank,
    required this.isChosen,
  });

  factory ZZZAvatarInfo.fromJson(Map<String, dynamic> json) => _$ZZZAvatarInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ZZZAvatarInfoToJson(this);
}
