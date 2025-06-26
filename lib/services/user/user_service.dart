import 'package:shared_preferences/shared_preferences.dart';
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
    // 🧹 BƯỚC 1: Xoá token và user cũ TRƯỚC khi gọi API login
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await UserToken.clearToken();  // <-- Xoá token cũ

    // 🔐 BƯỚC 2: Gọi API đăng nhập
    final url = Uri.parse('${API.baseUrl}/users/dang-nhap');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'mat_khau': matKhau}),
    );

    final decoded = jsonDecode(response.body);
    print("📦 [Login] Response Body: $decoded");

    // 💾 BƯỚC 3: Lưu token và user mới
    if (response.statusCode == 200 && decoded['token'] != null) {
      await UserToken.saveToken(decoded['token']);
      final user = decoded['user'];
      if (user != null) {
        await prefs.setString('user', jsonEncode(user));
      }
    }

    return {
      'statusCode': response.statusCode,
      'body': decoded,
    };
  }


  Future<Map<String, dynamic>> updateProfile({
    required String ten,
    required String soDienThoai,
    required String gioiTinh,
    String? avatar,
  }) async {
    final url = Uri.parse(API.updateProfile);
    final token = await UserToken.getToken();

    print("📤 [Update Profile] Token đang gửi: $token");

    try {
      final body = {
        'ten': ten,
        'so_dien_thoai': soDienThoai,
        'gioi_tinh': gioiTinh,
      };

      if (avatar != null) {
        body['avatar'] = avatar;
      }

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      return {
        'statusCode': response.statusCode,
        'body': jsonDecode(response.body),
      };
    } catch (e) {
      return {
        'statusCode': 500,
        'body': {'message': 'Lỗi cập nhật thông tin', 'error': e.toString()}
      };
    }
  }

  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final url = Uri.parse(API.changePassword);
    final token = await UserToken.getToken();

    print("📤 [Change Password] Token đang gửi: $token");

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
        'statusCode': response.statusCode,
        'body': data,
      };
    } catch (e) {
      return {
        'statusCode': 500,
        'body': {'success': false, 'message': 'Lỗi kết nối: $e'},
      };
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    final url = Uri.parse('${API.baseUrl}/users/profile');
    final token = await UserToken.getToken();

    print("🚀 Token đang dùng: $token");

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final decoded = jsonDecode(response.body);
      return {
        'statusCode': response.statusCode,
        'body': decoded,
      };
    } catch (e) {
      return {
        'statusCode': 500,
        'body': {
          'message': 'Lỗi lấy thông tin người dùng',
          'error': e.toString()
        }
      };
    }
  }

  Future<void> logout() async {
    await UserToken.clearToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    print("🧹 [Logout] Đã xoá user khỏi SharedPreferences");
  }
}
