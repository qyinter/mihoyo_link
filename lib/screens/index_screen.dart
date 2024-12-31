import 'package:flutter/material.dart';
import 'package:bruno/bruno.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:yuanmo_link/common/mihoyo_utils.dart';
import 'package:yuanmo_link/model/mihoyo_fp.dart';
import 'package:yuanmo_link/screens/login_screen.dart';
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
  // qr code
  String status = "";
  // selected
  late int selected = 0;

  final String? appTitle = dotenv.env['APP_TITLE'];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("$appTitle"),
        ),
        body: Consumer<GlobalChangeNotifier>(builder: (context, notifier, child) {
          return Column(children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue[100],
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/app.png",
                    width: 40,
                    height: 40,
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
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (route) => false, // 返回 false 表示清除所有路由历史
                      );
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
                                        // 复制到剪切板
                                        Clipboard.setData(ClipboardData(text: wishUrl));
                                        BrnDialogManager.showSingleButtonDialog(context,
                                            title: "专属抽卡链接获取成功,快去复制使用吧!", label: '复制', onTap: () async {
                                          BrnToast.show(
                                            "已复制到剪切板,快去复制使用吧!",
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
}
