import 'package:animated_login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Animated Login',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
