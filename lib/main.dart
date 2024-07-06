import 'package:flutter/material.dart';
import 'package:yuanmo_link/routes/route_generator.dart';
import 'package:bruno/bruno.dart';

void main() {
  runApp(const MyApp());
  BrnInitializer.register();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
