import '../../api/api_constants.dart';
import '../../models/user/user_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/user/user_token.dart';
class UserService {
  Future<Map<String, dynamic>> register(UserModel user) async {
    final url = Uri.parse('${API.baseUrl}/users/dang-ky');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      final decoded = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'body': decoded,
      };
    } catch (e) {
      return {
        'statusCode': 500,
        'body': {'message': 'Lỗi kết nối đến máy chủ', 'error': e.toString()}
      };
    }
  }

  Future<Map<String, dynamic>> verifyEmail(String email, String code) async {
    final url = Uri.parse('${API.baseUrl}/users/xac-minh-email');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'code': code}),
      );

      return {
        'statusCode': response.statusCode,
        'body': jsonDecode(response.body),
      };
    } catch (e) {
      return {
        'statusCode': 500,
        'body': {'message': 'Lỗi xác minh email', 'error': e.toString()}
      };
    }
  }

  Future<Map<String, dynamic>> login(String email, String matKhau) async {
    final url = Uri.parse('${API.baseUrl}/users/dang-nhap');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'mat_khau': matKhau}),
      );

      final decoded = jsonDecode(response.body);

      // ✅ Nếu đăng nhập thành công và có token
      if (response.statusCode == 200 && decoded['token'] != null) {
        await UserToken.saveToken(decoded['token']); // ✅ Lưu token vào local storage
      }

      return {
        'statusCode': response.statusCode,
        'body': decoded,
      };
    } catch (e) {
      return {
        'statusCode': 500,
        'body': {'message': 'Lỗi đăng nhập', 'error': e.toString()}
      };
    }
  }
}
