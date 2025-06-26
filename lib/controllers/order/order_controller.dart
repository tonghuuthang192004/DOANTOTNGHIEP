import 'package:flutter/foundation.dart';
import '../../models/order/order_detail_model.dart';
import '../../models/order/order_model.dart';
import '../../services/order/order_service.dart';

class OrderController {
  /// 🔄 Lấy danh sách đơn hàng của người dùng, có thể lọc theo trạng thái
  Future<List<OrderModel>> fetchOrders({String? status}) async {
    try {
      return await OrderService.fetchOrders(status: status);
    } catch (e) {
      debugPrint('❌ [OrderController] fetchOrders error: $e');
      rethrow;
    }
  }

  /// ❌ Hủy đơn hàng theo ID
  Future<bool> cancelOrder(int orderId) async {
    try {
      return await OrderService.cancelOrder(orderId);
    } catch (e) {
      debugPrint('❌ [OrderController] cancelOrder error: $e');
      return false;
    }
  }

  /// 🔁 Mua lại đơn hàng cũ
  Future<bool> reorder(int orderId) async {
    try {
      return await OrderService.reorder(orderId);
    } catch (e) {
      debugPrint('❌ [OrderController] reorder error: $e');
      return false;
    }
  }

  /// 📋 Lấy chi tiết đơn hàng theo ID
  Future<List<OrderItemModel>> fetchOrderDetail(int orderId) async {
    try {
      return await OrderService.fetchOrderDetail(orderId);
    } catch (e) {
      debugPrint('❌ [OrderController] fetchOrderDetail error: $e');
      return [];
    }
  }

  /// ⭐ Gửi đánh giá sản phẩm
  Future<bool> submitRating({
    required int productId,
    required int score,
    String? comment,
  }) async {
    try {
      return await OrderService.rateProduct(
        productId: productId,
        score: score,
        comment: comment,
      );
    } catch (e) {
      debugPrint('❌ [OrderController] submitRating error: $e');
      return false;
    }
  }
}
