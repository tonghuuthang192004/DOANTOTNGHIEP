import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../api/api_constants.dart';
import '../../models/product/product_model.dart';
import '../user/user_session.dart';

class FavoriteService {
  /// 📥 Lấy danh sách sản phẩm yêu thích
  static Future<List<ProductModel>> getFavorites(int userId) async {
    final uri = Uri.parse('${API.getFavourites}/$userId');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        return (data as List)
            .map((json) => ProductModel.fromJson(json))
            .toList();
      } else {
        throw Exception("❌ Không thể tải danh sách yêu thích: ${response.body}");
      }
    } catch (e) {
      throw Exception('🔥 [getFavorites] Lỗi: $e');
    }
  }

  /// ❓ Kiểm tra trạng thái yêu thích: true / false / 'deleted'
  static Future<dynamic> isFavorite(int productId, int userId) async {
    final uri = Uri.parse(API.isFavorite(productId, userId));
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      } else {
        throw Exception('❌ Lỗi lấy trạng thái yêu thích (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('🔥 [isFavorite] Lỗi: $e');
    }
  }

  /// ➕ Thêm sản phẩm vào yêu thích
  static Future<bool> addFavorite(int userId, int productId) async {
    final uri = Uri.parse(API.addToFavourites);
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId, 'productId': productId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body)['success'] == true;
      } else {
        throw Exception(jsonDecode(response.body)['message'] ?? "❌ Thêm yêu thích thất bại");
      }
    } catch (e) {
      throw Exception('🔥 [addFavorite] Lỗi: $e');
    }
  }

  /// ❌ Xoá 1 sản phẩm khỏi yêu thích
  static Future<bool> removeFavorite(int productId, int userId) async {
    final uri = Uri.parse(API.removeFavourite(productId, userId));
    try {
      final response = await http.delete(uri);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(jsonDecode(response.body)['message'] ?? "❌ Xoá yêu thích thất bại");
      }
    } catch (e) {
      throw Exception('🔥 [removeFavorite] Lỗi: $e');
    }
  }

  /// 🧹 Xoá toàn bộ sản phẩm yêu thích
  static Future<bool> clearFavorites(int userId) async {
    final uri = Uri.parse(API.clearFavourites(userId));
    try {
      final response = await http.delete(uri);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(jsonDecode(response.body)['message'] ?? "❌ Xoá toàn bộ yêu thích thất bại");
      }
    } catch (e) {
      throw Exception('🔥 [clearFavorites] Lỗi: $e');
    }
  }

  /// 🔑 Lấy userId hiện tại
  static Future<int?> getCurrentUserId() async {
    return await UserSession.getUserId();
  }
}
