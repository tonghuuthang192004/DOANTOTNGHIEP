import 'package:flutter/material.dart';
import '../../services/user/user_service.dart';

class ResetPasswordController extends ChangeNotifier {
  final UserService _userService = UserService();

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  // 🔑 Đặt lại mật khẩu
  Future<void> resetPassword(String token, String newPassword) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final response = await _userService.resetPassword(
      token: token,
      newPassword: newPassword,
    );

    isLoading = false;
    if (response['statusCode'] == 200) {
      successMessage = response['body']['message'];
    } else {
      errorMessage = response['body']['error'] ?? 'Đặt lại mật khẩu thất bại';
    }
    notifyListeners();
  }

  void clearMessages() {
    errorMessage = null;
    successMessage = null;
    notifyListeners();
  }
}
