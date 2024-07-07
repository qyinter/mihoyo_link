import 'dart:convert';

import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yuanmo_link/model/mihoyo_result.dart';
import 'package:yuanmo_link/model/mihoyo_user_info.dart';

class Global {
  static late SharedPreferences _prefs;

  static final List<GameType> GameList = [
    GameType("原神", "hk4e_cn", "genshin", "assets/images/hk4e_cn.png",
        "https://public-operation-nap.mihoyo.com/common/gacha_record/api/getGachaLog?"),
    GameType("绝区零", "nap_cn", "zzz", "assets/images/nap_cn.png",
        "https://public-operation-hk4e.mihoyo.com/gacha_info/api/getGachaLog?"),
    // GameType("崩坏：星穹铁道", "hkrpg_cn", "startrain", "assets/images/hkrpg_cn.png"),
    // GameType("崩坏3", "bh3_cn", "honkai3", "assets/images/bh3_cn.png"),
  ];

  // 所有游戏的角色list
  static List<GameRoleInfo> gameRoleList = [];

  static String stoken = ""; // stoken
  static String miyousheAcount = ""; // 米游社账号
  static String mid = ""; //  mihoyo id
  static String mihoyoCookie = ""; // 米哈游cookie

  static UserInfo? userInfo; // 用户信息

  // 是否为release版
  // static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  //初始化全局信息，会在APP启动时执行
  static Future init() async {
    BrnInitializer.register();
    WidgetsFlutterBinding.ensureInitialized();

    _prefs = await SharedPreferences.getInstance();
    var stoken_ = _prefs.getString("stoken");
    if (stoken_ != null) {
      stoken = stoken_;
    }
    var miyousheAcount_ = _prefs.getString("miyousheAcount");
    if (miyousheAcount_ != null) {
      miyousheAcount = miyousheAcount_;
    }
    var mid_ = _prefs.getString("mid");
    if (mid_ != null) {
      mid = mid_;
    }

    var mihoyoCookie_ = _prefs.getString("mihoyoCookie");
    if (mihoyoCookie_ != null) {
      mihoyoCookie = mihoyoCookie_;
    }

    gameRoleList = loadGameRoleList();

    var userInfo_ = _prefs.getString("userInfo");
    if (userInfo_ != null) {
      userInfo = UserInfo.fromJson(jsonDecode(userInfo_));
    }
  }

  // 持久化Profile信息
  static saveStoken(s) => {stoken = s, _prefs.setString("stoken", stoken)};
  // 持久化米游社账号信息
  static saveMiyousheAcount(ma) => {miyousheAcount = ma, _prefs.setString("miyousheAcount", miyousheAcount)};
  // 持久化米游社账号信息
  static saveMid(m) => {mid = m, _prefs.setString("mid", mid)};
  // 持久化米哈游cookie信息
  static saveMihoyoCookie(m) => {mihoyoCookie = m, _prefs.setString("mihoyoCookie", mihoyoCookie)};
  // 持久化缓存所有游戏的角色数据信息
  static Future<void> saveGameRoleList(List<GameRoleInfo> roleList) async {
    gameRoleList = roleList;
    final List<Map<String, dynamic>> jsonList = roleList.map((role) => role.toJson()).toList();
    final String jsonString = jsonEncode(jsonList);
    await _prefs.setString("gamelist", jsonString);
  }

  // 加载缓存的所有游戏的角色数据信息
  static List<GameRoleInfo> loadGameRoleList() {
    final String? jsonString = _prefs.getString("gamelist");
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => GameRoleInfo.fromJson(json)).toList();
    }
    return [];
  }

  // 持久化缓存用户信息
  static saveUserInfo(UserInfo info) async {
    userInfo = info;
    await _prefs.setString("userInfo", jsonEncode(info.toJson()));
  }

  // 清空缓存
  static clearAll() {
    _prefs.clear();
    gameRoleList = [];
    stoken = "";
    miyousheAcount = "";
    mid = "";
    mihoyoCookie = "";
    userInfo = null;
  }
}
