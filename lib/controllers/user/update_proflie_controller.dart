import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../api/api_constants.dart';
import '../../models/user/user_token.dart';
import '../../models/user/user_model.dart';
import '../../services/user/user_session.dart';

class UpdateProfileController {
  /// ✅ Lấy thông tin người dùng hiện tại
  Future<UserModel?> getCurrentUserProfile() async {
    final token = await UserToken.getToken();
    if (token == null) {
      print('⚠️ [getProfile] Token null, cần đăng nhập lại');
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse(API.getProfile),
        headers: {'Authorization': 'Bearer $token'},
      );

      print('📦 [getProfile] Status: ${response.statusCode}');
      final data = jsonDecode(response.body);
      print('📦 [getProfile] Response: $data');

      if (response.statusCode == 200 && (data['success'] == true || data['status'] == true)) {
        final userJson = data['data'] ?? data['user'];
        if (userJson != null) {
          print('✅ [getProfile] User found');
          return UserModel.fromJson(userJson);
        }
      } else {
        print('❌ [getProfile] Lỗi response: ${data['message']}');
      }
    } catch (e) {
      print('❌ [getProfile] Exception: $e');
    }
    return null;
  }

  /// ✏️ Cập nhật tên và số điện thoại
  Future<Map<String, dynamic>> updateProfileInfo({
    required String ten,
    required String soDienThoai,
  }) async {
    final token = await UserToken.getToken();
    if (token == null) {
      print('⚠️ [updateProfileInfo] Token null');
      return {'success': false, 'message': 'Không tìm thấy token'};
    }

    try {
      final response = await http.post(
        Uri.parse(API.updateProfile),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'ten': ten,
          'so_dien_thoai': soDienThoai,
        }),
      );

      print('📦 [updateProfileInfo] Status: ${response.statusCode}');
      final data = jsonDecode(response.body);
      print('📦 [updateProfileInfo] Response: $data');

      if (response.statusCode == 200 && data['success'] == true) {
        print("✅ [updateProfileInfo] Update thành công: ${data['user']}");
        await UserSession.setUser(data['user']); // Lưu vào local
        return {'success': true, 'message': data['message']};
      }
      return {'success': false, 'message': data['message'] ?? 'Cập nhật thất bại'};
    } catch (e) {
      print('❌ [updateProfileInfo] Exception: $e');
      return {'success': false, 'message': 'Lỗi cập nhật thông tin'};
    }
  }

  /// 🖼 Upload avatar mới
  Future<Map<String, dynamic>> uploadAvatar(File avatarFile) async {
    final token = await UserToken.getToken();
    if (token == null) {
      print('⚠️ [uploadAvatar] Token null');
      return {'success': false, 'message': 'Không tìm thấy token'};
    }

    try {
      final request = http.MultipartRequest('POST', Uri.parse(API.updateAvatar))
        ..headers['Authorization'] = 'Bearer $token'
        ..files.add(await http.MultipartFile.fromPath('avatar', avatarFile.path));

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();
      final data = jsonDecode(responseBody);

      print('📦 [uploadAvatar] Status: ${streamedResponse.statusCode}');
      print('📦 [uploadAvatar] Response: $data');

      if (streamedResponse.statusCode == 200 && data['success'] == true) {
        print("✅ [uploadAvatar] Upload thành công: ${data['avatar_url']}");

        // Cập nhật avatar mới vào local user
        final currentUser = await UserSession.getUser();
        if (currentUser != null) {
          currentUser['avatar'] = data['avatar_url'];
          await UserSession.setUser(currentUser);
        }

        return {'success': true, 'message': data['message']};
      }

      return {'success': false, 'message': data['message'] ?? 'Upload avatar thất bại'};
    } catch (e) {
      print('❌ [uploadAvatar] Exception: $e');
      return {'success': false, 'message': 'Lỗi upload avatar'};
    }
  }
}
