import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalState with ChangeNotifier {
  String _stoken = ''; // stoken
  String _miyousheAcount = ''; // 米游社账号

  String get stoken => _stoken;
  String get miyousheAcount => _miyousheAcount;

  GlobalState() {
    _loadFromPrefs();
  }

  void _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _stoken = prefs.getString('stoken') ?? '';
    _miyousheAcount = prefs.getString('miyousheAcount') ?? '';
    notifyListeners();
  }

  void setStoken(String stoken) {
    _stoken = stoken;
    _saveToPrefs();
    notifyListeners();
  }

  void setMiyousheAcount(String miyousheAcount) {
    _miyousheAcount = miyousheAcount;
    _saveToPrefs();
    notifyListeners();
  }

  void _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('stoken', _stoken);
    prefs.setString('miyousheAcount', _miyousheAcount);
  }
}
