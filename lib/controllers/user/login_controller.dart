import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../api/api_constants.dart';
import '../../models/user/user_token.dart'; // 👈 dùng class quản lý token

class LoginController {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('${API.baseUrl}/users/dang-nhap');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'mat_khau': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // ✅ Lưu token đúng cách
        await UserToken.saveToken(data['token']);

        return {
          'success': true,
          'token': data['token'],
          'user': data['user'],
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Đăng nhập thất bại',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi kết nối máy chủ: $e',
      };
    }
  }
}
