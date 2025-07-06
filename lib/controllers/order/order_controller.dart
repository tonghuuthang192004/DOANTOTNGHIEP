import 'package:flutter/foundation.dart';
import '../../models/order/order_detail_model.dart';
import '../../models/order/order_model.dart';
import '../../services/order/order_service.dart';

class OrderController {
  Future<List<OrderModel>> fetchOrders({String? status}) async {
    try {
      return await OrderService.fetchOrders(status: status);
    } catch (e) {
      debugPrint('❌ [OrderController] fetchOrders error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchOrderDetail(int orderId) async {
    try {
      return await OrderService.fetchOrderDetail(orderId);
    } catch (e) {
      debugPrint('❌ [OrderController] fetchOrderDetail error: $e');
      return {'order': null, 'items': <OrderItemModel>[]};
    }
  }

  Future<bool> cancelOrder(int orderId) async {
    try {
      return await OrderService.cancelOrder(orderId);
    } catch (e) {
      debugPrint('❌ [OrderController] cancelOrder error: $e');
      return false;
    }
  }

  Future<bool> reorder(int orderId) async {
    try {
      return await OrderService.reorder(orderId);
    } catch (e) {
      debugPrint('❌ [OrderController] reorder error: $e');
      return false;
    }
  }

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
      rethrow; // cho UI biết lỗi để xử lý
    }
  }


  Future<List<Map<String, dynamic>>> fetchProductReviews(int productId) async {
    try {
      return await OrderService.fetchProductReviews(productId);
    } catch (e) {
      debugPrint('❌ [OrderController] fetchProductReviews error: $e');
      return [];
    }
  }

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

  Future<double> getCartTotalPrice() async {
    try {
      return await OrderService.getCartTotalPrice();
    } catch (e) {
      debugPrint('❌ [OrderController] getCartTotalPrice error: $e');
      return 0.0;
    }
  }

  /// 📥 Lấy lịch sử đơn hàng
  Future<List<OrderModel>> fetchOrderHistory() async {
    try {
      return await OrderService.fetchOrderHistory();
    } catch (e) {
      debugPrint('❌ [OrderController] fetchOrderHistory error: $e');
      return [];
    }
  }
}
