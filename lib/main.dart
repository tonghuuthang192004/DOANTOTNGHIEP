import 'package:flutter/material.dart';


import 'views/product/product_detail_screen.dart';
import 'views/welcome/Welcome_Screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WelcomeScreen()
    );
  }
}




