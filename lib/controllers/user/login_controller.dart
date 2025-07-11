import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../api/api_constants.dart';
import '../../services/user/user_session.dart';
import '../../models/user/user_token.dart'; // ✅ import để lưu token riêng

class LoginController {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse(API.login);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'mat_khau': password,
        }),
      );

      print('🧾 [LoginController] Response: ${response.body}');
      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 && decoded['token'] != null) {
        final String token = decoded['token'];
        final Map<String, dynamic> user = decoded['user'];

        print("📦 Token mới: $token");
        print("👤 User: $user");

        // 🆔 Kiểm tra ID người dùng trong response
        final userId = user['id_nguoi_dung'] ?? user['id'];
        if (userId == null) {
          print("❌ [LoginController] Không tìm thấy ID người dùng trong user");
          return {
            'success': false,
            'message': 'User trả về từ server thiếu ID',
          };
        }

        // 🧹 Clear session cũ trước khi lưu mới
        await UserSession.clearAll();
        await UserSession.setUser(user);
        await UserToken.saveToken(token); // ✅ Lưu token riêng

        print("✅ [LoginController] Lưu user và token thành công");

        return {
          'success': true,
          'user': user,
          'token': token,
        };
      }

      print("⚠️ [LoginController] Đăng nhập thất bại: ${decoded['message']}");
      return {
        'success': false,
        'message': decoded['message'] ?? 'Đăng nhập thất bại',
      };
    } catch (e) {
      print("❌ [LoginController] Lỗi: $e");
      return {
        'success': false,
        'message': 'Lỗi kết nối: $e',
      };
    }
  }
}