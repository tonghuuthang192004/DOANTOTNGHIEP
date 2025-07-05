import 'package:flutter/material.dart';
import '../../services/user/user_service.dart';

class ForgotPasswordController extends ChangeNotifier {
  final UserService _userService = UserService();

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  /// 📨 Gửi email quên mật khẩu
  Future<void> sendForgotPasswordEmail(String email) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    try {
      final response = await _userService.forgotPassword(email);

      isLoading = false;

      final body = response['body'];
      if (response['statusCode'] == 200 && body != null) {
        successMessage = body['message'] ?? 'Đã gửi email thành công';
        print("✅ [ForgotPassword] Success: $successMessage");
      } else {
        errorMessage = body?['error'] ??
            body?['message'] ??
            'Gửi email thất bại';
        print("❌ [ForgotPassword] Error: $errorMessage");
      }
    } catch (e) {
      isLoading = false;
      errorMessage = 'Đã xảy ra lỗi: $e';
      print("❌ [ForgotPassword] Exception: $e");
    }

    notifyListeners();
  }

  /// 🧹 Reset thông báo
  void clearMessages() {
    errorMessage = null;
    successMessage = null;
    notifyListeners();
  }
}
