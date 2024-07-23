import 'package:json_annotation/json_annotation.dart';

part 'mihoyo_zzz_ avatar_info.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AvatarModel {
  final List<Object> avatarList;
  final Map<String, String> equipWiki;
  final Map<String, String> weaponWiki;
  final Map<String, String> avatarWiki;
  final Map<String, String> strategyWiki;

  AvatarModel({
    required this.avatarList,
    required this.equipWiki,
    required this.weaponWiki,
    required this.avatarWiki,
    required this.strategyWiki,
  });

  factory AvatarModel.fromJson(Map<String, dynamic> json) => _$AvatarModelFromJson(json);
  Map<String, dynamic> toJson() => _$AvatarModelToJson(this);
}
