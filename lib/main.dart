import 'package:flutter/material.dart';
import 'package:wilks_calculator/ui/splash/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final bgColor = Color(0xFF0f0E47);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: bgColor),
        useMaterial3: true,
      ),
      home: const Splash(),
    );
  }
}
