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
  late String data;
  bool isLoading = true;
  int _singleSelectedIndex = 0;
  // 0: 手机号验证登录
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  // 1: 账号密码登录
  final TextEditingController accountController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // 销毁控制器以释放资源
    phoneController.dispose();
    codeController.dispose();
    accountController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // 顶部背景图区域
            Container(
              height: 220,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/login_header.jpg'), // 确保添加这个图片资源
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.only(left: 24, bottom: 10),
                alignment: Alignment.bottomLeft,
                child: const Text(
                  "登录你的米游社账号", // 或其他标题文字
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // 登录区域
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

                      const SizedBox(height: 20),

                      // 登录表单
                      selectedComponent(_singleSelectedIndex),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  } // 登录选项按钮构建方法

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

// 自定义输入框样式
  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF666666)),
      filled: true,
      fillColor: const Color(0xFFF8F9FA),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2196F3), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Future<void> initMihoyoData(MihoyoUserInfo loginInfo) async {
    BrnLoadingDialog.show(context);

    loginInfo.userInfo.toJson();
    final miHoYoUtils = MiHoYoUtils();
    Provider.of<GlobalChangeNotifier>(context, listen: false).saveUserInfo(loginInfo.userInfo);
    Global.saveStoken(loginInfo.token.token);
    Global.saveMid(loginInfo.userInfo.mid);
    Global.saveMiyousheAcount(loginInfo.userInfo.aid);
    // 获取cookie
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
    // 添加ltoken
    cookie += ";ltoken=$ltoken";
    Global.saveMihoyoCookie(cookie);
    // 获取角色信息
    List<GameRoleInfo> list = await miHoYoUtils.getGameRolesInfo(cookie);
    Provider.of<GlobalChangeNotifier>(context, listen: false).saveGameRoleList(list);
    // 获取角色信息成功
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
    BrnLoadingDialog.dismiss(context);
    Navigator.of(context).pop();
  }

  // 动态切换form
  Widget selectedComponent(int selected) {
    switch (selected) {
      case 0:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  hintText: '手机号登录',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: codeController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: '手机验证码',
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      // 发送验证码
                      final mihoyoUril = MiHoYoUtils();
                      // 获取手机验证码
                      final mmtResult = await mihoyoUril.sendPhoneByMiyoushe(phoneController.text, null);
                      if (!mmtResult!.isOk) {
                        // 判断是不是极速4验证
                        final model = mmtResult.mmtModel!;
                        if (model.data.useV4 != null && model.data.useV4!) {
                          // 极验4验证
                          var config = GT4SessionConfiguration();
                          config.language = "zh-CN";
                          Gt4FlutterPlugin captcha = Gt4FlutterPlugin(model.data.gt, config);
                          captcha.verify();
                          captcha.addEventHandler(
                              onShow: (Map<String, dynamic> message) async {},
                              onResult: (Map<String, dynamic> message) async {
                                String status = message["status"];
                                if (status == "1") {
                                  final result = message["result"];
                                  final value = CaptchaData(
                                      captchaId: result["captcha_id"],
                                      genTime: result["gen_time"],
                                      captchaOutput: result["captcha_output"],
                                      passToken: result["pass_token"],
                                      lotNumber: result["lot_number"]);
                                  var content = utf8.encode(jsonEncode(value.toJson()));
                                  var digest = base64Encode(content);
                                  final base64String = digest.toString();
                                  final result2 = await mihoyoUril.sendPhoneByMiyoushe(
                                      phoneController.text, "${model.sessionId};$base64String");

                                  if (result2!.isOk) {
                                    BrnToast.show(
                                      "验证码发送成功",
                                      context,
                                      preIcon: Image.asset(
                                        "assets/images/icon_toast_success.png",
                                        width: 24,
                                        height: 24,
                                      ),
                                      duration: const Duration(seconds: 2),
                                    );
                                  }
                                }
                              },
                              onError: (Map<String, dynamic> message) async {
                                BrnToast.show(
                                  "校验失败, 重新获取验证码",
                                  context,
                                  preIcon: Image.asset(
                                    "assets/images/icon_toast_success.png",
                                    width: 24,
                                    height: 24,
                                  ),
                                  duration: const Duration(seconds: 2),
                                );
                              });
                        } else {
                          Gt3CaptchaConfig config = Gt3CaptchaConfig();
                          config.language = 'zh-CN'; // 设置语言为英文 Set English as the CAPTCHA language
                          Gt3FlutterPlugin captcha = Gt3FlutterPlugin(config);
                          Gt3RegisterData registerData = Gt3RegisterData(
                              gt: model.data.gt, // 验证ID，从极验后台创建 Verify ID, created from the geetest dashboard
                              challenge: model.data.challenge, // 从极验服务动态获取 Gain challenges from geetest
                              success: model.data.success == 1); // 对极验服务的心跳检测 Check if it is success
                          captcha.startCaptcha(registerData);

                          captcha.addEventHandler(
                            onResult: (Map<String, dynamic> message) async {
                              String code = message["code"];
                              if (code == "1") {
                                final result = message["result"];
                                final gt3Result = Gt3Result(
                                  geetestSeccode: result["geetest_seccode"],
                                  geetestValidate: result["geetest_validate"],
                                  geetestChallenge: result["geetest_challenge"],
                                );
                                var content = utf8.encode(jsonEncode(gt3Result.toJson()));
                                var digest = base64Encode(content);
                                final base64String = digest.toString();

                                final result2 = await mihoyoUril.sendPhoneByMiyoushe(
                                    phoneController.text, "${model.sessionId};$base64String");

                                if (result2 != null) {
                                  BrnToast.show(
                                    result2.message,
                                    context,
                                    preIcon: Image.asset(
                                      "assets/images/icon_toast_success.png",
                                      width: 24,
                                      height: 24,
                                    ),
                                    duration: const Duration(seconds: 2),
                                  );
                                }
                              }
                            },
                          );
                        }
                      } else {
                        BrnToast.show(
                          "验证码发送成功",
                          context,
                          preIcon: Image.asset(
                            "assets/images/icon_toast_success.png",
                            width: 24,
                            height: 24,
                          ),
                          duration: const Duration(seconds: 2),
                        );
                      }
                    },
                    child: const Text(
                      '获取验证码',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity, // 占满宽度
                child: ElevatedButton(
                  onPressed: () async {
                    if (phoneController.text.isEmpty || codeController.text.isEmpty) {
                      BrnToast.show(
                        "手机号和验证码不能为空",
                        context,
                        preIcon: Image.asset(
                          "assets/images/icon_toast_success.png",
                          width: 24,
                          height: 24,
                        ),
                        duration: const Duration(seconds: 2),
                      );
                      return;
                    }
                    final miHoYoUtils = MiHoYoUtils();
                    final loginInfo = await miHoYoUtils.loginByPhone(phoneController.text, codeController.text);
                    if (loginInfo != null) {
                      await initMihoyoData(loginInfo);
                    } else {
                      BrnToast.show(
                        "登录失败, 请检查账号密码是否正确",
                        context,
                        preIcon: Image.asset(
                          "assets/images/icon_toast_success.png",
                          width: 24,
                          height: 24,
                        ),
                        duration: const Duration(seconds: 2),
                      );
                    }
                  },
                  child: const Text(
                    '登录',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      case 1:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: accountController,
                decoration: const InputDecoration(
                  hintText: '手机号/邮箱',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  hintText: '密码',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity, // 占满宽度
                child: ElevatedButton(
                  onPressed: () async {
                    if (accountController.text.isEmpty || passwordController.text.isEmpty) {
                      BrnToast.show(
                        "账号和密码不能为空",
                        context,
                        preIcon: Image.asset(
                          "assets/images/icon_toast_success.png",
                          width: 24,
                          height: 24,
                        ),
                        duration: const Duration(seconds: 2),
                      );
                      return;
                    }
                    BrnLoadingDialog.show(context, content: "登录中请稍等...");
                    final miHoYoUtils = MiHoYoUtils();
                    final result =
                        await miHoYoUtils.loginByPassword(accountController.text, passwordController.text, null);
                    if (result != null && result.isOk) {
                      await initMihoyoData(result.userInfo!);
                      BrnLoadingDialog.dismiss(context);
                    } else if (result!.mmtModel != null) {
                      BrnLoadingDialog.dismiss(context);
                      // 判断是不是极速4验证
                      final model = result.mmtModel;
                      if (model!.data.useV4 != null && model.data.useV4!) {
                        // 极验4验证
                        var config = GT4SessionConfiguration();
                        config.language = "zh-CN";
                        Gt4FlutterPlugin captcha = Gt4FlutterPlugin(model.data.gt, config);
                        captcha.verify();
                        captcha.addEventHandler(
                            onShow: (Map<String, dynamic> message) async {},
                            onResult: (Map<String, dynamic> message) async {
                              String status = message["status"];
                              if (status == "1") {
                                final result = message["result"];
                                final value = CaptchaData(
                                    captchaId: result["captcha_id"],
                                    genTime: result["gen_time"],
                                    captchaOutput: result["captcha_output"],
                                    passToken: result["pass_token"],
                                    lotNumber: result["lot_number"]);
                                var content = utf8.encode(jsonEncode(value.toJson()));
                                var digest = base64Encode(content);
                                final base64String = digest.toString();
                                final result2 = await miHoYoUtils.loginByPassword(accountController.text,
                                    passwordController.text, "${model.sessionId};$base64String");

                                if (result2 != null && result2.userInfo != null) {
                                  await initMihoyoData(result2.userInfo as MihoyoUserInfo);
                                } else {
                                  BrnToast.show(
                                    "登录失败, 请检查账号密码是否正确",
                                    context,
                                    preIcon: Image.asset(
                                      "assets/images/icon_toast_fail.png",
                                      width: 24,
                                      height: 24,
                                    ),
                                    duration: const Duration(seconds: 2),
                                  );
                                }
                              }
                            },
                            onError: (Map<String, dynamic> message) async {
                              BrnToast.show(
                                "校验失败, 重新获取验证码",
                                context,
                                preIcon: Image.asset(
                                  "assets/images/icon_toast_success.png",
                                  width: 24,
                                  height: 24,
                                ),
                                duration: const Duration(seconds: 2),
                              );
                            });
                      } else {
                        Gt3CaptchaConfig config = Gt3CaptchaConfig();
                        config.language = 'zh-CN'; // 设置语言为英文 Set English as the CAPTCHA language
                        Gt3FlutterPlugin captcha = Gt3FlutterPlugin(config);
                        Gt3RegisterData registerData = Gt3RegisterData(
                            gt: model.data.gt, // 验证ID，从极验后台创建 Verify ID, created from the geetest dashboard
                            challenge: model.data.challenge, // 从极验服务动态获取 Gain challenges from geetest
                            success: model.data.success == 1); // 对极验服务的心跳检测 Check if it is success
                        captcha.startCaptcha(registerData);

                        captcha.addEventHandler(
                          onResult: (Map<String, dynamic> message) async {
                            String code = message["code"];
                            if (code == "1") {
                              final result = message["result"];
                              final gt3Result = Gt3Result(
                                geetestSeccode: result["geetest_seccode"],
                                geetestValidate: result["geetest_validate"],
                                geetestChallenge: result["geetest_challenge"],
                              );
                              ;
                              var content = utf8.encode(jsonEncode(gt3Result.toJson()));
                              var digest = base64Encode(content);
                              final base64String = digest.toString();
                              final result2 = await miHoYoUtils.loginByPassword(
                                  accountController.text, passwordController.text, "${model.sessionId};$base64String");
                              if (result2 != null && result2.userInfo != null) {
                                await initMihoyoData(result2.userInfo as MihoyoUserInfo);
                              } else {
                                BrnToast.show(
                                  "登录失败, 请检查账号密码是否正确",
                                  context,
                                  preIcon: Image.asset(
                                    "assets/images/icon_toast_fail.png",
                                    width: 24,
                                    height: 24,
                                  ),
                                  duration: const Duration(seconds: 2),
                                );
                              }
                            }
                          },
                        );
                      }
                    } else {
                      BrnLoadingDialog.dismiss(context);
                      BrnToast.show(
                        result.message,
                        context,
                        preIcon: Image.asset(
                          "assets/images/icon_toast_fail.png",
                          width: 24,
                          height: 24,
                        ),
                        duration: const Duration(seconds: 2),
                      );
                    }
                  },
                  child: const Text(
                    '登录',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      default:
        return Container();
    }
  }
}
