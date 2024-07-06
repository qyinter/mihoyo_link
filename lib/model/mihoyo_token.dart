import 'package:json_annotation/json_annotation.dart';

part 'mihoyo_token.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class GameTokenModel {
  final int accountId;
  final String gameToken;

  GameTokenModel({
    required this.accountId,
    required this.gameToken,
  });

  factory GameTokenModel.fromJson(Map<String, dynamic> json) => _$GameTokenModelFromJson(json);
  Map<String, dynamic> toJson() => _$GameTokenModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MihoyoLtoken {
  final String ltoken;

  MihoyoLtoken({
    required this.ltoken,
  });

  factory MihoyoLtoken.fromJson(Map<String, dynamic> json) => _$MihoyoLtokenFromJson(json);
  Map<String, dynamic> toJson() => _$MihoyoLtokenToJson(this);
}
