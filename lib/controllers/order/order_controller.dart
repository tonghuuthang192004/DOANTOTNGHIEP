import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import '../../api/api_constants.dart';
import '../../models/order/order_detail_model.dart';
import '../../models/order/order_model.dart';
import '../../models/user/user_token.dart';
import '../../services/order/order_service.dart';
import '../../models/cart/cart_model.dart';

class OrderController {
  // Add cartItems as a class-level variable
  final Future<List<CartModel>> cartItemsFuture = OrderService.fetchCart();
  static Future<Map<String, String>> getAuthHeader({bool isJson = true}) async {
    final token = await UserToken.getToken();
    if (token == null) throw Exception("⚠️ Người dùng chưa đăng nhập.");
    return {
      'Authorization': 'Bearer $token',
      if (isJson) 'Content-Type': 'application/json',
    };
  }
  /// 📦 Fetch orders based on status
  static Future<List<OrderModel>> fetchOrders({String? trang_thai}) async {
    try {
      // Encode the status string if it's not null
      final encodedStatus = Uri.encodeComponent(trang_thai ?? '');

      // Construct the URL
      final url = Uri.parse('${API.myOrders}?trang_thai=$encodedStatus');

      // Get the headers for authentication
      final headers = await getAuthHeader();


      // Send the GET request
      final res = await http.get(url, headers: headers);
      print('Response status: ${res.statusCode}');
      print('Response body: ${res.body}');
      if (res.statusCode == 200) {
        // Parse the response body
        final List data = jsonDecode(res.body)['data'] ?? [];
        return data.map((e) => OrderModel.fromJson(e)).toList();
      } else {
        throw Exception('❌ Lỗi khi tải đơn hàng: ${res.body}');
      }
    } catch (e) {
      debugPrint('❌ [OrderController] fetchOrders error: $e');
      rethrow;
    }
  }


  /// 📦 Fetch order details
  Future<Map<String, dynamic>> fetchOrderDetail(int orderId) async {
    try {
      return await OrderService.fetchOrderDetail(orderId);
    } catch (e) {
      debugPrint('❌ [OrderController] fetchOrderDetail error: $e');
      return {'order': null, 'items': <OrderItemModel>[]};
    }
  }

  /// ❌ Cancel order
  Future<bool> cancelOrder(int orderId) async {
    try {
      return await OrderService.cancelOrder(orderId);
    } catch (e) {
      debugPrint('❌ [OrderController] cancelOrder error: $e');
      return false;
    }
  }

  /// 🔁 Reorder an order
  Future<bool> reorder(int orderId) async {
    try {
      return await OrderService.reorder(orderId);
    } catch (e) {
      debugPrint('❌ [OrderController] reorder error: $e');
      return false;
    }
  }

  /// ⭐ Submit a product rating
  Future<void> submitRating({
    required int productId,
    required int score,
    String? comment,
  }) async {
    try {
      final success = await OrderService.rateProduct(
        productId: productId,
        score: score,
        comment: comment,
      );
      if (!success) {
        throw Exception('Đánh giá thất bại');
      }
    } catch (e) {
      debugPrint('❌ [OrderController] submitRating error: $e');
      rethrow; // Notify UI to handle the error
    }
  }

  /// 📥 Fetch product reviews
  Future<List<Map<String, dynamic>>> fetchProductReviews(int productId) async {
    try {
      return await OrderService.fetchProductReviews(productId);
    } catch (e) {
      debugPrint('❌ [OrderController] fetchProductReviews error: $e');
      return [];
    }
  }

  /// 🛒 Checkout method that involves cart items
  Future<Map<String, dynamic>?> checkout({
    required int addressId,
    required String paymentMethod,
    String? note,
  }) async {
    try {
      debugPrint('📦 [OrderController] checkout gọi: addressId=$addressId, payment=$paymentMethod');
      return await OrderService.checkout(
        addressId: addressId,
        paymentMethod: paymentMethod,
        note: note ?? '',
      );
    } catch (e) {
      debugPrint('❌ [OrderController] checkout error: $e');
      return null;
    }
  }

  /// 💰 Calculate total cart price
  Future<double> getCartTotalPrice() async {
    try {
      return await OrderService.getCartTotalPrice();
    } catch (e) {
      debugPrint('❌ [OrderController] getCartTotalPrice error: $e');
      return 0.0;
    }
  }

  /// 📥 Fetch order history
  Future<List<OrderModel>> fetchOrderHistory() async {
    try {
      return await OrderService.fetchOrderHistory();
    } catch (e) {
      debugPrint('❌ [OrderController] fetchOrderHistory error: $e');
      return [];
    }
  }
}
