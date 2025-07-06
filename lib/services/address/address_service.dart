import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../api/api_constants.dart';
import '../../models/address/address_model.dart';
import '../user/user_session.dart';

class AddressService {
  static Future<List<AddressModel>> fetchAddresses() async {
    final token = await UserSession.getToken();
    if (token == null) throw Exception('❌ Không tìm thấy token');

    final url = Uri.parse(API.getAddresses);
    print('📡 [GET] $url');

    final res = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    print('📥 Response (${res.statusCode}): ${res.body}');

    if (res.statusCode == 200) {
      final List<dynamic> data = json.decode(res.body)['data'];
      return data.map((e) => AddressModel.fromJson(e)).toList();
    } else {
      throw Exception('❌ Lỗi tải địa chỉ: ${res.statusCode}');
    }
  }

  static Future<void> createAddress(AddressModel address) async {
    final token = await UserSession.getToken();
    if (token == null) throw Exception('❌ Không tìm thấy token');

    final url = Uri.parse(API.addAddress);
    print('📡 [POST] $url');

    final res = await http.post(url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(address.toJson()));

    print('📥 Response (${res.statusCode}): ${res.body}');

    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception('❌ Lỗi thêm địa chỉ: ${res.body}');
    }
  }

  static Future<void> updateAddress(AddressModel address) async {
    final token = await UserSession.getToken();
    if (token == null) throw Exception('❌ Không tìm thấy token');

    final url = Uri.parse(API.updateAddress(address.id));
    print('📡 [PUT] $url');

    final res = await http.put(url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(address.toJson()));

    print('📥 Response (${res.statusCode}): ${res.body}');

    if (res.statusCode != 200) {
      throw Exception('❌ Lỗi cập nhật địa chỉ: ${res.body}');
    }
  }

  static Future<void> deleteAddress(int id) async {
    final token = await UserSession.getToken();
    if (token == null) throw Exception('❌ Không tìm thấy token');

    final url = Uri.parse(API.deleteAddress(id));
    print('📡 [DELETE] $url');

    final res = await http.delete(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    print('📥 Response (${res.statusCode}): ${res.body}');

    if (res.statusCode != 200) {
      debugPrint('Xóa địa chỉ thất bại: ${res.body}');
      throw Exception('Không thể xóa địa chỉ. Server trả về lỗi.');
    }

  }

  static Future<void> setDefaultAddress(int id) async {
    final token = await UserSession.getToken();
    if (token == null) throw Exception('❌ Không tìm thấy token');

    final url = Uri.parse(API.setDefaultAddress(id));
    print('📡 [PATCH] $url');

    final res = await http.patch(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    print('📥 Response (${res.statusCode}): ${res.body}');

    if (res.statusCode != 200) {
      throw Exception('❌ Lỗi đặt mặc định: ${res.body}');
    }
  }
}
