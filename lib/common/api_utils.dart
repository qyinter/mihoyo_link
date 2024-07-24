import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yuanmo_link/model/mihoyo_game_role.dart';
import 'package:yuanmo_link/model/mihoyo_zzz_%20avatar_info.dart';
import 'package:yuanmo_link/model/mihoyo_zzz_%20avatar_list.dart';

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
        return apiResult.data;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  ///
  Future<bool?> setAvatarListData(List<ZZZAvatarInfo> list, MihoyoGameRole role) async {
    print(role.toJson());
    String? apiUrl = dotenv.env['API_URL'];
    if (apiUrl == null) {
      throw Exception('API_URL is not defined in .env file');
    }
    // newBody
    List<ZZZAvatarInfoModel> newBody = [];
    //for
    for (var i = 0; i < list.length; i++) {
      var newAvatar = ZZZAvatarInfoModel(
        uid: int.tryParse(role.gameUid) ?? 0,
        characterId: list[i].id,
        level: list[i].level,
        nameMi18n: list[i].nameMi18n,
        fullNameMi18n: list[i].fullNameMi18n,
        elementType: list[i].elementType,
        campNameMi18n: list[i].campNameMi18n,
        avatarProfession: list[i].avatarProfession,
        rarity: list[i].rarity,
        groupIconPath: list[i].groupIconPath,
        hollowIconPath: list[i].hollowIconPath,
        rank: list[i].rank,
        isChosen: list[i].isChosen,
      );
      newBody.add(newAvatar);
    }
    try {
      final Response result = await _dio.post(
        "$apiUrl/api/avatar_list",
        data: newBody.map((avatar) => avatar.toJson()).toList(),
        options: Options(
          headers: {
            "content-type": "application/json",
            'x-pre-signature': getSignature('wx9b4faf458899421f'),
          },
        ),
      );
      if (result.statusCode == 200) {
        final ApiResult apiResult = ApiResult.fromJson(result.data);
        if (apiResult.code == 200) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('请求URL: ${e.requestOptions.uri}');
        print('请求头: ${e.requestOptions.headers}');
        print('请求数据: ${e.requestOptions.data}');
        print('响应状态码: ${e.response?.statusCode}');
        print('响应数据: ${e.response?.data}');
      } else {
        print('请求错误: ${e.message}');
      }
    } catch (e) {
      print('其他错误: $e');
    }
  }

  Future<bool?> setAvatarInfoData(List<Character> list) async {
    String? apiUrl = dotenv.env['API_URL'];
    if (apiUrl == null) {
      throw Exception('API_URL is not defined in .env file');
    }
    // newBody
    try {
      final Response result = await _dio.post(
        "$apiUrl/api/avatar_info_list",
        data: list.map((avatar) => avatar.toJson()).toList(),
        options: Options(
          headers: {
            "content-type": "application/json",
            'x-pre-signature': getSignature('wx9b4faf458899421f'),
          },
        ),
      );
      if (result.statusCode == 200) {
        final ApiResult apiResult = ApiResult.fromJson(result.data);
        if (apiResult.code == 200) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('请求URL: ${e.requestOptions.uri}');
        print('请求头: ${e.requestOptions.headers}');
        print('请求数据: ${e.requestOptions.data}');
        print('响应状态码: ${e.response?.statusCode}');
        print('响应数据: ${e.response?.data}');
      } else {
        print('请求错误: ${e.message}');
      }
    } catch (e) {
      print('其他错误: $e');
    }
  }
}
