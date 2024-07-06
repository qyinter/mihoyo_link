import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'package:yuanmo_link/model/mihoyo_game_role.dart';
import 'package:yuanmo_link/model/mihoyo_result.dart';
import 'package:yuanmo_link/model/mihoyo_token.dart';
import 'package:yuanmo_link/model/mihoyo_user_info.dart';
import 'package:yuanmo_link/model/mihoyo_qrcode.dart';
import 'package:yuanmo_link/store/global.dart';

/// mihoyoBaseUrl
const String mihoyoBaseUrl = "https://api-takumi.mihoyo.com";

/// mihoyoSdkBaseUrl
const String mihoyoSdkBaseUrl = "https://hk4e-sdk.mihoyo.com";

/// 取game登录二维码
const String mihoyoLoginQrCodePath = "/hk4e_cn/combo/panda/qrcode/fetch";

/// 取二维码扫码状态
const String mihoyoCheckScanStatusPath = "/hk4e_cn/combo/panda/qrcode/query";

/// game token 换stoken
const String mihoyoExchangeGameTokenForSTokenPath = "/account/ma-cn-session/app/getTokenByGameToken";

/// 获取ltoken
const String mihoyoGetGameRolesInfoPath = "/binding/api/getUserGameRolesByCookie";

/// 获取authkey
const String mihoyoAuthKey = "/binding/api/genAuthKey";

class MiHoYoUtils {
  final _dio = Dio();

  /// 获取ds算法
  static String getDs() {
    const salt = "EJncUPGnOHajenjLhBOsdpwEMZmiCmQX";
    final time = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final str = getStr();
    final key = "salt=$salt&t=$time&r=$str";
    final md5 = md5Hash(key);

    return "$time,$str,$md5";
  }

  /// 生成随机字符串
  static String getStr() {
    const chars = "ABCDEFGHJKMNPQRSTWXYZabcdefhijkmnprstwxyz2345678";
    const maxPos = chars.length;
    final rand = Random();
    var code = "";
    for (var i = 0; i < 6; i++) {
      code += chars[rand.nextInt(maxPos)];
    }
    return code;
  }

  /// md5加密
  static String md5Hash(String data) {
    return md5.convert(utf8.encode(data)).toString();
  }

  /// 获取游戏登录二维码
  Future<QrCodeResult?> getGameLodinQrCode() async {
    var uuid = const Uuid().v4();
    var qrcodeModel = QrcodeModel(
      appId: '4',
      device: uuid,
      ticket: '',
      payload: '',
    );

    try {
      Response response = await _dio.post(
        "$mihoyoSdkBaseUrl$mihoyoLoginQrCodePath",
        data: qrcodeModel.toJson(),
      );
      if (response.statusCode == 200) {
        final MihoyoResult<QrCodeRespData> resp = MihoyoResult<QrCodeRespData>.fromJson(
          response.data,
          (json) => QrCodeRespData.fromJson(json),
        );
        if (resp.retcode == 0) {
          final regex = RegExp(r'ticket=([^&]*)');
          final match = regex.firstMatch(resp.data.url);
          final tickerId = match!.group(1) ?? '';
          return QrCodeResult(url: resp.data.url, uuid: uuid, ticket: tickerId);
        } else {
          throw Exception('Failed to load QR code: ${resp.retcode}');
        }
      } else {
        throw Exception('Failed to load QR code');
      }
    } catch (e) {
      throw Exception('Failed to load QR code: $e');
    }
  }

  /// 检查扫码状态
  Future<QrCodeStatus?> checkScanStatus(QrCodeResult qrcode) async {
    final QrcodeModel qrcodeModel = QrcodeModel(appId: "4", device: qrcode.uuid, ticket: qrcode.ticket, payload: "");
    final Response scanStatus = await _dio.post(
      "$mihoyoSdkBaseUrl$mihoyoCheckScanStatusPath",
      data: qrcodeModel.toJson(),
      options: Options(
        headers: {"Content-Type": "application/json;charset=utf-8"},
      ),
    );
    if (scanStatus.statusCode == 200) {
      final MihoyoResult<QrCodeStatus> resp = MihoyoResult<QrCodeStatus>.fromJson(
        scanStatus.data,
        (json) => QrCodeStatus.fromJson(json),
      );
      if (resp.retcode == 0) {
        return resp.data;
      } else {
        throw Exception("Failed to check scan status: ${resp.retcode}");
      }
    } else {
      throw Exception("Failed to check scan status");
    }
  }

