import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user/user_model.dart';
import '../../services/user/user_service.dart';

class RegisterController {
  static Future<void> handleRegister(
      BuildContext context,
      UserModel user,
      VoidCallback onSuccess,
      ) async {
    try {
      final result = await UserService().register(user);

      if (result['statusCode'] == 201) {
        _showSnackBar(context, result['body']['message'], true);
        onSuccess(); // Chuyển sang màn xác minh
      } else {
        _showSnackBar(context, result['body']['message'], false);
      }
    } catch (e) {
      _showSnackBar(context, 'Đã xảy ra lỗi không mong muốn', false);
    }
  }

  static Future<void> handleEmailVerification(
      BuildContext context,
      String email,
      String code,
      String matKhau,
      VoidCallback onSuccess,
      ) async {
    try {
      final result = await UserService().verifyEmail(email, code);

      if (result['statusCode'] == 200) {
        _showSnackBar(context, result['body']['message'], true);

        // 🟢 Gọi đăng nhập sau xác minh
        final loginResult = await UserService().login(email, matKhau);
        if (loginResult['statusCode'] == 200) {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('token', loginResult['body']['token']);
          prefs.setString('email', email); // lưu thêm nếu cần

          _showSnackBar(context, 'Đăng nhập tự động thành công', true);
          onSuccess();
        } else {
          _showSnackBar(context, 'Xác minh thành công, nhưng đăng nhập thất bại', false);
        }
      } else {
        _showSnackBar(context, result['body']['message'], false);
      }
    } catch (_) {
      _showSnackBar(context, 'Đã xảy ra lỗi khi xác minh', false);
    }
  }

  static void _showSnackBar(
      BuildContext context, String message, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

