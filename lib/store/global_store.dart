import 'package:flutter/foundation.dart';
import 'package:yuanmo_link/model/mihoyo_result.dart';
import 'package:yuanmo_link/store/global.dart';
import 'package:yuanmo_link/model/mihoyo_user_info.dart';

class GlobalChangeNotifier extends ChangeNotifier {
  List<GameRoleInfo> get _gameRoleList => Global.gameRoleList;
  UserInfo? get _userInfo => Global.userInfo; // 用户信息

  saveGameRoleList(List<GameRoleInfo> list) {
    Global.saveGameRoleList(list);
    notifyListeners();
  }

  saveUserInfo(UserInfo? userInfo) {
    if (userInfo != null) {
      Global.saveUserInfo(userInfo);
    }
    notifyListeners();
  }
}
