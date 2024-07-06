import 'package:json_annotation/json_annotation.dart';

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
    T Function(Object? json) fromJsonT,
  ) =>
      _$MihoyoResultFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) => _$MihoyoResultToJson(this, toJsonT);
}
