import 'package:flutter/material.dart';
import 'package:bruno/bruno.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yuanmo_link/common/mihoyo_utils.dart';
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

class _IndexScreenState extends State<IndexScreen> {
  @override
  Widget build(BuildContext context) {
    const elementPlusPrimaryColor = Color(0xFF409EFF);
    return Scaffold(
      // 使用 Stack 叠放背景与内容
      body: SafeArea(
        child: Stack(
          children: [
            // 1. 背景图片
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.jpg'), // 替换为你的背景图片
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // 3. 主体内容
            Consumer<GlobalChangeNotifier>(
              builder: (context, notifier, child) {
                return Column(
                  children: [
                    // 顶部信息栏
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      decoration: BoxDecoration(
                        // 背景设为透明
                        color: Colors.transparent,
                        // 添加白色边框
                        border: Border.all(
                          color: Colors.white,
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/app.png",
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Global.userInfo != null
                                ? Text(
                                    "欢迎回来, ${Global.userInfo!.aid}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : const Text(
                                    "未登录",
                                    style: TextStyle(fontSize: 16),
                                  ),
                          ),
                          // ───────────── 这里移除「重新登录」按钮 ─────────────
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // 角色信息列表
                    Expanded(
                      child: Global.gameRoleList.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // 显示图片
                                  Image.asset(
                                    'assets/images/miyouku.png',
                                    width: 150,
                                    height: 150,
                                  ),
                                  const SizedBox(height: 16),
                                  // 显示文字
                                  const Text(
                                    '没有找到你的游戏账号哦.\n去米游社绑定游戏账号后再来吧.',
                                    textAlign: TextAlign.center, // 文本多行居中
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: Global.gameRoleList.length,
                              itemBuilder: (context, index) {
                                final role = Global.gameRoleList[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                  child: Card(
                                    color: Colors.transparent,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: const BorderSide(color: Colors.white, width: 1.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: AssetImage(
                                                  role.gameIcon ?? "assets/images/hk4e_cn.png",
                                                ),
                                                radius: 24,
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                role.gameName,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          for (var gameRole in role.list)
                                            Container(
                                              margin: const EdgeInsets.only(top: 12),
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                border: Border.all(color: const Color(0xFFFFFFFF)),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        gameRole.nickname,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text("${gameRole.regionName} · Lv.${gameRole.level}"),
                                                    ],
                                                  ),
                                                  OutlinedButton(
                                                    style: OutlinedButton.styleFrom(
                                                      foregroundColor: elementPlusPrimaryColor,
                                                      side: const BorderSide(color: elementPlusPrimaryColor),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(4),
                                                      ),
                                                      textStyle: const TextStyle(fontSize: 14),
                                                    ),
                                                    onPressed: () async {
                                                      final miHoYoUtils = MiHoYoUtils();
                                                      BrnLoadingDialog.show(context);

                                                      final wishUrl = await miHoYoUtils.getAuthkey(gameRole, role);
                                                      BrnLoadingDialog.dismiss(context);

                                                      if (wishUrl == null) {
                                                        BrnToast.show(
                                                          "获取抽卡链接失败, 如果多次获取失败请重新登录",
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

                                                      // 复制到剪切板
                                                      Clipboard.setData(ClipboardData(text: wishUrl));
                                                      BrnDialogManager.showSingleButtonDialog(
                                                        context,
                                                        title: "专属抽卡链接获取成功，已复制到剪切板！",
                                                        label: '确定',
                                                        onTap: () {
                                                          Navigator.pop(context);
                                                        },
                                                      );
                                                    },
                                                    child: const Text('获取抽卡链接'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),

                    // ───────────── 新增底部 Row ，放「重新登录」和「获取Cookie」两个按钮 ─────────────
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 重新登录
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              minimumSize: Size(0, 0), // 取消默认最小尺寸
                              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                              foregroundColor: elementPlusPrimaryColor,
                              side: const BorderSide(color: elementPlusPrimaryColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              textStyle: const TextStyle(fontSize: 12),
                            ),
                            onPressed: () async {
                              Provider.of<GlobalChangeNotifier>(context, listen: false).saveUserInfo(null);
                              Provider.of<GlobalChangeNotifier>(context, listen: false).saveGameRoleList([]);
                              Global.clearAll();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                                (route) => false,
                              );
                            },
                            child: const Text('重新登录'),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              minimumSize: Size(0, 0), // 取消默认最小尺寸
                              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                              foregroundColor: elementPlusPrimaryColor,
                              side: const BorderSide(color: elementPlusPrimaryColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              textStyle: const TextStyle(fontSize: 12),
                            ),
                            onPressed: () {
                              // 显示一个带取消、确定按钮的对话框
                              BrnDialogManager.showConfirmDialog(
                                context,
                                title: "警告",
                                message: "如果你不知道Cookie是什么?\n为了保证你的账号安全\n请不要将其泄露给任何人。",
                                cancel: "取消",
                                confirm: "复制Cookie",
                                onConfirm: () {
                                  Clipboard.setData(ClipboardData(text: Global.mihoyoCookie));
                                  Navigator.pop(context);
                                  BrnDialogManager.showSingleButtonDialog(
                                    context,
                                    title: "Cookie复制成功",
                                    label: '确定',
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                                onCancel: () {
                                  Navigator.pop(context);
                                },
                              );
                            },
                            child: const Text('获取Cookie'),
                          ),
                        ],
                      ),
                    ),
                    // ─────────────────────────────────────────────────────────────────
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
