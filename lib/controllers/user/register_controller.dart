import 'package:flutter/material.dart';
import '../../models/user/user_model.dart';
import '../../services/user/user_service.dart';
import '../../services/user/user_session.dart';
import '../../models/user/user_token.dart'; // ✅ Lưu token riêng

class RegisterController {
  /// 📝 Xử lý đăng ký người dùng
  static Future<void> handleRegister(
      BuildContext context,
      UserModel user,
      VoidCallback onSuccess,
      ) async {
    try {
      final result = await UserService().register(user);
      print('📦 [Register] API Response: $result');

      if (result['statusCode'] == 201) {
        _showSnackBar(context, result['body']['message'] ?? 'Đăng ký thành công', true);
        onSuccess();
      } else {
        _showSnackBar(context, result['body']['message'] ?? 'Đăng ký thất bại', false);
      }
    } catch (e) {
      print('❌ [Register Error]: $e');
      _showSnackBar(context, 'Đã xảy ra lỗi khi đăng ký', false);
    }
  }

  /// 📧 Xử lý xác minh email (OTP)
  static Future<void> handleEmailVerification(
      BuildContext context,
      String email,
      String code,
      String matKhau,
      VoidCallback onSuccess,
      ) async {
    try {
      final result = await UserService().verifyEmail(email, code);
      print('📦 [Verify Email] API Response: $result');

      if (result['statusCode'] == 200) {
        _showSnackBar(context, result['body']['message'] ?? 'Xác minh thành công', true);

        // 🪄 Đăng nhập tự động sau khi xác minh thành công
        await _autoLogin(context, email, matKhau, onSuccess);
      } else {
        _showSnackBar(context, result['body']['message'] ?? 'Xác minh thất bại', false);
      }
    } catch (e) {
      print('❌ [Verify Email Error]: $e');
      _showSnackBar(context, 'Đã xảy ra lỗi khi xác minh email', false);
    }
  }

  /// 🔑 Đăng nhập tự động sau khi xác minh
  static Future<void> _autoLogin(
      BuildContext context,
      String email,
      String matKhau,
      VoidCallback onSuccess,
      ) async {
    try {
      final loginResult = await UserService().login(email, matKhau);
      print('📥 [Auto Login] API Response: $loginResult');

      if (loginResult['statusCode'] == 200 && loginResult['body'] != null) {
        final body = loginResult['body'];
        final token = body['token'];
        final user = body['user'];

        print('✅ [Auto Login] Token: $token');
        print('👤 [Auto Login] User: $user');

        if (token is String && token.isNotEmpty && user != null) {
          // 🧹 Xoá session cũ trước khi lưu mới
          await UserSession.clearAll();
          await UserSession.setUser(user);
          await UserToken.saveToken(token); // ✅ Lưu token riêng

          _showSnackBar(context, 'Đăng nhập tự động thành công', true);
          onSuccess();
        } else {
          print('❌ [Auto Login] Token hoặc User null');
          _showSnackBar(context, 'Đăng ký thành công nhưng đăng nhập thất bại (thiếu token/user)', false);
        }
      } else {
        _showSnackBar(context, 'Đăng ký thành công nhưng đăng nhập thất bại', false);
      }
    } catch (e) {
      print('❌ [Auto Login Error]: $e');
      _showSnackBar(context, 'Đã xảy ra lỗi khi đăng nhập tự động', false);
    }
  }

  /// 🍬 Hiển thị SnackBar
  static void _showSnackBar(BuildContext context, String message, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
