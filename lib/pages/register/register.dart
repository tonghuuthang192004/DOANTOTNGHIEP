import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/inputText.dart';
import '../login/login.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tạo tài khoản",
          style: TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.to(LoginScreen()),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                'Chào mừng bạn đến với ứng dụng!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 25),

              InputTextWidget(
                labelText: "Họ",
                icon: Icons.person,
                obscureText: false,
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 12),

              InputTextWidget(
                labelText: "Tên",
                icon: Icons.person_outline,
                obscureText: false,
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 12),

              InputTextWidget(
                controller: _emailController,
                labelText: "Địa chỉ Email",
                icon: Icons.email,
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 12),

              InputTextWidget(
                labelText: "Số điện thoại",
                icon: Icons.phone,
                obscureText: false,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 12),

              buildPasswordField(
                label: "Mật khẩu",
                controller: _pass,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  } else if (val.length < 6) {
                    return 'Mật khẩu phải có ít nhất 6 ký tự';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),

              buildPasswordField(
                label: "Xác nhận mật khẩu",
                controller: _confirmPass,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Vui lòng xác nhận mật khẩu';
                  } else if (val != _pass.text) {
                    return 'Mật khẩu không khớp';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Xử lý đăng ký tại đây
                      print("Đăng ký thành công!");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffF05945),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 6,
                  ),
                  child: Text(
                    "Tiếp tục",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Ô nhập mật khẩu tùy chỉnh
  Widget buildPasswordField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
  }) {
    return Material(
      elevation: 6.0,
      shadowColor: Colors.black12,
      borderRadius: BorderRadius.circular(12.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: TextFormField(
          obscureText: true,
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            icon: Icon(Icons.lock, color: Colors.black54),
            labelText: label,
            labelStyle: TextStyle(color: Colors.black54),
            border: InputBorder.none,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black38),
            ),
          ),
        ),
      ),
    );
  }
}
