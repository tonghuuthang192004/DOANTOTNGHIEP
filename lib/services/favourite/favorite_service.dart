import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../api/api_constants.dart';
import '../../models/product/product_model.dart';
import '../user/user_session.dart';

class FavoriteService {
  static Future<List<ProductModel>> getFavorites(int userId) async {
    final uri = Uri.parse('${API.getFavourites}/$userId');
    print("🔍 [FavoriteService] Gửi GET đến: $uri");

    final response = await http.get(uri);
    print("📥 Status: ${response.statusCode}");
    print("📄 Body: ${response.body}");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded['data'] is List) {
        return (decoded['data'] as List)
            .map((json) => ProductModel.fromJson(json))
            .toList();
      } else {
        print("❌ Dữ liệu 'data' không phải List: ${decoded['data']}");
        throw Exception("Sai định dạng dữ liệu từ backend");
      }
    } else {
      throw Exception("Không thể tải danh sách yêu thích: ${response.body}");
    }
  }

  static Future<bool> addFavorite(int productId) async {
    final userId = await UserSession.getUserId();
    if (userId == null) throw Exception("Chưa đăng nhập");

    final response = await http.post(
      Uri.parse(API.addToFavourites),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'productId': productId}),
    );

    return response.statusCode == 200;
  }

  static Future<bool> removeFavorite(int userId, int productId) async {
    final uri = Uri.parse(API.removeFavourite(userId, productId));
    final response = await http.delete(uri);
    return response.statusCode == 200;
  }

  static Future<bool> clearFavorites() async {
    final userId = await UserSession.getUserId();
    if (userId == null) throw Exception("Chưa đăng nhập");

    final response = await http.delete(Uri.parse(API.clearFavourites(userId)));
    return response.statusCode == 200;
  }

  static Future<int?> getCurrentUserId() async {
    return await UserSession.getUserId();
  }
}
