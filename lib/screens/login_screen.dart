import 'dart:async';
import 'dart:convert';

import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:gt3_flutter_plugin/gt3_flutter_plugin.dart';
import 'package:gt4_flutter_plugin/gt4_flutter_plugin.dart';
import 'package:gt4_flutter_plugin/gt4_session_configuration.dart';
import 'package:provider/provider.dart';
import 'package:yuanmo_link/common/mihoyo_utils.dart';
import 'package:yuanmo_link/model/mihoyo_mmt.dart';
import 'package:yuanmo_link/model/mihoyo_result.dart';
import 'package:yuanmo_link/model/mihoyo_user_info.dart';
import 'package:yuanmo_link/store/global.dart';
import 'package:yuanmo_link/store/global_store.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  // 切换登录方式 0: 手机号登录 1: 账号密码登录
  int _singleSelectedIndex = 0;

  // 手机号登录
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  // 账号密码登录
  final TextEditingController accountController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // 倒计时相关
  int _countdownSeconds = 0; // 剩余秒数
  Timer? _timer; // 倒计时定时器

  @override
  void dispose() {
    // 销毁控制器
    phoneController.dispose();
    codeController.dispose();
    accountController.dispose();
    passwordController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  /// 初始化米哈游相关数据
  Future<void> initMihoyoData(MihoyoUserInfo loginInfo) async {
    BrnLoadingDialog.show(context);
    final miHoYoUtils = MiHoYoUtils();

    // 保存登录信息
    Provider.of<GlobalChangeNotifier>(context, listen: false).saveUserInfo(loginInfo.userInfo);
    Global.saveStoken(loginInfo.token.token);
    Global.saveMid(loginInfo.userInfo.mid);
    Global.saveMiyousheAcount(loginInfo.userInfo.aid);

    // 拼装 Cookie
    String cookie = "login_uid=${Global.miyousheAcount}; "
        "account_id=${Global.miyousheAcount}; "
        "account_mid_v2=${loginInfo.userInfo.mid}; "
        "account_id_v2=${Global.miyousheAcount}; "
        "ltmid_v2=${loginInfo.userInfo.mid}; "
        "ltuid_v2=${Global.miyousheAcount}; "
        "ltuid=${Global.miyousheAcount}; "
        "stuid=${Global.miyousheAcount};"
        "stoken=${Global.stoken};"
        "mid=${loginInfo.userInfo.mid}";

    // stoken 换 ltoken
    final ltoken = await miHoYoUtils.getLTokenBySToken(cookie);

    // 完整 Cookie
    cookie += "; ltoken=$ltoken";
    Global.saveMihoyoCookie(cookie);

    // 获取角色信息
    List<GameRoleInfo> roles = await miHoYoUtils.getGameRolesInfo(cookie);
    Provider.of<GlobalChangeNotifier>(context, listen: false).saveGameRoleList(roles);

    // 结束加载
    setState(() {
      BrnLoadingDialog.dismiss(context);
      BrnToast.show(
        "全部信息已经获取成功",
        context,
        preIcon: Image.asset(
          "assets/images/icon_toast_success.png",
          width: 24,
          height: 24,
        ),
        duration: const Duration(seconds: 2),
      );
    });

    Navigator.of(context).pop();
  }

  /// 手机号登录模块
  Widget _buildPhoneLogin() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
      child: Column(
        children: [
          // 手机号输入
          TextField(
            controller: phoneController,
            decoration: _buildInputDecoration(
              hint: '手机号登录',
              icon: Icons.person,
            ),
          ),
          const SizedBox(height: 16.0),

          // 验证码输入 + 获取验证码按钮
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: codeController,
                  decoration: _buildInputDecoration(
                    hint: '手机验证码',
                    icon: Icons.lock,
                  ),
                ),
              ),
              const SizedBox(width: 16.0),

              // 获取验证码按钮（带倒计时）
              SizedBox(
                height: 48, // 固定按钮高度
                child: ElevatedButton(
                  style: _miyoLinkButtonStyle(),
                  onPressed: _countdownSeconds > 0 ? null : _handleGetPhoneCode,
                  child: Text(
                    _countdownSeconds > 0 ? "${_countdownSeconds}s后可重试" : "获取验证码",
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          // 登录按钮
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: _miyoLinkButtonStyle(),
              onPressed: _handlePhoneLogin,
              child: const Text('登录', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  /// 账号密码登录模块
  Widget _buildAccountLogin() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
      child: Column(
        children: [
          // 账号输入
          TextField(
            controller: accountController,
            decoration: _buildInputDecoration(
              hint: '手机号/邮箱',
              icon: Icons.person,
            ),
          ),
          const SizedBox(height: 16.0),

          // 密码输入
          TextField(
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            controller: passwordController,
            decoration: _buildInputDecoration(
              hint: '密码',
              icon: Icons.lock,
            ),
          ),
          const SizedBox(height: 16.0),

          // 登录按钮
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: _miyoLinkButtonStyle(),
              onPressed: _handleAccountLogin,
              child: const Text('登录', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF666666)),
      filled: true,
      fillColor: const Color(0xFFF8F9FA),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Color(0xFF409EFF), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  ButtonStyle _miyoLinkButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF409EFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      // 按钮文字颜色统一为白色
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontSize: 14),
      // 去除水波纹、阴影等可酌情添加
      elevation: 0,
    );
  }

  // ========== 以下是和业务逻辑绑定的方法 ========== //

  /// 处理「获取验证码」：点击后开始 60s 倒计时
  Future<void> _handleGetPhoneCode() async {
    if (phoneController.text.isEmpty) {
      _showFailToast("请输入手机号");
      return;
    }

    final mihoyoUtils = MiHoYoUtils();
    // 发送验证码
    final mmtResult = await mihoyoUtils.sendPhoneByMiyoushe(phoneController.text, null);

    if (mmtResult == null) {
      // 说明发生了网络错误或请求失败
      _showFailToast("验证码发送失败，请稍后重试");
      return;
    }

    if (!mmtResult.isOk) {
      // 有极验验证
      final model = mmtResult.mmtModel!;
      if (model.data.useV4 != null && model.data.useV4!) {
        // 极验4
        _showGeetest4Captcha(
          gt: model.data.gt,
          sessionId: model.sessionId,
          onSuccess: (String base64String) async {
            final result2 = await mihoyoUtils.sendPhoneByMiyoushe(
              phoneController.text,
              "${model.sessionId};$base64String",
            );
            if (result2?.isOk == true) {
              // 启动倒计时
              _startCountdown();
              _showSuccessToast("验证码发送成功");
            }
          },
        );
      } else {
        // 极验3
        _showGeetest3Captcha(
          gt: model.data.gt,
          challenge: model.data.challenge,
          success: model.data.success == 1,
          sessionId: model.sessionId,
          onSuccess: (String base64String) async {
            final result2 = await mihoyoUtils.sendPhoneByMiyoushe(
              phoneController.text,
              "${model.sessionId};$base64String",
            );
            // 启动倒计时
            _startCountdown();
            if (result2 != null) {
              _showSuccessToast(result2.message);
            }
          },
        );
      }
    } else {
      // 启动倒计时
      _startCountdown();
      // 发送成功
      _showSuccessToast("验证码发送成功");
    }
  }

  /// 手机号登录
  Future<void> _handlePhoneLogin() async {
    if (phoneController.text.isEmpty || codeController.text.isEmpty) {
      _showFailToast("手机号和验证码不能为空");
      return;
    }
    final miHoYoUtils = MiHoYoUtils();
    final loginInfo = await miHoYoUtils.loginByPhone(phoneController.text, codeController.text);
    if (loginInfo != null) {
      await initMihoyoData(loginInfo);
    } else {
      _showFailToast("登录失败, 请检查账号密码是否正确");
    }
  }

  /// 账号密码登录
  Future<void> _handleAccountLogin() async {
    if (accountController.text.isEmpty || passwordController.text.isEmpty) {
      _showFailToast("账号和密码不能为空");
      return;
    }
    BrnLoadingDialog.show(context, content: "登录中请稍等...");
    final miHoYoUtils = MiHoYoUtils();
    final result = await miHoYoUtils.loginByPassword(
      accountController.text,
      passwordController.text,
      null,
    );
    BrnLoadingDialog.dismiss(context);

    if (result == null) {
      // 请求失败
      _showFailToast("登录失败，请稍后重试");
      return;
    }

    if (result.isOk) {
      // 登录成功
      await initMihoyoData(result.userInfo!);
    } else if (result.mmtModel != null) {
      // 需要极验验证
      final model = result.mmtModel!;
      if (model.data.useV4 != null && model.data.useV4!) {
        // 极验4验证
        _showGeetest4Captcha(
          gt: model.data.gt,
          sessionId: model.sessionId,
          onSuccess: (String base64String) async {
            final result2 = await miHoYoUtils.loginByPassword(
              accountController.text,
              passwordController.text,
              "${model.sessionId};$base64String",
            );
            if (result2 != null && result2.userInfo != null) {
              await initMihoyoData(result2.userInfo!);
            } else {
              _showFailToast("登录失败, 请检查账号密码是否正确");
            }
          },
        );
      } else {
        // 极验3验证
        _showGeetest3Captcha(
          gt: model.data.gt,
          challenge: model.data.challenge,
          success: model.data.success == 1,
          sessionId: model.sessionId,
          onSuccess: (String base64String) async {
            final result2 = await miHoYoUtils.loginByPassword(
              accountController.text,
              passwordController.text,
              "${model.sessionId};$base64String",
            );
            if (result2 != null && result2.userInfo != null) {
              await initMihoyoData(result2.userInfo!);
            } else {
              _showFailToast("登录失败, 请检查账号密码是否正确");
            }
          },
        );
      }
    } else {
      // 登录失败
      _showFailToast(result.message);
    }
  }

  // ========== 以下是极验流程统一抽取的方法 ========== //

  /// 显示极验4验证
  void _showGeetest4Captcha({
    required String gt,
    required String sessionId,
    required Function(String base64String) onSuccess,
  }) {
    var config = GT4SessionConfiguration()..language = "zh-CN";
    Gt4FlutterPlugin captcha = Gt4FlutterPlugin(gt, config);

    captcha.verify();
    captcha.addEventHandler(
      onShow: (Map<String, dynamic> message) async {},
      onResult: (Map<String, dynamic> message) async {
        String status = message["status"];
        if (status == "1") {
          // 验证成功
          final result = message["result"];
          final value = CaptchaData(
            captchaId: result["captcha_id"],
            genTime: result["gen_time"],
            captchaOutput: result["captcha_output"],
            passToken: result["pass_token"],
            lotNumber: result["lot_number"],
          );
          final base64String = _encodeCaptchaValue(value.toJson());
          onSuccess.call(base64String);
        }
      },
      onError: (Map<String, dynamic> message) async {
        _showFailToast("校验失败, 重新获取验证码");
      },
    );
  }

  /// 显示极验3验证
  void _showGeetest3Captcha({
    required String gt,
    required String challenge,
    required bool success,
    required String sessionId,
    required Function(String base64String) onSuccess,
  }) {
    Gt3CaptchaConfig config = Gt3CaptchaConfig()..language = 'zh-CN';
    Gt3FlutterPlugin captcha = Gt3FlutterPlugin(config);

    Gt3RegisterData registerData = Gt3RegisterData(
      gt: gt,
      challenge: challenge,
      success: success,
    );

    captcha.startCaptcha(registerData);
    captcha.addEventHandler(
      onResult: (Map<String, dynamic> message) async {
        String code = message["code"];
        if (code == "1") {
          // 验证成功
          final result = message["result"];
          final gt3Result = Gt3Result(
            geetestSeccode: result["geetest_seccode"],
            geetestValidate: result["geetest_validate"],
            geetestChallenge: result["geetest_challenge"],
          );
          final base64String = _encodeCaptchaValue(gt3Result.toJson());
          onSuccess.call(base64String);
        }
      },
      onError: (Map<String, dynamic> message) async {
        _showFailToast("校验失败, 重新获取验证码");
      },
    );
  }

  /// 将极验/验证码验证的数据编码为 Base64
  String _encodeCaptchaValue(Map<String, dynamic> data) {
    var content = utf8.encode(jsonEncode(data));
    var digest = base64Encode(content);
    return digest.toString();
  }

  // ========== 以下是Toast与倒计时的方法 ========== //

  /// 成功提示
  void _showSuccessToast(String msg) {
    BrnToast.show(
      msg,
      context,
      preIcon: Image.asset(
        "assets/images/icon_toast_success.png",
        width: 24,
        height: 24,
      ),
      duration: const Duration(seconds: 2),
    );
  }

  /// 失败提示
  void _showFailToast(String msg) {
    BrnToast.show(
      msg,
      context,
      preIcon: Image.asset(
        "assets/images/icon_toast_fail.png",
        width: 24,
        height: 24,
      ),
      duration: const Duration(seconds: 2),
    );
  }

  /// 开始 60s 倒计时
  void _startCountdown() {
    setState(() {
      _countdownSeconds = 60;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdownSeconds--;
      });
      if (_countdownSeconds <= 0) {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 顶部背景图区域
          Container(
            height: 220,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login_header.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.only(left: 24, bottom: 10),
              alignment: Alignment.bottomLeft,
              child: const Text(
                "登录你的米游社账号",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // 中间区域：切换登录方式 & 登录表单
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 登录方式选择
                    Row(
                      children: [
                        Expanded(
                          child: _buildLoginOptionButton(
                            index: 0,
                            icon: Icons.phone_android,
                            label: "手机号验证登录",
                            isSelected: _singleSelectedIndex == 0,
                            onTap: () => setState(() => _singleSelectedIndex = 0),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildLoginOptionButton(
                            index: 1,
                            icon: Icons.account_circle,
                            label: "账号密码登录",
                            isSelected: _singleSelectedIndex == 1,
                            onTap: () => setState(() => _singleSelectedIndex = 1),
                          ),
                        ),
                      ],
                    ),
                    // 根据索引动态渲染登录表单
                    if (_singleSelectedIndex == 0) _buildPhoneLogin() else _buildAccountLogin(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建顶部切换登录方式按钮 (Element Plus 风格)
  Widget _buildLoginOptionButton({
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF409EFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? const Color(0xFF409EFF) : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              // 选中时图标为白色，未选中时则用灰色
              color: isSelected ? Colors.white : Colors.grey.shade600,
              size: 20,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  // 选中时文字为白色，未选中时则灰色
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  fontSize: 14,
                  // 选中时加粗
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
