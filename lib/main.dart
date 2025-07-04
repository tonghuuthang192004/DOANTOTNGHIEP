import 'package:flutter/material.dart';
import 'package:frontendtn1/views/login/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FastFood App',
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(), // ⛔ Luôn bắt đầu ở màn hình đăng nhập
    );
  }
}
