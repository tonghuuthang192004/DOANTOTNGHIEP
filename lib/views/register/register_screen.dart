import 'package:flutter/material.dart';
import '../../utils/dimensions.dart';
import 'register_header.dart';
import 'register_form.dart'; // ✅ THÊM DÒNG NÀY

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
                children: [
                  const RegisterHeader(),
                  SizedBox(height: Dimensions.height30),
                  const RegisterForm(), // ✅ Để const nếu RegisterForm là Stateless
                  SizedBox(height: Dimensions.height25),
                  // TextButton(
                  //   onPressed: () {
                  //     Navigator.pop(context);
                  //   },
                  //   child: const Text(
                  //     'Bạn đã có tài khoản? Đăng nhập',
                  //     style: TextStyle(color: Colors.blue),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
