import 'package:flutter/material.dart';
import '../../utils/dimensions.dart';
import 'login_header.dart';
import 'login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const LoginHeader(),
            SizedBox(height: Dimensions.height20),
            const LoginForm(),
          ],
        ),
      ),
    );
  }
}