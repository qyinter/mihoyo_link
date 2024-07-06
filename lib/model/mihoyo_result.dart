import 'package:json_annotation/json_annotation.dart';
import 'package:yuanmo_link/model/mihoyo_game_role.dart';

part 'mihoyo_result.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class MihoyoResult<T> {
  final int retcode;
  final String message;
  final T data;

  MihoyoResult({
    required this.retcode,
    required this.message,
    required this.data,
  });

  factory MihoyoResult.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) =>
      _$MihoyoResultFromJson<T>(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) => _$MihoyoResultToJson<T>(this, toJsonT);
}

class GameType {
  final String gameName;
  final String gameBiz;
  final String key;
  final String gameIcon;
  final String baseWishUrl;

  GameType(this.gameName, this.gameBiz, this.key, this.gameIcon, this.baseWishUrl);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class GameRoleInfo {
  final String gameName;
  final String? gameIcon;
  final String? baseWishUrl;
  final List<MihoyoGameRole> list;

  GameRoleInfo({
    required this.gameName,
    required this.gameIcon,
    required this.list,
    required this.baseWishUrl,
  });

  factory GameRoleInfo.fromJson(Map<String, dynamic> json) => _$GameRoleInfoFromJson(json);
  Map<String, dynamic> toJson() => _$GameRoleInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AuthKeyModel {
  final String authAppid;
  final String gameBiz;
  final int gameUid;
  final String region;

  AuthKeyModel({
    required this.authAppid,
    required this.gameBiz,
    required this.gameUid,
    required this.region,
  });

  factory AuthKeyModel.fromJson(Map<String, dynamic> json) => _$AuthKeyModelFromJson(json);
  Map<String, dynamic> toJson() => _$AuthKeyModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AuthKeyResult {
  final int signType;
  final int authkeyVer;
  final String authkey;

  AuthKeyResult({
    required this.signType,
    required this.authkeyVer,
    required this.authkey,
  });

  factory AuthKeyResult.fromJson(Map<String, dynamic> json) => _$AuthKeyResultFromJson(json);
  Map<String, dynamic> toJson() => _$AuthKeyResultToJson(this);
}
