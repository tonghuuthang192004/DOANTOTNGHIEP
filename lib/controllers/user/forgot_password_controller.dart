import 'package:flutter/material.dart';
import '../../services/user/user_service.dart';

class ForgotPasswordController extends ChangeNotifier {
  final UserService _userService = UserService();

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  // 📨 Gửi email quên mật khẩu
  Future<void> sendForgotPasswordEmail(String email) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final response = await _userService.forgotPassword(email);

    isLoading = false;
    if (response['statusCode'] == 200) {
      successMessage = response['body']['message'];
    } else {
      errorMessage = response['body']['error'] ?? 'Gửi email thất bại';
    }
    notifyListeners();
  }

  void clearMessages() {
    errorMessage = null;
    successMessage = null;
    notifyListeners();
  }
}
