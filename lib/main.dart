import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:provider/provider.dart';
import 'package:yuanmo_link/routes/route_generator.dart';
import 'package:yuanmo_link/screens/splash_screen.dart';
import 'package:yuanmo_link/store/global.dart';
import 'package:yuanmo_link/store/global_exception.dart';
import 'package:yuanmo_link/store/global_store.dart';

void main() {
  runZonedGuarded(() async {
    await dotenv.load(fileName: getEnvFileName());
    await Global.init();
    // 监听更新情况
    String? apiUrl = dotenv.env['API_URL'];
    if (apiUrl != null) {
      FlutterXUpdate.checkUpdate(url: "$apiUrl/api/app_version");
    }
    runApp(const SplashApp());
    await initializeApp();
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
    default:
      return '.env.dev';
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF90CAF9),
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF90CAF9)),
      ),
      initialRoute: Global.userInfo == null ? '/login' : '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
