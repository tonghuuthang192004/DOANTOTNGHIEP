import 'package:flutter/material.dart';
import '../../services/user/user_service.dart';

class ResetPasswordController extends ChangeNotifier {
  final UserService _userService = UserService();

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  /// 🔑 Đặt lại mật khẩu
  Future<void> resetPassword(String token, String newPassword) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    try {
      final response = await _userService.resetPassword(
        token: token,
        newPassword: newPassword,
      );

      isLoading = false;

      if (response['statusCode'] == 200 && response['body'] != null) {
        successMessage = response['body']['message'] ?? 'Đặt lại mật khẩu thành công';
        print("✅ [ResetPassword] Success: $successMessage");
      } else {
        errorMessage = response['body']?['error'] ??
            response['body']?['message'] ??
            'Đặt lại mật khẩu thất bại';
        print("❌ [ResetPassword] Error: $errorMessage");
      }
    } catch (e) {
      isLoading = false;
      errorMessage = 'Đã xảy ra lỗi: $e';
      print("❌ [ResetPassword] Exception: $e");
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
