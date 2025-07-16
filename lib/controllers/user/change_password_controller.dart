import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../api/api_constants.dart';
import '../../models/user/user_token.dart';


class ChangePasswordController {
  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final url = Uri.parse(API.changePassword);
    final token = await UserToken.getToken();

    if (token == null) {
      print('⚠️ [ChangePassword] Token không tồn tại');
      return {
        'success': false,
        'message': 'Bạn chưa đăng nhập. Vui lòng đăng nhập lại.'
      };
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        }),
      );

      final data = jsonDecode(response.body);
      print('📦 [ChangePassword] Response: $data');

      return {
        'success': response.statusCode == 200,
        'message': data['message'] ?? data['error'] ?? 'Thay đổi mật khẩu thành công',
      };
    } catch (e) {
      print('❌ [ChangePassword] Exception: $e');
      return {
        'success': false,
        'message': 'Không thể kết nối tới máy chủ. Thử lại sau.'
      };
    }
  }
}

