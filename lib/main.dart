import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ZebPlayApp());
}

class ZebPlayApp extends StatelessWidget {
  const ZebPlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xff050518),
      ),

      home: const HomeScreen(),
    );
  }
}
