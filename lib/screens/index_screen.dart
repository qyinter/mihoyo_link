import 'package:flutter/material.dart';
import 'package:bruno/bruno.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:yuanmo_link/common/mihoyo_utils.dart';
import 'package:yuanmo_link/components/password.dart';
import 'package:yuanmo_link/components/qr_code.dart';
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
    BadgeTab(text: "扫码登录"),
    BadgeTab(text: "手机号登录"),
  ];

  final String? appTitle = dotenv.env['APP_TITLE'];

  @override
  void initState() {
    super.initState();
    // 在构建完成后调用 Bottom Picker
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showLoginPicker();
    });
    _tabController = TabController(length: _tabs.length, vsync: this);
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
                                    String? APP_NAME = dotenv.env['APP_NAME'];
                                    BrnDialogManager.showConfirmDialog(context,
                                        title: "专属抽卡链接获取成功《$wishUrl》,快去$APP_NAME使用吧!",
                                        cancel: '取消',
                                        confirm: '复制密钥', onConfirm: () {
                                      Clipboard.setData(ClipboardData(text: wishUrl));
                                      Navigator.pop(context);
                                    }, onCancel: () {
                                      Navigator.pop(context);
                                    });
                                  },
                                  child: const Text('获取抽卡链接'),
                                ),
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
        return QRCodeWidget();
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
