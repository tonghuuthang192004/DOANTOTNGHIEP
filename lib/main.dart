import 'package:flutter/material.dart';
import 'package:frontendtn1/test_api_page.dart';
import 'package:frontendtn1/views/login/login_screen.dart';
import 'package:frontendtn1/views/home/home_screen.dart'; // ⚠️ Nhớ import HomeScreen
import 'package:frontendtn1/widgets/bottom_navigation_bar.dart';
import 'package:provider/provider.dart';

import 'controllers/provincesController/provincesController.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProvincesController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/login', // ✅ Khai báo màn hình đầu tiên
        routes: {
          '/login': (context) => LoginScreen(),
          '/home': (context) => MainNavigation(), // ✅ Khai báo route trang chủ
        // Optional: nếu bạn dùng trang test
        },
      ),
    );
  }
}
