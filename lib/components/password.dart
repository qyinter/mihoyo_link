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

class Password extends StatefulWidget {
  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              BrnRadioButton(
                radioIndex: 0,
                isSelected: _singleSelectedIndex == 0,
                child: const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    "手机号验证登录",
                  ),
                ),
                onValueChangedAtIndex: (index, value) {
                  setState(() {
                    _singleSelectedIndex = index;
                  });
                },
              ),
              const SizedBox(
                width: 20,
              ),
              BrnRadioButton(
                radioIndex: 1,
                isSelected: _singleSelectedIndex == 1,
                child: const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    "账号密码登录",
                  ),
                ),
                onValueChangedAtIndex: (index, value) {
                  setState(() {
                    _singleSelectedIndex = index;
                  });
                },
              ),
            ],
          ),
        ),
        selectedComponent(_singleSelectedIndex)
      ],
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
    String cookie =
        "login_uid=${Global.miyousheAcount}; account_id=${Global.miyousheAcount}; account_mid_v2=${loginInfo.userInfo.mid}; account_id_v2=${Global.miyousheAcount}; ltmid_v2=${loginInfo.userInfo.mid}; ltuid_v2=${Global.miyousheAcount}; ltuid=${Global.miyousheAcount}; stuid=${Global.miyousheAcount};stoken=${Global.stoken};mid=${loginInfo.userInfo.mid}";
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
                                  var content = utf8.encode(value.toJson().toString());
                                  var digest = base64Encode(content);
                                  final base64String = digest.toString();
                                  final result2 = await mihoyoUril.sendPhoneByMiyoushe(
                                      phoneController.text, "${model.sessionId},$base64String");

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
                                var content = utf8.encode(gt3Result.toJson().toString());
                                var digest = base64Encode(content);
                                final base64String = digest.toString();

                                final result2 = await mihoyoUril.sendPhoneByMiyoushe(
                                    phoneController.text, "${model.sessionId},$base64String");

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
                    final miHoYoUtils = MiHoYoUtils();
                    final result =
                        await miHoYoUtils.loginByPassword(accountController.text, passwordController.text, null);

                    if (result != null && result.isOk) {
                      await initMihoyoData(result.userInfo!);
                    } else if (result!.mmtModel != null) {
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
                                var content = utf8.encode(value.toJson().toString());
                                var digest = base64Encode(content);
                                final base64String = digest.toString();
                                final result2 = await miHoYoUtils.loginByPassword(accountController.text,
                                    passwordController.text, "${model.sessionId},$base64String");

                                if (result2 != null && result2.userInfo != null) {
                                  await initMihoyoData(result2.userInfo as MihoyoUserInfo);
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
                              var content = utf8.encode(gt3Result.toJson().toString());
                              var digest = base64Encode(content);
                              final base64String = digest.toString();
                              final result2 = await miHoYoUtils.loginByPassword(
                                  accountController.text, passwordController.text, "${model.sessionId},$base64String");
                              if (result2 != null && result2.userInfo != null) {
                                await initMihoyoData(result2.userInfo as MihoyoUserInfo);
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
                            }
                          },
                        );
                      }
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
