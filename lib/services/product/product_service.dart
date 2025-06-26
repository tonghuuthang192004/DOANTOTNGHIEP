import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../api/api_constants.dart';
import '../../models/product/product_model.dart';
import '../../models/user/user_token.dart';

class ProductService {
  // Lấy sản phẩm theo danh mục
  static Future<List<ProductModel>> getProductsByCategory(
      int categoryId) async {
    try {
      final url = Uri.parse('${API.getProductByCategory}/$categoryId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> resData = json.decode(response.body);
        final List data = resData['data'];
        return data.map((item) => ProductModel.fromJson(item)).toList();
      } else {
        print('API lỗi với status: ${response.statusCode}');
        print('Nội dung lỗi: ${response.body}');
        throw Exception('Không thể tải sản phẩm theo danh mục');
      }
    } catch (e) {
      print('Lỗi kết nối hoặc phân tích JSON: $e');
      throw Exception('Lỗi tải sản phẩm theo danh mục');
    }
  }

  static Future<List<ProductModel>> getAllProducts() async {
    try {
      final url = Uri.parse(API.getAllProducts);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> resData = json.decode(response.body);
        final List data = resData['data']; // ✅ chính xác
        return data.map((item) => ProductModel.fromJson(item)).toList();
      } else {
        print('API lỗi khi tải tất cả sản phẩm: ${response.statusCode}');
        throw Exception('Không thể tải tất cả sản phẩm');
      }
    } catch (e) {
      print('Lỗi kết nối khi tải tất cả sản phẩm: $e');
      throw Exception('Lỗi tải toàn bộ sản phẩm');
    }
  }


  static Future<List<ProductModel>> searchProducts(String keyword) async {
    try {
      final url = Uri.parse('${API.searchProducts}?q=$keyword');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((item) => ProductModel.fromJson(item)).toList();
      } else {
        print('Lỗi khi tìm kiếm sản phẩm: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Lỗi kết nối tìm kiếm: $e');
      return [];
    }
  }

  static Future<List<ProductModel>> getHotProducts() async {
    try {
      final url = Uri.parse(API.getHotProducts);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> resData = json.decode(response.body);
        final List data = resData['data']; // ✅ Lấy từ key 'data'
        return data.map((item) => ProductModel.fromJson(item)).toList();
      } else {
        print('Lỗi khi lấy sản phẩm hot: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Lỗi kết nối khi lấy sản phẩm hot: $e');
      return [];
    }
  }

  static Future<ProductModel?> getProductById(int id) async {
    try {
      final url = Uri.parse('${API.getProductById}/$id');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = json.decode(response.body);
        if (jsonBody['success'] == true && jsonBody['data'] != null) {
          return ProductModel.fromJson(jsonBody['data']); // 👈 sửa ở đây
        } else {
          print('Không tìm thấy sản phẩm với ID: $id');
          return null;
        }
      } else {
        print('Lỗi khi lấy chi tiết sản phẩm: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Lỗi khi kết nối hoặc phân tích JSON chi tiết sản phẩm: $e');
      return null;
    }
  }
  /// ✅ Gửi đánh giá sản phẩm
  static Future<bool> submitReview({
    required int productId,
    required int score,
    String? comment,
  }) async {
    final token = await UserToken.getToken();
    final url = Uri.parse('${API.baseUrl}/ratings'); // hoặc endpoint bạn đã đặt

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_san_pham': productId,
        'diem_so': score,
        'nhan_xet': comment ?? '',
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('❌ Lỗi khi gửi đánh giá: ${response.body}');
      return false;
    }
  }
}
