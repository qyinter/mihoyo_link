import 'package:flutter/material.dart';
import 'package:bruno/bruno.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:yuanmo_link/common/mihoyo_utils.dart';
import 'package:yuanmo_link/components/password.dart';
import 'package:yuanmo_link/components/qr_code.dart';
import 'package:yuanmo_link/model/qrcode.dart';

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
  String url = "";
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
        title: Text('登录 Picker 页面'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '当前选择的登录项: $url',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showLoginPicker,
              child: Text('重新选择登录项'),
            ),
          ],
        ),
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
