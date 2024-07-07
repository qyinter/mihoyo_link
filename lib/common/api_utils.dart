import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiResult {
  final int code;
  final String? data;
  final String msg;
  ApiResult({required this.code, this.data, required this.msg});
  factory ApiResult.fromJson(Map<String, dynamic> json) {
    return ApiResult(
      code: json['code'],
      data: json['data'],
      msg: json['msg'],
    );
  }
}

class ApiUtils {
  final _dio = Dio();

  String getSignature(String code) {
    const s = '316116EAF131C8A92A7C4CAE4A376';
    final d = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final k = '$s$d$code';
    final m = md5.convert(utf8.encode(k)).toString();
    final r = getRandomCharacters(6);
    final a = [d, m, r];
    return a.join(',');
  }

  String getRandomCharacters(int length) {
    const chars = '03549UHENGSNOA';
    final random = Random();
    String result = '';
    for (int i = 0; i < length; i++) {
      final randomIndex = random.nextInt(chars.length);
      result += chars[randomIndex];
    }
    return result;
  }

  Future<String?> setWishUrl(String url) async {
    String? apiUrl = dotenv.env['API_URL'];
    String? APP_SING = dotenv.env['APP_SING'];
    if (apiUrl == null) {
      throw Exception('API_URL is not defined in .env file');
    }

    final Response result = await _dio.post(
      "$apiUrl/api/wish_url",
      data: {
        'wish_url': url,
      },
      options: Options(
        headers: {
          "content-type": "application/json",
          'x-pre-signature': getSignature('wx9b4faf458899421f'),
          'x-pre-app': APP_SING
        },
      ),
    );

    if (result.statusCode == 200) {
      final ApiResult apiResult = ApiResult.fromJson(result.data);
      if (apiResult.code == 200) {
        final Response result2 = await _dio.get(
          "$apiUrl/api/wish_url/${apiResult.data}",
          options: Options(
            headers: {
              "content-type": "application/json",
              'x-pre-signature': getSignature('wx9b4faf458899421f'),
              'x-pre-app': APP_SING
            },
          ),
        );
        print(result2);
        return apiResult.data;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