  /// game_token 换stoken
  Future<MihoyoUserInfo?> exchangeGameTokenForSToken(QrCodeStatusRaw raw) async {
    int uid = int.parse(raw.uid);
    final GameTokenModel tokenModel = GameTokenModel(accountId: uid, gameToken: raw.token);

    // cookie manage
    final Response tokenResult = await _dio.post(
      "$mihoyoBaseUrl$mihoyoExchangeGameTokenForSTokenPath",
      data: tokenModel.toJson(),
      options: Options(
        headers: {"Content-Type": "application/json;charset=utf-8", "x-rpc-app_id": "bll8iq97cem8"},
      ),
    );
    if (tokenResult.statusCode == 200) {
      final MihoyoResult<MihoyoUserInfo> resp = MihoyoResult<MihoyoUserInfo>.fromJson(
        tokenResult.data,
        (json) => MihoyoUserInfo.fromJson(json),
      );
      if (resp.retcode == 0) {
        // 取出cookie
        return resp.data;
      } else {
        throw Exception("Failed to check scan status: ${resp.retcode}");
      }
    } else {
      throw Exception("Failed to check scan status");
    }
  }

  /// 获取ltoken
  Future<String?> getLTokenBySToken(String cookie) async {
    final Response result = await _dio.get(
      "https://passport-api.mihoyo.com/account/auth/api/getLTokenBySToken",
      options: Options(
        headers: {
          'User-Agent': 'okhttp/4.8.0',
          "Content-Type": "application/json;charset=utf-8",
          "Cookie": cookie,
          "x-rpc-client_type": "5",
          "x-rpc-app_version": "2.71.1",
          "x-rpc-device_id": const Uuid().v4(),
          "DS": getDs()
        },
      ),
    );

    if (result.statusCode == 200) {
      final MihoyoResult<MihoyoLtoken> resp = MihoyoResult<MihoyoLtoken>.fromJson(
        result.data,
        (json) => MihoyoLtoken.fromJson(json),
      );
      if (resp.retcode == 0) {
        return resp.data.ltoken;
      } else {
        throw Exception("Failed to check scan status: ${resp.retcode}");
      }
    } else {
      throw Exception("Failed to check scan status");
    }
  }

  /// 获取所有游戏的游戏角色信息
  Future<void> getGameRolesInfo(String cookie) async {
    Global.gameRoleList = [];
    for (var game in Global.GameList) {
      final Response result = await _dio.get(
        "$mihoyoBaseUrl$mihoyoGetGameRolesInfoPath?game_biz=${game.gameBiz}",
        options: Options(
          headers: {
            'User-Agent': 'okhttp/4.8.0',
            "Content-Type": "application/json;charset=utf-8",
            "Cookie": cookie,
            "x-rpc-client_type": "5",
            "x-rpc-app_version": "2.71.1",
            "x-rpc-device_id": const Uuid().v4(),
            "DS": getDs()
          },
        ),
      );

      if (result.statusCode == 200) {
        final MihoyoResult<MihoyoGameRoleData> resp = MihoyoResult<MihoyoGameRoleData>.fromJson(
          result.data,
          (json) => MihoyoGameRoleData.fromJson(json),
        );
        if (resp.retcode == 0) {
          // 取出cookie
          if (resp.data.list.isNotEmpty) {
            Global.gameRoleList
                .add(GameRoleInfo(gameName: game.gameName, gameIcon: game.gameIcon, list: resp.data.list));
          }
        }
      }
    }

    // 将数据持久化
    Global.saveGameRoleList(Global.gameRoleList);
  }

  /// 获取所有游戏内的抽卡链接
  Future<void> getAuthkey(MihoyoGameRole role) async {
    print(role);

    int uid = int.parse(role.gameUid);
    final body = AuthKeyModel(gameBiz: role.gameBiz, gameUid: uid, authAppid: "webview_gacha", region: role.region);

    final Response result = await _dio.post(
      "$mihoyoBaseUrl$mihoyoAuthKey",
      data: body.toJson(),
      options: Options(
        headers: {
          'Host': 'api-takumi.mihoyo.com',
          "Content-Type": "application/json;charset=utf-8",
          "Cookie": Global.mihoyoCookie,
          "x-rpc-client_type": "5",
          "x-rpc-app_version": "2.71.1",
          "x-rpc-device_id": const Uuid().v4(),
          "DS": getDs()
        },
      ),
    );

    if (result.statusCode == 200) {
      print(result.data);

      // final MihoyoResult<MihoyoGameRoleData> resp = MihoyoResult<MihoyoGameRoleData>.fromJson(
      //   result.data,
      //   (json) => MihoyoGameRoleData.fromJson(json),
      // );
      // if (resp.retcode == 0) {
      //   // 取出cookie
      //   if (resp.data.list.isNotEmpty) {
      //     Global.gameRoleList.add(GameRoleInfo(gameName: game.gameName, gameIcon: game.gameIcon, list: resp.data.list));
      //   }
      // }
    }
  }
}
