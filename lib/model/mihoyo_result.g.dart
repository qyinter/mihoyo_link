// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mihoyo_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MihoyoResult<T> _$MihoyoResultFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    MihoyoResult<T>(
      retcode: (json['retcode'] as num).toInt(),
      message: json['message'] as String,
      data: fromJsonT(json['data']),
    );

Map<String, dynamic> _$MihoyoResultToJson<T>(
  MihoyoResult<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'retcode': instance.retcode,
      'message': instance.message,
      'data': toJsonT(instance.data),
    };
