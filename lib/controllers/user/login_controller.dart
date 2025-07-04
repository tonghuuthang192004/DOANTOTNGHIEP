import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/api_constants.dart';
import '../../models/user/user_token.dart';

class LoginController {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse(API.login);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'mat_khau': password}),
      );

      print('🧾 Response from API: ${response.body}');

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 && decoded['token'] != null) {
        final prefs = await SharedPreferences.getInstance();

        // 🧹 Xóa dữ liệu cũ
        await prefs.remove('user');
        await UserToken.clearToken();

        // ✅ Lưu token
        await UserToken.saveToken(decoded['token']);

        final user = decoded['user'];
        if (user != null) {
          await prefs.setString('user', jsonEncode(user));

          // ✅ Lưu userId an toàn từ key 'id_nguoi_dung'
          final dynamic rawId = user['id_nguoi_dung'];
          if (rawId != null) {
            final int? userId = rawId is int ? rawId : int.tryParse(rawId.toString());
            if (userId != null) {
              await UserToken.saveUserId(userId);
            } else {
              print("⚠️ ID không hợp lệ: $rawId");
            }
          } else {
            print("❌ Không tìm thấy 'id_nguoi_dung' trong user");
          }

          print("✅ [Login] Lưu user thành công: $user");
        }

        print("📦 Token mới: ${decoded['token']}");

        return {
          'success': true,
          'user': user,
          'token': decoded['token'],
        };
      }

      return {
        'success': false,
        'message': decoded['message'] ?? 'Đăng nhập thất bại',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi kết nối: $e',
      };
    }
  }
}
