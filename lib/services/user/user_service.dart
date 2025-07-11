import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../api/api_constants.dart';
import '../../models/user/user_model.dart';
import '../../models/user/user_token.dart';

class UserService {
  /// 📝 Đăng ký tài khoản mới
  Future<Map<String, dynamic>> register(UserModel user) async {
    try {
      final response = await http.post(
        Uri.parse(API.register),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );
      final decoded = jsonDecode(response.body);
      print('📦 [Register] Response: $decoded');
      return {'statusCode': response.statusCode, 'body': decoded};
    } catch (e) {
      print('❌ [Register] Error: $e');
      return {'statusCode': 500, 'body': {'message': 'Lỗi kết nối', 'error': e.toString()}};
    }
  }

  /// ✅ Xác minh email
  Future<Map<String, dynamic>> verifyEmail(String email, String code) async {
    try {
      final response = await http.post(
        Uri.parse(API.verifyEmail),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'ma_xac_minh': code}),
      );
      final decoded = jsonDecode(response.body);
      print('📦 [Verify Email] Response: $decoded');
      return {'statusCode': response.statusCode, 'body': decoded};
    } catch (e) {
      print('❌ [Verify Email] Error: $e');
      return {'statusCode': 500, 'body': {'message': 'Lỗi xác minh email', 'error': e.toString()}};
    }
  }

  /// 🔐 Đăng nhập
  Future<Map<String, dynamic>> login(String email, String password) async {
    await UserToken.clearToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');

    try {
      final response = await http.post(
        Uri.parse(API.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'mat_khau': password}),
      );

      // Kiểm tra mã trạng thái HTTP
      if (response.statusCode != 200) {
        print('❌ [Login] Error: ${response.statusCode}');
        return {
          'statusCode': response.statusCode,
          'body': {'message': 'Lỗi kết nối', 'error': 'Mã trạng thái không hợp lệ'}
        };
      }

      // Giải mã dữ liệu nếu mã trạng thái là 200
      final decoded = jsonDecode(response.body);
      print('📦 [Login] Response: $decoded');

      // Kiểm tra xem token có tồn tại trong decoded hay không
      if (decoded['token'] != null && decoded['user'] != null) {
        await UserToken.saveToken(decoded['token']);
        await UserToken.saveUserId(decoded['user']['id_nguoi_dung']); // Lưu userId
        await prefs.setString('user', jsonEncode(decoded['user']));
        print('✅ Token & userId đã lưu');
      } else {
        print('❌ [Login] Token hoặc thông tin người dùng không hợp lệ');
        return {
          'statusCode': 400,
          'body': {'message': 'Thông tin đăng nhập không hợp lệ'}
        };
      }

      return {'statusCode': response.statusCode, 'body': decoded};
    } catch (e) {
      print('❌ [Login] Error: $e');
      return {
        'statusCode': 500,
        'body': {'message': 'Lỗi kết nối', 'error': e.toString()}
      };
    }
  }

  /// 🖼 Upload avatar
  Future<Map<String, dynamic>> uploadAvatar(File avatarFile) async {
    final token = await UserToken.getToken();
    if (token == null) {
      print('⚠️ [Upload Avatar] Token null');
      return {'success': false, 'message': 'Bạn chưa đăng nhập'};
    }

    try {
      final request = http.MultipartRequest('POST', Uri.parse(API.updateAvatar))
        ..headers['Authorization'] = 'Bearer $token'
        ..files.add(await http.MultipartFile.fromPath(
          'avatar',
          avatarFile.path,
          contentType: MediaType('image', 'jpeg'), // 👈 Ép định dạng về jpeg
        ));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);

      print('📦 [Upload Avatar] Response: $data');

      if (response.statusCode == 200 && data['success'] == true) {
        return {'success': true, 'message': data['message'], 'avatar_url': data['avatar_url']};
      }
      return {'success': false, 'message': data['message'] ?? 'Upload avatar thất bại'};
    } catch (e) {
      print('❌ [Upload Avatar] Error: $e');
      return {'success': false, 'message': 'Lỗi upload avatar: $e'};
    }
  }

  /// ✏️ Cập nhật tên và số điện thoại
  Future<Map<String, dynamic>> updateProfileInfo({
    required String ten,
    required String soDienThoai,
  }) async {
    final token = await UserToken.getToken();
    if (token == null) {
      print('⚠️ [Update Profile] Token null');
      return {'success': false, 'message': 'Bạn chưa đăng nhập'};
    }

    try {
      final response = await http.put(
        Uri.parse(API.updateProfile),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'ten': ten, 'so_dien_thoai': soDienThoai}),
      );
      final decoded = jsonDecode(response.body);
      print('📦 [Update Profile] Response: $decoded');
      return {
        'success': decoded['success'] == true,
        'message': decoded['message'] ?? 'Cập nhật xong'
      };
    } catch (e) {
      print('❌ [Update Profile] Error: $e');
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  /// 🔑 Đổi mật khẩu
  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final token = await UserToken.getToken();
    if (token == null) {
      print('⚠️ [Change Password] Token null');
      return {'success': false, 'message': 'Bạn chưa đăng nhập'};
    }

    try {
      final response = await http.put(
        Uri.parse(API.changePassword),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'oldPassword': oldPassword, 'newPassword': newPassword}),
      );
      final decoded = jsonDecode(response.body);
      print('📦 [Change Password] Response: $decoded');
      return {
        'success': decoded['success'] == true,
        'message': decoded['message'] ?? 'Đổi mật khẩu thành công'
      };
    } catch (e) {
      print('❌ [Change Password] Error: $e');
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  /// 👤 Lấy profile người dùng
  Future<Map<String, dynamic>> getProfile() async {
    final token = await UserToken.getToken();
    if (token == null) {
      print('⚠️ [Get Profile] Token null');
      return {'success': false, 'message': 'Bạn chưa đăng nhập'};
    }

    try {
      final response = await http.get(
        Uri.parse(API.getProfile),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final decoded = jsonDecode(response.body);
      print('📦 [Get Profile] Response: $decoded');
      return {'statusCode': response.statusCode, 'body': decoded};
    } catch (e) {
      print('❌ [Get Profile] Error: $e');
      return {'statusCode': 500, 'body': {'message': 'Lỗi lấy profile', 'error': e.toString()}};
    }
  }

  /// 📧 Quên mật khẩu
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse(API.forgotPassword),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      final decoded = jsonDecode(response.body);
      print('📦 [Forgot Password] Response: $decoded');
      return {'statusCode': response.statusCode, 'body': decoded};
    } catch (e) {
      print('❌ [Forgot Password] Error: $e');
      return {'statusCode': 500, 'body': {'message': 'Lỗi quên mật khẩu', 'error': e.toString()}};
    }
  }

  /// 🔄 Đặt lại mật khẩu
  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(API.resetPassword),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token, 'newPassword': newPassword}),
      );
      final decoded = jsonDecode(response.body);
      print('📦 [Reset Password] Response: $decoded');
      return {'statusCode': response.statusCode, 'body': decoded};
    } catch (e) {
      print('❌ [Reset Password] Error: $e');
      return {'statusCode': 500, 'body': {'message': 'Lỗi đặt lại mật khẩu', 'error': e.toString()}};
    }
  }

  /// 🚪 Đăng xuất
  Future<void> logout() async {
    await UserToken.clearToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    print('🧹 [Logout] Xoá session thành công');
  }
}
