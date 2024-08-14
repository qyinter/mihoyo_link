import 'package:flutter/material.dart';
import 'package:bruno/bruno.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:yuanmo_link/common/api_utils.dart';
import 'package:yuanmo_link/common/mihoyo_utils.dart';
import 'package:yuanmo_link/components/password.dart';
import 'package:yuanmo_link/model/mihoyo_fp.dart';
import 'package:yuanmo_link/model/mihoyo_zzz_%20avatar_info.dart';
import 'package:yuanmo_link/store/global.dart';
import 'package:yuanmo_link/store/global_store.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _IndexScreenState();
  }
}

class _IndexScreenState extends State<IndexScreen> with SingleTickerProviderStateMixin {
  // TabController
  late TabController _tabController;
  // qr code
  String status = "";
  // selected
  late int selected = 0;
  // login picker tab
  final List<BadgeTab> _tabs = [
    // BadgeTab(text: "扫码登录"),
    BadgeTab(text: "手机号登录"),
  ];

  final String? appTitle = dotenv.env['APP_TITLE'];

  @override
  void initState() {
    super.initState();
    // 在构建完成后调用 Bottom Picker
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Global.userInfo == null) _showLoginPicker();
      // 监听更新情况
      String? apiUrl = dotenv.env['API_URL'];
      if (apiUrl != null) {
        FlutterXUpdate.checkUpdate(url: "$apiUrl/api/app_version");
      }
      _initializeData();
      // print(Global.mihoyoCookie);
    });
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  Future<void> _initializeData() async {
    BrnLoadingDialog.show(context, content: "初始化设备信息中...");
    final utils = MiHoYoUtils();
    try {
      await utils.getAndroidFp();
      BrnLoadingDialog.dismiss(context);
    } catch (e) {
      Global.saveFpInfo(
        FpInfo(
          deviceFp: utils.generateCustomId(),
          bbsDeviceId: const Uuid().v4(),
          sysVsersion: "12",
          deviceName: "%E5%B0%8F%E7%B1%B3%E6%89%8B%E6%9C%BA",
          deviceModel: "MI 14",
          brand: "Xiaomi",
        ),
      );
      BrnLoadingDialog.dismiss(context);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showLoginPicker() {
    BrnBottomPicker.show(context, barrierDismissible: false, showTitle: false,
        contentWidget: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Padding(
        padding: const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BrnTabBar(
              controller: _tabController,
              tabs: _tabs,
              onTap: (state, index) {
                setState(() {
                  selected = index;
                });
              },
            ),
            selectedComponent(selected),
          ],
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("$appTitle-米游Link"),
        ),
        body: Consumer<GlobalChangeNotifier>(builder: (context, notifier, child) {
          return Column(children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue[100],
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: getIcon(),
                    radius: 25,
                  ),
                  const SizedBox(width: 8),
                  Global.userInfo != null
                      ? Text(
                          "欢迎回来, ${Global.userInfo!.aid}",
                          style: const TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w700),
                        )
                      : const Text("未登录"),
                  Spacer(),
                  // button
                  ElevatedButton(
                    onPressed: () async {
                      Provider.of<GlobalChangeNotifier>(context, listen: false).saveUserInfo(null);
                      Provider.of<GlobalChangeNotifier>(context, listen: false).saveGameRoleList([]);
                      Global.clearAll();
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _showLoginPicker();
                      });
                    },
                    child: const Text('重新登录'),
                  )
                ],
              ),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: Global.gameRoleList.length,
              itemBuilder: (context, index) {
                final role = Global.gameRoleList[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(role.gameIcon ?? "assets/images/hk4e_cn.png") as ImageProvider,
                            radius: 25,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            role.gameName,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      //循环 role.list
                      for (var gameRole in role.list)
                        Card(
                          margin: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      gameRole.nickname,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    Text("${gameRole.regionName} - Lv.${gameRole.level}"),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    OutlinedButton(
                                      onPressed: () async {
                                        // Handle button press
                                        final miHoYoUtils = MiHoYoUtils();
                                        BrnLoadingDialog.show(context);
                                        final wishUrl = await miHoYoUtils.getAuthkey(gameRole, role);

                                        if (wishUrl == null) {
                                          BrnToast.show(
                                            "获取抽卡链接失败,如果多次获取失败请重新登录",
                                            context,
                                            preIcon: Image.asset(
                                              "assets/images/icon_toast_fail.png",
                                              width: 24,
                                              height: 24,
                                            ),
                                            duration: const Duration(seconds: 2),
                                          );
                                          return;
                                        }

                                        BrnLoadingDialog.dismiss(context);

                                        String? APP_NAME = "";
                                        String? APP_ID = "";
                                        String? JAPP_PATH = "";
                                        if (role.gameName == "原神") {
                                          APP_ID = dotenv.env['YUANSHEN_APP_ID'];
                                          JAPP_PATH = dotenv.env['YUANSHEN_APP_PATH'];
                                          APP_NAME = dotenv.env['APP_NAME2'];
                                        } else {
                                          APP_ID = dotenv.env['JUEQU_APP_ID'];
                                          JAPP_PATH = dotenv.env['JUEQU_APP_PATH'];
                                          APP_NAME = dotenv.env['APP_NAME'];
                                        }

                                        if (APP_ID == null || APP_ID == "") {
                                          // 复制到剪切板
                                          Clipboard.setData(ClipboardData(text: wishUrl));
                                          BrnDialogManager.showSingleButtonDialog(context,
                                              title: "专属抽卡链接获取成功《$wishUrl》,快去$APP_NAME使用吧!",
                                              label: '复制', onTap: () async {
                                            BrnToast.show(
                                              "已复制到剪切板,快去$APP_NAME使用吧!",
                                              context,
                                              preIcon: Image.asset(
                                                "assets/images/icon_toast_success.png",
                                                width: 24,
                                                height: 24,
                                              ),
                                              duration: const Duration(seconds: 2),
                                            );
                                            Navigator.pop(context);
                                          });
                                          return;
                                        }
                                        final String wechatUrl =
                                            'weixin://dl/business/?appid=$APP_ID&path=$JAPP_PATH&query=key=$wishUrl&env_version=release';
                                        var uri = Uri.parse(wechatUrl);
                                        // 尝试打开微信小程序深层链接
                                        if (await canLaunchUrl(uri)) {
                                          launchUrl(uri, mode: LaunchMode.externalApplication);
                                        }
                                        // 复制到剪切板
                                        Clipboard.setData(ClipboardData(text: wishUrl));
                                        BrnDialogManager.showSingleButtonDialog(context,
                                            title: "专属抽卡链接获取成功《$wishUrl》,快去$APP_NAME使用吧!",
                                            label: '复制', onTap: () async {
                                          BrnToast.show(
                                            "已复制到剪切板,快去$APP_NAME使用吧!",
                                            context,
                                            preIcon: Image.asset(
                                              "assets/images/icon_toast_success.png",
                                              width: 24,
                                              height: 24,
                                            ),
                                            duration: const Duration(seconds: 2),
                                          );
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: const Text('获取抽卡链接'),
                                    ),
                                    role.gameName == "绝区零"
                                        ? OutlinedButton(
                                            onPressed: () async {
                                              // Handle button press
                                              final miHoYoUtils = MiHoYoUtils();
                                              BrnLoadingDialog.show(context, content: "获取展柜数据中...请稍等...");

                                              final apiUtil = ApiUtils();
                                              final characterInfo = await miHoYoUtils.getCharacterInfo(gameRole, role);
                                              if (characterInfo != null) {
                                                List<Character> newBody = [];
                                                for (var character in characterInfo.avatar_list) {
                                                  final detial = await miHoYoUtils.getCharacterInfoById(
                                                      gameRole, role, character.id);
                                                  if (detial != null) {
                                                    newBody.add(detial);
                                                  }
                                                  await Future.delayed(Duration(milliseconds: 200));
                                                }
                                                final setFlag = await apiUtil.setAvatarInfoData(newBody);
                                                if (setFlag != null && setFlag) {
                                                  BrnLoadingDialog.dismiss(context);
                                                  BrnToast.show(
                                                    "更新成功,去《绳网小助手》查看角色展柜吧!",
                                                    context,
                                                    preIcon: Image.asset(
                                                      "assets/images/icon_toast_success.png",
                                                      width: 24,
                                                      height: 24,
                                                    ),
                                                    duration: const Duration(seconds: 2),
                                                  );
                                                } else {
                                                  BrnToast.show(
                                                    "获取出错了,如果一直出错请重新登录!",
                                                    context,
                                                    preIcon: Image.asset(
                                                      "assets/images/icon_toast_success.png",
                                                      width: 24,
                                                      height: 24,
                                                    ),
                                                    duration: const Duration(seconds: 2),
                                                  );
                                                }
                                              } else {
                                                BrnToast.show(
                                                  "获取出错了,如果一直出错请重新登录!",
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
                                            child: const Text('提交展柜数据'),
                                          )
                                        : Container(),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ))
          ]);
        }));
  }

  Widget selectedComponent(int selected) {
    switch (selected) {
      case 0:
        return Password();
      // return QRCodeWidget();
      case 1:
        return Password();
      default:
        return Container();
    }
  }

  AssetImage getIcon() {
    final APP_ICON = dotenv.env['APP_ICON'];
    if (APP_ICON == null) {
      return AssetImage("assets/images/logo.png");
    }
    return AssetImage("assets/images$APP_ICON");
  }
}
