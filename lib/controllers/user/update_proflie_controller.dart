import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../api/api_constants.dart';
import '../../models/user/user_token.dart';
import '../../models/user/user_model.dart';

class UpdateProfileController {
  // ✅ Lấy thông tin người dùng hiện tại
  Future<UserModel?> getCurrentUserProfile() async {
    final url = Uri.parse(API.getProfile);
    final token = await UserToken.getToken();

    print('🚀 Token đang dùng: $token');

    if (token == null) {
      print('⚠️ Token null, cần đăng nhập lại');
      return null;
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);
      print('📦 [getProfile] Response: $data');

      if (response.statusCode == 200 && data['data'] != null) {
        return UserModel.fromJson(data['data']);
      } else if (response.statusCode == 200 && data['user'] != null) {
        return UserModel.fromJson(data['user']);
      } else {
        print('❌ Không tìm thấy data trong response');
      }
    } catch (e) {
      print('❌ Lỗi lấy thông tin người dùng: $e');
    }

    return null;
  }


  // ✅ Cập nhật thông tin và trả về cả trước & sau
  Future<Map<String, dynamic>> updateProfile({
    required String ten,
    required String soDienThoai,
    required String gioiTinh,
    String? ngaySinh, // 👈 thêm ngày sinh
    String? avatar,
  }) async {
    final token = await UserToken.getToken();
    final updateUrl = Uri.parse(API.updateProfile);
    final profileUrl = Uri.parse(API.getProfile);

    try {
      // 🔹 B1: Lấy dữ liệu người dùng hiện tại
      final currentUser = await getCurrentUserProfile();

      // 🔹 B2: Gửi yêu cầu cập nhật thông tin
      final updateBody = {
        'ten': ten,
        'so_dien_thoai': soDienThoai,
        'gioi_tinh': gioiTinh,
        if (ngaySinh != null) 'ngay_sinh': ngaySinh, // 👈 thêm vào body
        if (avatar != null) 'avatar': avatar,
      };

      final updateRes = await http.put(
        updateUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updateBody),
      );

      final updateData = jsonDecode(updateRes.body);

      if (updateRes.statusCode != 200) {
        return {
          'success': false,
          'message': updateData['message'] ?? 'Cập nhật thất bại',
        };
      }

      // 🔹 B3: Lấy lại thông tin người dùng sau cập nhật
      final afterRes = await http.get(
        profileUrl,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final afterData = jsonDecode(afterRes.body);

      UserModel? updatedUser;
      if (afterRes.statusCode == 200 && afterData['data'] != null) {
        updatedUser = UserModel.fromJson(afterData['data']);
      }

      return {
        'success': true,
        'message': updateData['message'] ?? 'Cập nhật thành công',
        'before': currentUser,
        'after': updatedUser,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi kết nối: $e',
      };
    }
  }
}




