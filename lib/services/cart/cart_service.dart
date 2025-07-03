import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../api/api_constants.dart';
import '../../models/product/product_model.dart';
import '../../models/cart/cart_model.dart';
import '../../models/user/user_token.dart';

class CartService {
  static Future<List<CartModel>> fetchCart() async {
    final token = await UserToken.getToken();
    final url = Uri.parse(API.cart);
    final response =
    await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> dataList = responseData['data'];
      return dataList.map((e) => CartModel.fromJson(e)).toList();
    } else {
      throw Exception("❌ Lỗi khi tải giỏ hàng: ${response.body}");
    }
  }

  static Future<void> addToCart(ProductModel product,
      {int quantity = 1}) async {
    final token = await UserToken.getToken();
    final url = Uri.parse(API.addToCart);

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "id_san_pham": product.id,
        "so_luong": quantity, // ✅ key đúng với backend
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("❌ Lỗi khi thêm vào giỏ hàng: ${response.body}");
    }
  }

  static Future<void> updateQuantity(String productId, int quantity) async {
    final token = await UserToken.getToken();
    final url = Uri.parse(API.updateCartItem(productId));

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'so_luong': quantity}), // ✅ đổi quantity -> so_luong
    );

    if (response.statusCode != 200) {
      throw Exception('❌ Update quantity failed: ${response.body}');
    }
  }

  static Future<void> removeCartItem(String productId) async {
    final token = await UserToken.getToken();
    final url = Uri.parse(API.deleteCartItem(productId));

    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception("❌ Lỗi khi xoá sản phẩm: ${response.body}");
    }
  }

  static Future<void> clearCart() async {
    final token = await UserToken.getToken();
    final url = Uri.parse(API.clearCart);

    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception("❌ Lỗi khi xoá toàn bộ giỏ hàng: ${response.body}");
    }
  }
}
