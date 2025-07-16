import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../api/api_constants.dart';
import '../../models/product/product_model.dart';
import '../../models/cart/cart_model.dart';
import '../../models/user/user_token.dart';

class CartService {
  static List<CartModel> _cartItems = [];

  static List<Map<String, dynamic>> getOrderDetails() {
    List<Map<String, dynamic>> orderDetails = _cartItems.map((item) {
      return {
        'productId': item.product.id,
        'quantity': item.quantity,
        'price': item.product.gia,
      };
    }).toList();

    print("Giỏ hàng sau khi kiểm tra: $orderDetails");  // In ra giỏ hàng để kiểm tra
    return orderDetails;
  }

  static void _showDialog(BuildContext context, String message, {bool isError = true}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isError ? 'Lỗi' : 'Thành công'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  static Future<List<CartModel>> fetchCart() async {
    try {
      final token = await UserToken.getToken();
      final url = Uri.parse(API.cart);
      final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> dataList = responseData['data'];
        return dataList.map((e) => CartModel.fromJson(e)).toList();
      } else {
        throw Exception("❌ Lỗi khi tải giỏ hàng: ${response.body}");
      }
    } catch (e) {
      throw Exception("❌ Đã xảy ra lỗi khi tải giỏ hàng: $e");
    }
  }

  static Future<void> addToCart(ProductModel product, {int quantity = 1}) async {
    try {
      // Validate product data
      if (product.id == null || product.id == 0) {
        throw Exception("❌ Mã sản phẩm không hợp lệ");
      }
      if (quantity <= 0) {
        throw Exception("❌ Số lượng phải lớn hơn 0");
      }
      if (product.gia == null || product.gia == 0.0) {
        throw Exception("❌ Giá sản phẩm không hợp lệ");
      }

      final token = await UserToken.getToken();
      if (token == null || token.isEmpty) {
        throw Exception("❌ Token không hợp lệ");
      }

      final url = Uri.parse(API.addToCart);

      print("Token: $token");
      print("Adding Product ID: ${product.id}, Quantity: $quantity");

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

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 400) {
        throw Exception("❌ Sản phẩm không đủ số lượng trong kho");
      } else if (response.statusCode == 404) {
        throw Exception("❌ Sản phẩm không tìm thấy");
      } else if (response.statusCode == 500) {
        throw Exception("❌ Lỗi máy chủ, vui lòng thử lại sau");
      } else if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("❌ Lỗi khi thêm vào giỏ hàng: ${response.body}");
      }

      print("Sản phẩm đã được thêm vào giỏ hàng!");
    } catch (e) {
      print("Error adding product to cart: $e");
      throw Exception("❌ Đã xảy ra lỗi khi thêm vào giỏ hàng: $e");
    }
  }

  static Future<void> updateQuantity(String productId, int quantity) async {
    try {
      final token = await UserToken.getToken();
      final url = Uri.parse(API.updateCartItem(productId));

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'so_luong': quantity}),
      );

      if (response.statusCode == 400) {
        throw Exception("❌ Sản phẩm không đủ số lượng trong kho");
      }
    } catch (e) {
      throw Exception("❌ Đã xảy ra lỗi khi cập nhật số lượng: $e");
    }
  }

  static Future<void> removeCartItem(String productId) async {
    try {
      final token = await UserToken.getToken();
      final url = Uri.parse(API.deleteCartItem(productId));

      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200) {
        throw Exception("❌ Lỗi khi xoá sản phẩm: ${response.body}");
      }
    } catch (e) {
      throw Exception("❌ Đã xảy ra lỗi khi xoá sản phẩm: $e");
    }
  }

  static Future<void> clearCart() async {
    try {
      final token = await UserToken.getToken();
      final url = Uri.parse(API.clearCart);

      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200) {
        throw Exception("❌ Lỗi khi xoá toàn bộ giỏ hàng: ${response.body}");
      }
    } catch (e) {
      throw Exception("❌ Đã xảy ra lỗi khi xoá toàn bộ giỏ hàng: $e");
    }
  }

  static Future<void> restoreCartItem(String productId, {int quantity = 1}) async {
    try {
      final token = await UserToken.getToken();
      final url = Uri.parse(API.restoreCartItem(productId));

      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'so_luong': quantity}),
      );

      if (response.statusCode != 200) {
        throw Exception('❌ Khôi phục sản phẩm thất bại: ${response.body}');
      }
    } catch (e) {
      throw Exception("❌ Đã xảy ra lỗi khi khôi phục sản phẩm: $e");
    }
  }
}
