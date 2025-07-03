import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../api/api_constants.dart';
import '../../models/product/product_model.dart';
import '../../models/user/user_token.dart';

class ProductService {
  /// 🛍️ Lấy sản phẩm theo danh mục
  static Future<List<ProductModel>> getProductsByCategory(int categoryId) async {
    try {
      final url = Uri.parse(API.getProductsByCategory(categoryId));
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> resData = json.decode(response.body);
        if (resData['success'] == true && resData['data'] != null) {
          final List data = resData['data'];
          return data.map((item) => ProductModel.fromJson(item)).toList();
        } else {
          throw Exception('Dữ liệu sản phẩm theo danh mục không hợp lệ');
        }
      } else {
        print('❌ API lỗi với status: ${response.statusCode}');
        throw Exception('Không thể tải sản phẩm theo danh mục');
      }
    } catch (e) {
      print('❌ Lỗi kết nối hoặc phân tích JSON: $e');
      throw Exception('Lỗi tải sản phẩm theo danh mục');
    }
  }

  /// 🛍️ Lấy tất cả sản phẩm
  static Future<List<ProductModel>> getAllProducts() async {
    try {
      final url = Uri.parse(API.getAllProducts);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> resData = json.decode(response.body);
        if (resData['success'] == true && resData['data'] != null) {
          final List data = resData['data'];
          return data.map((item) => ProductModel.fromJson(item)).toList();
        } else {
          throw Exception('Dữ liệu tất cả sản phẩm không hợp lệ');
        }
      } else {
        print('❌ API lỗi khi tải tất cả sản phẩm: ${response.statusCode}');
        throw Exception('Không thể tải tất cả sản phẩm');
      }
    } catch (e) {
      print('❌ Lỗi kết nối khi tải tất cả sản phẩm: $e');
      throw Exception('Lỗi tải toàn bộ sản phẩm');
    }
  }

  /// 🔎 Tìm kiếm sản phẩm
  static Future<List<ProductModel>> searchProducts(String keyword) async {
    try {
      final url = Uri.parse(API.searchProducts(keyword));
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> resData = json.decode(response.body);
        if (resData['success'] == true && resData['data'] != null) {
          final List data = resData['data'];
          return data.map((item) => ProductModel.fromJson(item)).toList();
        } else {
          return [];
        }
      } else {
        print('❌ Lỗi khi tìm kiếm sản phẩm: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Lỗi kết nối tìm kiếm: $e');
      return [];
    }
  }

  /// 🔥 Lấy danh sách sản phẩm HOT
  static Future<List<ProductModel>> getHotProducts() async {
    try {
      final url = Uri.parse(API.getHotProducts);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> resData = json.decode(response.body);
        if (resData['success'] == true && resData['data'] != null) {
          final List data = resData['data'];
          return data.map((item) => ProductModel.fromJson(item)).toList();
        } else {
          return [];
        }
      } else {
        print('❌ Lỗi khi lấy sản phẩm hot: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Lỗi kết nối khi lấy sản phẩm hot: $e');
      return [];
    }
  }

  /// 📦 Lấy chi tiết sản phẩm theo ID
  static Future<ProductModel?> getProductById(int id) async {
    try {
      final url = Uri.parse(API.getProductById(id));
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> resData = json.decode(response.body);
        if (resData['success'] == true && resData['data'] != null) {
          return ProductModel.fromJson(resData['data']);
        } else {
          print('⚠️ Không tìm thấy sản phẩm với ID: $id');
          return null;
        }
      } else {
        print('❌ Lỗi khi lấy chi tiết sản phẩm: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Lỗi khi kết nối hoặc phân tích JSON chi tiết sản phẩm: $e');
      return null;
    }
  }

  /// ⭐ Gửi đánh giá sản phẩm
  static Future<bool> submitReview({
    required int productId,
    required int score,
    String? comment,
  }) async {
    try {
      final token = await UserToken.getToken();
      final url = Uri.parse('${API.baseUrl}/ratings');

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
        final resData = json.decode(response.body);
        return resData['success'] == true;
      } else {
        print('❌ Lỗi khi gửi đánh giá: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Lỗi kết nối khi gửi đánh giá: $e');
      return false;
    }
  }
}
