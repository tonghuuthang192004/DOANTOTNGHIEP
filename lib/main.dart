import 'package:flutter/material.dart';
import 'package:frontendtn1/pages/Cart/Cart.dart';
import 'package:frontendtn1/pages/home/HomeCreen.dart';
import 'package:frontendtn1/pages/login/login.dart';
import 'package:frontendtn1/pages/register/register.dart';
import 'package:frontendtn1/widgets/Sidebar_Menu.dart';



void main()
{
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:SignUpScreen()
    );
  }
}
