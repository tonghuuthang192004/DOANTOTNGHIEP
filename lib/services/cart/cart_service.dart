import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../api/api_constants.dart';
import '../../models/product/product_model.dart';
import '../../models/cart/cart_model.dart';
import '../../models/user/user_token.dart';
import '../../services/user/user_session.dart';

class CartService {
  /// 🔁 Lấy giỏ hàng hiện tại của user
  static Future<List<CartModel>> fetchCart() async {
    final token = await UserToken.getToken();
    final userId = await UserSession.getUserId();
    if (userId == null) throw Exception("Người dùng chưa đăng nhập");

    print("📦 Token đang dùng: $token");
    print("🧑‍💼 User ID đang dùng: $userId");

    final url = Uri.parse(API.getCartItems); // API nên trả giỏ hàng dựa trên token
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data as List).map((e) => CartModel.fromJson(e)).toList();
    } else {
      throw Exception("❌ Lỗi khi tải giỏ hàng: ${response.body}");
    }
  }

  /// ➕ Thêm sản phẩm vào giỏ
  static Future<void> addToCart(ProductModel product, {int quantity = 1}) async {
    final token = await UserToken.getToken();
    final userId = await UserSession.getUserId();
    if (userId == null) throw Exception("Người dùng chưa đăng nhập");

    final url = Uri.parse(API.addToCart);
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "id_san_pham": product.id,
        "so_luong": quantity,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("❌ Lỗi khi thêm vào giỏ hàng: ${response.body}");
    }
  }

  /// 🔄 Cập nhật số lượng
  static Future<void> updateQuantity(String itemId, int quantity) async {
    final token = await UserToken.getToken();
    final url = Uri.parse(API.updateCartItem);

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "itemId": int.parse(itemId),
        "quantity": quantity,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("❌ Lỗi khi cập nhật số lượng: ${response.body}");
    }
  }

  /// ❌ Xoá sản phẩm khỏi giỏ
  static Future<void> removeCartItem(String itemId) async {
    final token = await UserToken.getToken();
    final url = Uri.parse(API.deleteCartItem);

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "itemId": int.parse(itemId),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("❌ Lỗi khi xoá sản phẩm: ${response.body}");
    }
  }

  /// 🧹 Xoá toàn bộ giỏ hàng
  static Future<void> clearCart() async {
    final token = await UserToken.getToken();
    final url = Uri.parse(API.clearCart);

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception("❌ Lỗi khi xoá toàn bộ giỏ hàng: ${response.body}");
    }
  }
}
