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

    try {
      final response = await http.put(
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

      return {
        'success': response.statusCode == 200,
        'message': data['message'] ?? data['error'] ?? 'Không rõ kết quả',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi kết nối: $e',
      };
    }
  }
}
