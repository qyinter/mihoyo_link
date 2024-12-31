import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:uuid/uuid.dart';
import 'package:yuanmo_link/model/mihoyo_fp.dart';
import 'package:yuanmo_link/model/mihoyo_game_role.dart';
import 'package:yuanmo_link/model/mihoyo_login.dart';
import 'package:yuanmo_link/model/mihoyo_mmt.dart';
import 'package:yuanmo_link/model/mihoyo_result.dart';
import 'package:yuanmo_link/model/mihoyo_token.dart';
import 'package:yuanmo_link/model/mihoyo_user_info.dart';
import 'package:yuanmo_link/model/mihoyo_qrcode.dart';
import 'package:yuanmo_link/model/mihoyo_zzz_%20avatar_info.dart';
import 'package:yuanmo_link/model/mihoyo_zzz_%20avatar_list.dart';
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

  /// aes加密
  String rsaEncrypt(String message) {
    const publicKey = '''-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDvekdPMHN3AYhm/vktJT+YJr7
cI5DcsNKqdsx5DZX0gDuWFuIjzdwButrIYPNmRJ1G8ybDIF7oDW2eEpm5sMbL9zs
9ExXCdvqrn51qELbqj0XxtMTIpaCHFSI50PfPpTFV9Xt/hmyVwokoOXFlAEgCn+Q
CgGs52bFoYMtyi+xEQIDAQAB
-----END PUBLIC KEY-----''';

    final parser = RSAKeyParser();
    final RSAPublicKey rsaPublicKey = parser.parse(publicKey) as RSAPublicKey;
    final encrypter = Encrypter(RSA(publicKey: rsaPublicKey, encoding: RSAEncoding.PKCS1));

    final encrypted = encrypter.encrypt(message);
    return base64.encode(encrypted.bytes);
  }

  //  fp
  String generateCustomId() {
    final random = Random();
    const length = 13;
    const prefix = '38';
    const chars = '0123456789abcdef';

    String randomString =
        List.generate(length - prefix.length, (index) => chars[random.nextInt(chars.length)]).join('');

    return '$prefix$randomString';
  }

  Map<String, String> brandMapping = {
    "Xiaomi": "小米手机",
    "Apple": "苹果手机",
    "Samsung": "三星手机",
    "Huawei": "华为手机",
    "Oppo": "OPPO手机",
    "Vivo": "VIVO手机",
    "OnePlus": "一加手机",
    "Google": "谷歌手机",
    "Sony": "索尼手机",
    "LG": "LG手机",
    "Nokia": "诺基亚手机",
    "Asus": "华硕手机",
    "HTC": "HTC手机",
    "Motorola": "摩托罗拉手机",
    "Realme": "真我手机",
  };

  int parseInt(dynamic value, String fieldName) {
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? (throw FormatException("Cannot parse $fieldName to int: $value"));
    }
    throw FormatException("Invalid type for $fieldName: ${value.runtimeType}");
  }

  String parseString(dynamic value, String fieldName) {
    if (value is String) return value;
    return value.toString();
  }

  Future<Void?> getAndroidFp() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    const platform = MethodChannel('com.qyinter.miyou_link/device');
    final result = await platform.invokeMapMethod<String, dynamic>('getDeviceInfo');
    final oaidMap = await platform.invokeMapMethod<String, dynamic>('getOaid');
    final deviceIdMap = await platform.invokeMapMethod<String, dynamic>('getDeviceId');
    final androidIdMap = await platform.invokeMapMethod<String, dynamic>('getAndroidId');

    var androidInfo = await deviceInfoPlugin.androidInfo;
    final sdCapacity = result?['sdCapacity'] ?? 'unknown';
    final ramRemain = result?['ramRemain'] ?? 'unknown';
    final screenSize = result?['screenSize'] ?? 'unknown';
    final hostName = result?['hostName'] ?? 'unknown';
    final buildTags = result?['buildTags'] ?? 'unknown';
    final buildType = result?['buildType'] ?? 'unknown';
    final buildTime = result?['buildTime'] ?? 'unknown';
    final buildUser = result?['buildUser'] ?? 'unknown';
    final simState = result?['simState'] ?? 'unknown';
    final cpuType = result?['cpuType'] ?? 'unknown';
    final manufacturer = result?['manufacturer'] ?? 'unknown';

    var uuid = const Uuid().v4();
    var bbs_device_id = const Uuid().v4();

    String brand = brandMapping[androidInfo.brand] ?? '未知品牌';
    final fpBody = FpBody(
      device_id: androidIdMap?['androidId'] ?? const Uuid().v4(),
      seed_id: uuid,
      seed_time: "${DateTime.now().millisecondsSinceEpoch}",
      platform: "2",
      device_fp: Global.fpInfo.deviceFp != "" ? Global.fpInfo.deviceFp : "0331573827",
      app_name: "bbs_cn",
      ext_fields:
          "{\"proxyStatus\":0,\"isRoot\":0,\"romCapacity\":\"512\",\"deviceName\":\"$brand\",\"productName\":\"${androidInfo.device}\",\"romRemain\":\"497\",\"hostname\":\"$hostName\",\"screenSize\":\"$screenSize\",\"isTablet\":0,\"aaid\":\"error_1008003\",\"model\":\"${androidInfo.model}\",\"brand\":\"${androidInfo.brand}\",\"hardware\":\"${androidInfo.hardware}\",\"deviceType\":\"${androidInfo.device}\",\"devId\":\"REL\",\"serialNumber\":\"unknown\",\"sdCapacity\":$sdCapacity,\"buildTime\":\"$buildTime\",\"buildUser\":\"$buildUser\",\"simState\":$simState,\"ramRemain\":\"$ramRemain\",\"appUpdateTimeDiff\":1721572819246,\"deviceInfo\":\"${androidInfo.brand}\\/${androidInfo.device}\\/${androidInfo.device}:${androidInfo.version.release}\\/${androidInfo.display}\\/${androidInfo.version.incremental}:$buildType\\/$buildTags\",\"vaid\":\"error_1008003\",\"buildType\":\"$buildType\",\"sdkVersion\":\"${androidInfo.version.sdkInt}\",\"ui_mode\":\"UI_MODE_TYPE_NORMAL\",\"isMockLocation\":0,\"cpuType\":\"$cpuType\",\"isAirMode\":0,\"ringMode\":1,\"chargeStatus\":3,\"manufacturer\":\"$manufacturer\",\"emulatorStatus\":0,\"appMemory\":\"512\",\"osVersion\":\"${androidInfo.version.release}\",\"vendor\":\"unknown\",\"accelerometer\":\"1.1918782x4.003556x8.735291\",\"sdRemain\":$ramRemain,\"buildTags\":\"$buildTags\",\"packageName\":\"com.mihoyo.hyperion\",\"networkType\":\"WiFi\",\"oaid\":\"${oaidMap?['oaid'] ?? 'unknown'}\",\"debugStatus\":1,\"ramCapacity\":\"$sdCapacity\",\"magnetometer\":\"-60.929684x-44.194122x42.59439\",\"display\":\"${androidInfo.display}\",\"appInstallTimeDiff\":1721572819246,\"packageVersion\":\"2.20.2\",\"gyroscope\":\"-0.0023837525x0.08423652x0.005653145\",\"batteryStatus\":79,\"hasKeyboard\":0,\"board\":\"${androidInfo.board}\"}",
      bbs_device_id: "${deviceIdMap?['deviceId'] ?? bbs_device_id}",
    );

    final Response fpRes = await _dio.post(
      "https://public-data-api.mihoyo.com/device-fp/api/getFp",
      data: fpBody.toJson(),
      options: Options(
        headers: {"Content-Type": "application/json;charset=utf-8"},
      ),
    );
    if (fpRes.statusCode == 200) {
      final MihoyoResult<FpResult> resp = MihoyoResult<FpResult>.fromJson(
        fpRes.data,
        (json) => FpResult.fromJson(json),
      );
      if (resp.retcode == 0 && resp.data != null) {
        final info = FpInfo(
          deviceFp: resp.data!.device_fp,
          bbsDeviceId: deviceIdMap?['deviceId'] ?? bbs_device_id,
          sysVsersion: androidInfo.version.release,
          deviceName: Uri.encodeComponent(brand),
          deviceModel: androidInfo.model,
          brand: androidInfo.brand,
        );
        Global.saveFpInfo(info);
      } else {
        Global.saveFpInfo(
          FpInfo(
              deviceFp: generateCustomId(),
              bbsDeviceId: const Uuid().v4(),
              sysVsersion: "12",
              deviceName: "%E5%B0%8F%E7%B1%B3%E6%89%8B%E6%9C%BA",
              deviceModel: "MI 14",
              brand: "Xiaomi"),
        );
      }
    } else {
      Global.saveFpInfo(
        FpInfo(
            deviceFp: generateCustomId(),
            bbsDeviceId: const Uuid().v4(),
            sysVsersion: "12",
            deviceName: "%E5%B0%8F%E7%B1%B3%E6%89%8B%E6%9C%BA",
            deviceModel: "MI 14",
            brand: "Xiaomi"),
      );
    }
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
          final match = regex.firstMatch(resp.data!.url);
          final tickerId = match!.group(1) ?? '';
          return QrCodeResult(url: resp.data!.url, uuid: uuid, ticket: tickerId);
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
          "x-rpc-device_id": Global.fpInfo.bbsDeviceId,
          "DS": getDs()
        },
      ),
    );

    if (result.statusCode == 200) {
      final MihoyoResult<MihoyoLtoken> resp = MihoyoResult<MihoyoLtoken>.fromJson(
        result.data,
        (json) => MihoyoLtoken.fromJson(json),
      );
      if (resp.retcode == 0 && resp.data != null) {
        return resp.data!.ltoken;
      } else {
        throw Exception("Failed to check scan status: ${resp.retcode}");
      }
    } else {
      throw Exception("Failed to check scan status");
    }
  }

  /// 获取所有游戏的游戏角色信息
  Future<List<GameRoleInfo>> getGameRolesInfo(String cookie) async {
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
            "x-rpc-device_id": Global.fpInfo.bbsDeviceId,
            "DS": getDs()
          },
        ),
      );
      if (result.statusCode == 200) {
        final MihoyoResult<MihoyoGameRoleData> resp = MihoyoResult<MihoyoGameRoleData>.fromJson(
          result.data,
          (json) => MihoyoGameRoleData.fromJson(json),
        );
        if (resp.retcode == 0 && resp.data != null) {
          // 取出cookie
          if (resp.data!.list.isNotEmpty) {
            Global.gameRoleList.add(GameRoleInfo(
                gameName: game.gameName,
                gameIcon: game.gameIcon,
                list: resp.data!.list,
                baseWishUrl: game.baseWishUrl));
          }
        }
      }
    }
    // 将数据持久化
    // Global.saveGameRoleList(Global.gameRoleList);
    return Global.gameRoleList;
  }

  /// 获取所有游戏内的抽卡链接
  Future<String?> getAuthkey(MihoyoGameRole role, GameRoleInfo info) async {
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
          "x-rpc-device_id": Global.fpInfo.bbsDeviceId,
          "DS": getDs()
        },
      ),
    );

    if (result.statusCode == 200) {
      final MihoyoResult<AuthKeyResult> resp = MihoyoResult<AuthKeyResult>.fromJson(
        result.data,
        (json) => AuthKeyResult.fromJson(json),
      );
      if (resp.retcode == 0 && resp.data != null) {
        // 取出cookie
        if (resp.data!.authkey.isNotEmpty) {
          final authkey = Uri.encodeComponent(resp.data!.authkey);
          return "${info.baseWishUrl}win_mode=fullscreen&authkey_ver=1&sign_type=2&auth_appid=webview_gacha&init_type=301&gacha_id=b4ac24d133739b7b1d55173f30ccf980e0b73fc1&lang=zh-cn&device_type=mobile&game_version=CNRELiOS3.0.0_R10283122_S10446836_D10316937&plat_type=ios&game_biz=${role.gameBiz}&size=20&authkey=$authkey&region=${role.region}&timestamp=1664481732&gacha_type=200&page=1&end_id=0";
        }
      }
    }
    return null;
  }

  /// 获取手机验证码
  Future<ApiLoginData?> getPhoneCode(String phone) async {
    final t = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final Response result = await _dio.get(
      "https://webapi.account.mihoyo.com/Api/create_mmt?scene_type=1&now=$t&reason=user.mihoyo.com%23%2Flogin%2Fcaptcha&action_type=login_by_mobile_captcha&t=$t",
      options: Options(
        headers: {
          "Content-Type": "application/json;charset=utf-8",
          "x-rpc-device_id": Global.fpInfo.bbsDeviceId,
        },
      ),
    );
    if (result.statusCode == 200) {
      final ApiLoginResponse<ApiLoginData> resp = ApiLoginResponse<ApiLoginData>.fromJson(
        result.data,
        (json) => ApiLoginData.fromJson(json),
      );
      if (resp.code == 200) {
        return resp.data;
      } else {
        throw Exception("Failed to get phone code: ${resp.code}");
      }
    }
    return null;
  }

  /// 发送验证码 网页
  Future<String?> sendPhoneCode(SendPhoneModel resultForm) async {
    final url =
        "https://webapi.account.mihoyo.com/Api/create_mobile_captcha?action_type=${resultForm.actionType}&mmt_key=${resultForm.mmtKey}&geetest_challenge=${resultForm.geetestChallenge}&geetest_validate=${resultForm.geetestValidate}&geetest_seccode=${resultForm.geetestSeccode}&mobile=${resultForm.mobile}&t=${resultForm.t}";
    final Response result = await _dio.get(
      url,
      options: Options(
        headers: {
          "Content-Type": "application/json;charset=utf-8",
          "x-rpc-device_id": Global.fpInfo.bbsDeviceId,
        },
      ),
    );
    if (result.statusCode == 200) {
      final ApiLoginResponse<SendPhoneResponse> resp = ApiLoginResponse<SendPhoneResponse>.fromJson(
        result.data,
        (json) => SendPhoneResponse.fromJson(json),
      );

      if (resp.data.status == 1) {
        return "发送成功";
      }
    } else {
      final errorResult = SendPhoneResponse.fromJson(result.data);
      return errorResult.info;
    }
    return "发送失败, 请稍后重试";
  }

  /// 发送验证码 客户端
  Future<MmtResult?> sendPhoneByMiyoushe(String phone, String? rpcAigis) async {
    final headers = {
      "Host": "passport-api.mihoyo.com",
      "Content-Type": "application/json",
      "User-Agent": "Hyperion/453 CFNetwork/1496.0.7 Darwin/23.5.0",
      "x-rpc-account_version": "2.20.1",
      "x-rpc-app_id": "bll8iq97cem8",
      "x-rpc-device_fp": generateCustomId(),
      "x-rpc-app_version": "2.71.1",
      "DS": getDs(),
      "x-rpc-client_type": "1",
      "x-rpc-device_id": Global.fpInfo.bbsDeviceId,
      "x-rpc-sdk_version": "2.20.1",
      "x-rpc-sys_version": Global.fpInfo.sysVsersion,
      "x-rpc-game_biz": "bbs_cn"
    };
    if (rpcAigis != null) {
      headers["X-Rpc-Aigis"] = rpcAigis;
    }

    final Response result = await _dio.post(
      "https://passport-api.miyoushe.com/account/ma-cn-verifier/verifier/createLoginCaptcha",
      data: {"mobile": rsaEncrypt(phone), "area_code": rsaEncrypt("+86")},
      options: Options(
        headers: headers,
      ),
    );
    MmtResult map = MmtResult(isOk: false, message: "", mmtModel: null, userInfo: null);
    if (result.statusCode == 200) {
      final MihoyoResult<CaptchaSendData> resp = MihoyoResult<CaptchaSendData>.fromJson(
        result.data,
        (json) => CaptchaSendData.fromJson(json),
      );

      if (resp.retcode == 0) {
        map.isOk = true;
        map.message = "发送成功";
      } else {
        map.isOk = false;
        map.message = resp.message;
        final aigis = result.headers.value("X-Rpc-Aigis");
        if (aigis != null) {
          final mainModel = MmtMainModel.fromJson(jsonDecode(aigis));
          map.mmtModel = mainModel;
        }
      }
    }
    return map;
  }

  /// 账号密码登录
  Future<MmtResult?> loginByPassword(String account, String password, String? rpcAigis) async {
    final headers = {
      "Host": "passport-api.mihoyo.com",
      "Content-Type": "application/json",
      "x-rpc-account_version": "2.20.1",
      "x-rpc-app_id": "bll8iq97cem8",
      "x-rpc-device_fp": Global.fpInfo.deviceFp,
      "x-rpc-app_version": "2.71.1",
      "DS": getDs(),
      "x-rpc-client_type": "1",
      "x-rpc-device_id": Global.fpInfo.bbsDeviceId,
      "x-rpc-sdk_version": "2.20.1",
      "x-rpc-sys_version": Global.fpInfo.sysVsersion,
      'x-rpc-device_name': Global.fpInfo.deviceName,
      'x-rpc-device_model': Global.fpInfo.deviceModel,
      "x-rpc-game_biz": "bbs_cn"
    };

    if (rpcAigis != null) {
      headers["X-Rpc-Aigis"] = rpcAigis;
    }

    final Response result = await _dio.post(
      "https://passport-api.mihoyo.com/account/ma-cn-passport/app/loginByPassword",
      data: {"account": rsaEncrypt(account), "password": rsaEncrypt(password)},
      options: Options(
        headers: headers,
      ),
    );

    MmtResult map = MmtResult(isOk: false, message: "", mmtModel: null, userInfo: null);
    if (result.statusCode == 200) {
      final MihoyoResult<MihoyoUserInfo> resp = MihoyoResult<MihoyoUserInfo>.fromJson(
        result.data,
        (json) => MihoyoUserInfo.fromJson(json),
      );
      if (resp.retcode == 0) {
        map.userInfo = resp.data;
        map.isOk = true;
      } else {
        map.isOk = false;
        map.message = resp.message;
        final aigis = result.headers.value("X-Rpc-Aigis");
        if (aigis != null) {
          final mainModel = MmtMainModel.fromJson(jsonDecode(aigis));
          map.mmtModel = mainModel;
        }
      }
    } else {
      map.isOk = false;
      map.message = "登录失败";
    }
    return map;
  }

  /// 验证码登录
  Future<MihoyoUserInfo?> loginByPhone(String phone, String code) async {
    final uuid = const Uuid().v4();
    final Response result = await _dio.post(
      "https://passport-api.mihoyo.com/account/ma-cn-passport/app/loginByMobileCaptcha",
      data: {
        "mobile": rsaEncrypt(phone),
        "captcha": code,
        "area_code": rsaEncrypt("+86"),
        "action_type": "login_by_mobile_captcha"
      },
      options: Options(
        headers: {
          "Host": "passport-api.mihoyo.com",
          "Content-Type": "application/json",
          "User-Agent": "Hyperion/453 CFNetwork/1496.0.7 Darwin/23.5.0",
          "x-rpc-account_version": "2.20.1",
          "x-rpc-app_id": "bll8iq97cem8",
          "x-rpc-device_fp": Global.fpInfo.deviceFp,
          "x-rpc-app_version": "2.71.1",
          "DS": getDs(),
          "x-rpc-client_type": "1",
          "x-rpc-device_id": Global.fpInfo.bbsDeviceId,
          "x-rpc-sdk_version": "2.20.1",
          "x-rpc-sys_version": Global.fpInfo.sysVsersion,
          "x-rpc-game_biz": "bbs_cn"
        },
      ),
    );
    if (result.statusCode == 200) {
      final MihoyoResult<MihoyoUserInfo> resp = MihoyoResult<MihoyoUserInfo>.fromJson(
        result.data,
        (json) => MihoyoUserInfo.fromJson(json),
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

  /// 获取所有角色基本信息
  Future<ZZZAvatarList?> getCharacterInfo(MihoyoGameRole role, GameRoleInfo info) async {
    final uuid = const Uuid().v4();
    final Response result = await _dio.get(
      "https://api-takumi-record.mihoyo.com/event/game_record_zzz/api/zzz/avatar/basic?server=${role.region}&role_id=${role.gameUid}",
      options: Options(
        headers: {
          'Host': 'api-takumi-record.mihoyo.com',
          'x-rpc-platform': '2',
          'Origin': 'https://act.mihoyo.com',
          'x-rpc-geetest_ext': '{"viewUid":"0","gameId":8,"page":"v1.0.20_#/zzz/roles/all","isHost":1}',
          'x-rpc-app_version': '2.73.1',
          'x-rpc-language': 'zh-cn',
          'x-rpc-device_id': Global.fpInfo.bbsDeviceId,
          'x-rpc-device_name': "${Global.fpInfo.brand} ${Global.fpInfo.deviceModel}",
          'x-rpc-page': 'v1.0.20_#/zzz/roles/all',
          "x-rpc-device_fp": Global.fpInfo.deviceFp,
          'x-rpc-lang': 'zh-cn',
          'x-rpc-sys_version': Global.fpInfo.sysVsersion,
          'Referer':
              'https://act.mihoyo.com/app/mihoyo-zzz-game-record/m.html?mhy_presentation_style=fullscreen&bbs_auth_required=true&game_id%5B0%5D=8&game_id%5B1%5D=8&user_id=${Global.miyousheAcount}&uid=${Global.miyousheAcount}',
          "Cookie": Global.mihoyoCookie,
          "X-Requested-With": "com.mihoyo.hyperion"
        },
      ),
    );
    if (result.statusCode == 200) {
      final MihoyoResult<ZZZAvatarList> resp = MihoyoResult<ZZZAvatarList>.fromJson(
        result.data,
        (json) => ZZZAvatarList.fromJson(json),
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

  /// 获取所有角色基本信息
  Future<Character?> getCharacterInfoById(MihoyoGameRole role, GameRoleInfo info, int id) async {
    final Response result = await _dio.get(
      "https://api-takumi-record.mihoyo.com/event/game_record_zzz/api/zzz/avatar/info?id_list[]=$id&need_wiki=true&server=${role.region}&role_id=${role.gameUid}",
      options: Options(
        headers: {
          'Host': 'api-takumi-record.mihoyo.com',
          'x-rpc-platform': '2',
          'Origin': 'https://act.mihoyo.com',
          'x-rpc-geetest_ext': '{"viewUid":"0","gameId":8,"page":"v1.0.20_#/zzz/roles/all","isHost":1}',
          'x-rpc-app_version': '2.73.1',
          'x-rpc-language': 'zh-cn',
          'x-rpc-device_id': Global.fpInfo.bbsDeviceId,
          'x-rpc-device_name': "${Global.fpInfo.brand} ${Global.fpInfo.deviceModel}",
          'x-rpc-page': 'v1.0.20_#/zzz/roles/all',
          "x-rpc-device_fp": Global.fpInfo.deviceFp,
          'x-rpc-lang': 'zh-cn',
          'x-rpc-sys_version': Global.fpInfo.sysVsersion,
          'Referer':
              'https://act.mihoyo.com/app/mihoyo-zzz-game-record/m.html?mhy_presentation_style=fullscreen&bbs_auth_required=true&game_id%5B0%5D=8&game_id%5B1%5D=8&user_id=${Global.miyousheAcount}&uid=${Global.miyousheAcount}',
          "Cookie": Global.mihoyoCookie,
          "X-Requested-With": "com.mihoyo.hyperion"
        },
      ),
    );

    if (result.statusCode == 200) {
      final MihoyoResult<AvatarModel> resp = MihoyoResult<AvatarModel>.fromJson(
        result.data,
        (json) => AvatarModel.fromJson(json),
      );
      if (resp.retcode == 0 && resp.data!.avatarList.isNotEmpty) {
        resp.data!.avatarList[0].uid = int.parse(role.gameUid);
        return resp.data!.avatarList[0];
      } else {
        throw Exception("Failed to check scan status: ${resp.retcode}");
      }
    } else {
      throw Exception("Failed to check scan status");
    }
  }
}
