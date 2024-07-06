// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mihoyo_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameTokenModel _$GameTokenModelFromJson(Map<String, dynamic> json) =>
    GameTokenModel(
      accountId: (json['account_id'] as num).toInt(),
      gameToken: json['game_token'] as String,
    );

Map<String, dynamic> _$GameTokenModelToJson(GameTokenModel instance) =>
    <String, dynamic>{
      'account_id': instance.accountId,
      'game_token': instance.gameToken,
    };

MihoyoLtoken _$MihoyoLtokenFromJson(Map<String, dynamic> json) => MihoyoLtoken(
      ltoken: json['ltoken'] as String,
    );

Map<String, dynamic> _$MihoyoLtokenToJson(MihoyoLtoken instance) =>
    <String, dynamic>{
      'ltoken': instance.ltoken,
    };
