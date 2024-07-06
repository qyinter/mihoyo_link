import 'package:flutter/material.dart';
import 'package:bruno/bruno.dart';
import 'package:yuanmo_link/common/mihoyo_utils.dart';
import 'package:yuanmo_link/components/password.dart';
import 'package:yuanmo_link/components/qr_code.dart';
import 'package:yuanmo_link/store/global.dart';

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
    BadgeTab(text: "账号密码登录"),
  ];

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
        title: const Text('绳网小助手-米游Link'),
      ),
      body: ListView.builder(
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
                                gameRole.nickname ?? "未知昵称",
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text("${gameRole.regionName} - Lv.${gameRole.level}"),
                            ],
                          ),
                          OutlinedButton(
                            onPressed: () {
                              // Handle button press
                              final miHoYoUtils = MiHoYoUtils();
                              miHoYoUtils.getAuthkey(gameRole);
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
      ),
    );
  }

  Widget selectedComponent(int selected) {
    switch (selected) {
      case 0:
        return QRCodeWidget();
      case 1:
        return Password();
      default:
        return Center(child: Text('未知组件', style: TextStyle(fontSize: 24)));
    }
  }
}
