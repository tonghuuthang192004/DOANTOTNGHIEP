import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../api/api_constants.dart';
import '../../models/discount/discount_model.dart';

class DiscountService {
  /// 🔥 Lấy danh sách voucher đang hoạt động
  ///

  static Future<List<DiscountModel>> getAllDiscounts() async {
    final response = await http.get(Uri.parse(API.getAllDiscounts));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => DiscountModel.fromJson(json)).toList();
    } else {
      throw Exception('Không thể lấy danh sách voucher');
    }
  }
  static Future<List<String>> getAllDiscountCodes() async {
    final List<DiscountModel> discounts = await getAllDiscounts();

    // Lấy tất cả mã giảm giá từ danh sách voucher
    List<String> discountCodes = discounts.map((discount) => discount.ma).toList();

    return discountCodes;
  }

  /// 📌 Lưu voucher cho người dùng
  static Future<void> saveDiscount({
    required int userId,
    required int discountId, // ✅ đổi tên tham số
  }) async {
    final response = await http.post(
      Uri.parse(API.saveDiscount),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id_nguoi_dung': userId,
        'id_giam_gia': discountId, // ✅ đồng bộ tên
      }),
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Lưu voucher thất bại');
    }
  }


  /// 📥 Lấy danh sách voucher đã lưu của người dùng
  static Future<List<DiscountModel>> getSavedDiscounts(int userId) async {
    final response = await http.get(
      Uri.parse('${API.getSavedDiscounts}/$userId'),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => DiscountModel.fromJson(json)).toList();
    } else {
      throw Exception('Không thể lấy danh sách voucher đã lưu');
    }
  }

  /// ✅ Áp dụng voucher khi thanh toán
  static Future<Map<String, dynamic>> applyDiscount({
    required int userId,
    required String maGiamGia,
    required double tongGiaTri,
  }) async {
    final response = await http.post(
      Uri.parse(API.applyDiscount),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id_nguoi_dung': userId,
        'ma_giam_gia': maGiamGia,
        'tong_gia_tri': tongGiaTri,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Áp dụng voucher thất bại');
    }
  }
}
