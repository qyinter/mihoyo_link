// 启动页应用
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:yuanmo_link/common/mihoyo_utils.dart';
import 'package:yuanmo_link/model/mihoyo_fp.dart';
import 'package:yuanmo_link/store/global.dart';

class SplashApp extends StatelessWidget {
  const SplashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/app.png',
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 30),
              const Text(
                '初始化设备信息中...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

// 初始化函数
Future<void> initializeApp() async {
  final utils = MiHoYoUtils();
  try {
    await utils.getAndroidFp();
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
  }
}
