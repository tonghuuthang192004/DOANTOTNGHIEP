import 'package:flutter/material.dart';
import 'package:frontendtn1/pages/%20favourite/favourite.dart';
import 'package:frontendtn1/pages/Cart/Cart.dart';
import 'package:frontendtn1/pages/Promotion/Promotion_screen.dart';
import 'package:frontendtn1/pages/home/HomeScreen.dart';
import 'package:frontendtn1/pages/home/food_card.dart';
import 'package:frontendtn1/pages/login/login.dart';
import 'package:frontendtn1/pages/pay/payment.dart';
import 'package:frontendtn1/pages/product/food_detail.dart';
import 'package:frontendtn1/pages/product/list_food.dart';
import 'package:frontendtn1/pages/profile/order_detail.dart';
import 'package:frontendtn1/pages/register/register.dart';
import 'package:frontendtn1/pages/welcome/Welcome_Screen.dart';
import 'package:frontendtn1/utils/dimensions.dart';
import 'package:frontendtn1/widgets/Sidebar_Menu.dart';
import 'package:frontendtn1/widgets/bottom_navigation_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, home: WelcomeScreen());
  }
}




