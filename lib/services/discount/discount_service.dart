import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../api/api_constants.dart';
import '../../models/discount/discount_model.dart';


class DiscountService {
  /// Lấy danh sách mã đã lưu của người dùng
  static Future<List<DiscountModel>> getSavedDiscounts(int userId) async {
    final response = await http.get(
      Uri.parse('${API.getSavedDiscounts}/$userId'),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => DiscountModel.fromJson(json)).toList();
    } else {
      throw Exception('Không thể lấy danh sách mã đã lưu');
    }
  }

  /// Áp dụng mã đã lưu
  static Future<Map<String, dynamic>> applySavedDiscount({
    required int userId,
    required int discountId,
    required double tongTien,
  }) async {
    final response = await http.post(
      Uri.parse(API.applySavedDiscount),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'discount_id': discountId,
        'tong_tien': tongTien,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['error']);
    }
  }

  /// Lưu mã giảm giá
  static Future<void> saveDiscount({
    required int userId,
    required int discountId,
  }) async {
    final response = await http.post(
      Uri.parse(API.saveDiscount),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id_nguoi_dung': userId,
        'discount_id': discountId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Lưu mã thất bại');
    }
  }
}
