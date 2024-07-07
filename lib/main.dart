import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuanmo_link/routes/route_generator.dart';
import 'package:yuanmo_link/store/global.dart';
import 'package:yuanmo_link/store/global_exception.dart';
import 'package:yuanmo_link/store/global_store.dart';

void main() {
  runZonedGuarded(() async {
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
