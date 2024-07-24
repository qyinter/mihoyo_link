import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:yuanmo_link/common/mihoyo_utils.dart';
import 'package:yuanmo_link/model/mihoyo_fp.dart';
import 'package:yuanmo_link/routes/route_generator.dart';
import 'package:yuanmo_link/store/global.dart';
import 'package:yuanmo_link/store/global_exception.dart';
import 'package:yuanmo_link/store/global_store.dart';

void main() {
  runZonedGuarded(() async {
    await dotenv.load(fileName: getEnvFileName());
    final utils = MiHoYoUtils();
    try {
      utils.getAndroidFp();
    } catch (e) {
      Global.saveFpInfo(
        FpInfo(
            deviceFp: utils.generateCustomId(),
            bbsDeviceId: const Uuid().v4(),
            sysVsersion: "12",
            deviceName: "%E5%B0%8F%E7%B1%B3%E6%89%8B%E6%9C%BA",
            deviceModel: "MI 14",
            brand: "Xiaomi"),
      );
    }

    await Global.init();
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => GlobalChangeNotifier()),
          ChangeNotifierProvider(create: (context) => GlobalExceptionNotifier()),
        ],
        child: const MyApp(),
      ),
    );
  }, (Object error, StackTrace stack) {
    print('捕获到未处理的 Dart 异常：$error');
  });
}

String getEnvFileName() {
  const String env = String.fromEnvironment('ENV', defaultValue: 'dev');
  switch (env) {
    case 'prod':
      return '.env.prod';
    case 'zl':
      return '.env.zl';
    case 'zs':
      return '.env.zs';
    case 'dev':
    default:
      return '.env.dev';
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
