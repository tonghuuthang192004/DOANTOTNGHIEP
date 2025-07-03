import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../api/api_constants.dart';
import '../../models/address/address_model.dart';
import '../../models/user/user_token.dart';

class AddressService {
  /// 📥 Lấy danh sách địa chỉ theo userId
  static Future<List<AddressModel>> fetchAddresses(int userId) async {
    final token = await UserToken.getToken();

    final response = await http.get(
      Uri.parse(API.getAddresses(userId)),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = json.decode(response.body);
      if (decoded['success'] == true && decoded['data'] != null) {
        final List<dynamic> data = decoded['data'];
        return data.map((e) => AddressModel.fromJson(e)).toList();
      } else {
        throw Exception('Dữ liệu trả về không hợp lệ');
      }
    } else {
      throw Exception('Lỗi lấy danh sách địa chỉ (${response.statusCode})');
    }
  }

  /// ➕ Thêm địa chỉ mới
  static Future<void> createAddress(AddressModel model) async {
    final token = await UserToken.getToken();

    final response = await http.post(
      Uri.parse(API.addAddress),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(model.toJson()),
    );

    if (response.statusCode != 201) {
      final decoded = json.decode(response.body);
      throw Exception(decoded['message'] ?? 'Thêm địa chỉ thất bại');
    }
  }

  /// ✏️ Cập nhật địa chỉ
  static Future<void> updateAddress(AddressModel model) async {
    final token = await UserToken.getToken();

    final response = await http.put(
      Uri.parse(API.updateAddress(model.id)),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(model.toJson()),
    );

    if (response.statusCode != 200) {
      final decoded = json.decode(response.body);
      throw Exception(decoded['message'] ?? 'Cập nhật địa chỉ thất bại');
    }
  }

  /// 🗑️ Xoá địa chỉ
  static Future<void> deleteAddress(int id) async {
    final token = await UserToken.getToken();

    final response = await http.delete(
      Uri.parse(API.deleteAddress(id)),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      final decoded = json.decode(response.body);
      throw Exception(decoded['message'] ?? 'Xoá địa chỉ thất bại');
    }
  }

  /// 🌟 Đặt địa chỉ mặc định
  static Future<void> setDefaultAddress(int id, int userId) async {
    final token = await UserToken.getToken();

    final response = await http.patch(
      Uri.parse(API.setDefaultAddress(id)),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'id_nguoi_dung': userId}),
    );

    if (response.statusCode != 200) {
      final decoded = json.decode(response.body);
      throw Exception(decoded['message'] ?? 'Lỗi đặt địa chỉ mặc định');
    }
  }
}
