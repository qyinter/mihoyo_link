import 'package:json_annotation/json_annotation.dart';

part 'mihoyo_game_role.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MihoyoGameRoleData {
  final List<MihoyoGameRole> list;

  MihoyoGameRoleData({required this.list});

  factory MihoyoGameRoleData.fromJson(Map<String, dynamic> json) => _$MihoyoGameRoleDataFromJson(json);

  Map<String, dynamic> toJson() => _$MihoyoGameRoleDataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MihoyoGameRole {
  final String gameBiz;
  final String gameUid;
  final bool isChosen;
  final bool isOfficial;
  final int level;
  final String nickname;
  final String region;
  final String regionName;

  MihoyoGameRole({
    required this.gameBiz,
    required this.gameUid,
    required this.isChosen,
    required this.isOfficial,
    required this.level,
    required this.nickname,
    required this.region,
    required this.regionName,
  });

  factory MihoyoGameRole.fromJson(Map<String, dynamic> json) => _$MihoyoGameRoleFromJson(json);

  Map<String, dynamic> toJson() => _$MihoyoGameRoleToJson(this);
}
