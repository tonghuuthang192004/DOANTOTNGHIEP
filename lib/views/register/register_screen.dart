import 'package:flutter/material.dart';
import '../../utils/dimensions.dart';
import 'register_header.dart';
import 'register_form.dart';
import 'social_login.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width25),
            child: Container(
              padding: EdgeInsets.all(Dimensions.width30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Dimensions.radius25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  RegisterHeader(),
                  SizedBox(height: 30),
                  RegisterForm(),
                  SizedBox(height: 25),
                  // SocialLogin()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
