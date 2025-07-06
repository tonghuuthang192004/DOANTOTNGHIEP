import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../api/api_constants.dart';
import '../../models/cart/cart_model.dart';
import '../../models/order/order_model.dart';
import '../../models/order/order_detail_model.dart';
import '../../models/user/user_token.dart';
import '../user/user_session.dart';

class OrderService {
  /// 🔐 Lấy header Auth
  static Future<Map<String, String>> getAuthHeader({bool isJson = true}) async {
    final token = await UserToken.getToken();
    if (token == null) throw Exception("⚠️ Người dùng chưa đăng nhập.");
    return {
      'Authorization': 'Bearer $token',
      if (isJson) 'Content-Type': 'application/json',
    };
  }

  /// 📦 Lấy danh sách đơn hàng
  static Future<List<OrderModel>> fetchOrders({String? status}) async {
    final headers = await getAuthHeader();
    final url = Uri.parse('${API.myOrders}${status != null ? '?status=$status' : ''}');
    final res = await http.get(url, headers: headers);
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body)['data'] ?? [];
      return data.map((e) => OrderModel.fromJson(e)).toList();
    } else {
      throw Exception('❌ Lỗi khi tải đơn hàng: ${res.body}');
    }
  }

  static Future<Map<String, dynamic>> fetchOrderDetail(int orderId) async {
    final headers = await getAuthHeader();
    final res = await http.get(Uri.parse(API.orderDetail(orderId)), headers: headers);

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      final data = body['data'];

      if (data is List) {
        final parsedItems = data
            .whereType<Map<String, dynamic>>()
            .map(OrderItemModel.fromJson)
            .toList();

        // 📌 Lấy info người mua từ item đầu tiên
        final firstItem = parsedItems.isNotEmpty ? parsedItems.first : null;

        final orderInfo = firstItem != null
            ? {
          'customerName': firstItem.customerName,
          'customerPhone': firstItem.customerPhone,
          'shippingAddress': firstItem.shippingAddress,
          'paymentStatus': firstItem.paymentStatus,
        }
            : null;
        return {
          'order': orderInfo,
          'items': parsedItems,
        };
      }
      else {
        throw Exception('Dữ liệu data không đúng định dạng');
      }
    } else {
      throw Exception('Lỗi khi lấy chi tiết đơn hàng: ${res.body}');
    }
  }

  /// ❌ Hủy đơn hàng
  static Future<bool> cancelOrder(int orderId) async {
    final headers = await getAuthHeader();
    final res = await http.patch(Uri.parse(API.cancelOrder(orderId)), headers: headers);
    return res.statusCode >= 200 && res.statusCode < 300;
  }

  /// 🔁 Mua lại đơn hàng
  static Future<bool> reorder(int orderId) async {
    final headers = await getAuthHeader();
    final res = await http.post(Uri.parse(API.reorder(orderId)), headers: headers);
    return res.statusCode >= 200 && res.statusCode < 300;
  }

  /// ⭐ Đánh giá sản phẩm
  static Future<bool> rateProduct({
    required int productId,
    required int score,
    String? comment,
  }) async {
    if (score < 1 || score > 5) {
      throw Exception('❌ Điểm đánh giá phải từ 1-5.');
    }
    final headers = await getAuthHeader();
    final body = jsonEncode({'diem_so': score, 'nhan_xet': comment ?? ''});
    final res = await http.post(Uri.parse(API.rateProduct(productId)), headers: headers, body: body);
    return res.statusCode == 200 || res.statusCode == 201;
  }

  /// 📥 Lấy đánh giá sản phẩm
  static Future<List<Map<String, dynamic>>> fetchProductReviews(int productId) async {
    final headers = await getAuthHeader();
    final url = Uri.parse(API.reviewProduct(productId));

    try {
      final res = await http.get(url, headers: headers);
      if (res.statusCode == 200) {
        final jsonBody = jsonDecode(res.body);

        if (jsonBody['success'] == true && jsonBody['data'] != null) {
          final List data = jsonBody['data'];
          return List<Map<String, dynamic>>.from(data);
        } else {
          throw Exception('Không có dữ liệu đánh giá');
        }
      } else {
        throw Exception('Lỗi khi tải đánh giá: ${res.statusCode}');
      }
    } catch (e) {
      // Có thể log hoặc xử lý lỗi thêm ở đây
      throw Exception('❌ Không thể tải đánh giá sản phẩm: $e');
    }
  }


  /// 🛒 Đặt hàng
  static Future<Map<String, dynamic>> checkout({
    required int addressId,
    required String paymentMethod,
    String? note,
  }) async {
    final headers = await getAuthHeader();
    final body = jsonEncode({
      'id_dia_chi': addressId,
      'phuong_thuc_thanh_toan': paymentMethod,
      'ghi_chu': note ?? '',
    });

    try {
      final res = await http.post(Uri.parse(API.checkout), headers: headers, body: body);

      Map<String, dynamic> data;
      try {
        data = jsonDecode(res.body);
      } catch (e) {
        debugPrint('❌ Không thể parse JSON: ${res.body}');
        throw Exception('⚠️ Server trả về dữ liệu không hợp lệ.');
      }

      if ((res.statusCode == 200 || res.statusCode == 201) && data['success'] == true) {
        return {
          'orderId': data['orderId'],
          'message': data['message'],
          'payUrl': data['payUrl'], // 👈 MoMo có, COD không
        };
      } else {
        final errorMessage = data['message'] ?? 'Lỗi không xác định từ server';
        debugPrint('❌ Checkout lỗi: $errorMessage');
        throw Exception('❌ Lỗi khi checkout: $errorMessage');
      }
    } catch (error) {
      debugPrint('❌ Exception khi gọi API checkout: $error');
      rethrow;
    }
  }

  /// 💰 Tạo thanh toán MoMo (nếu cần)
  static Future<String?> createMomoPayment(int orderId, double amount) async {
    final headers = await getAuthHeader();
    final body = jsonEncode({'orderId': orderId, 'amount': amount.toInt()});

    final res = await http.post(Uri.parse(API.momoPayment), headers: headers, body: body);
    try {
      final data = jsonDecode(res.body);
      if (res.statusCode == 200 && data['success'] == true) {
        return data['data']['payUrl'];
      } else {
        debugPrint('❌ createMomoPayment lỗi: ${data['message']}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ Không thể parse JSON MoMo: ${res.body}');
      return null;
    }
  }

  /// ✅ Xác nhận thanh toán COD
  static Future<bool> confirmCodPayment(int orderId) async {
    final headers = await getAuthHeader();
    final body = jsonEncode({'id_don_hang': orderId});

    final res = await http.post(Uri.parse(API.confirmCod), headers: headers, body: body);
    try {
      final data = jsonDecode(res.body);
      return res.statusCode == 200 && data['success'] == true;
    } catch (e) {
      debugPrint('❌ Không thể parse JSON khi xác nhận COD: ${res.body}');
      return false;
    }
  }

  /// 📥 Lấy giỏ hàng
  static Future<List<CartModel>> fetchCart() async {
    final headers = await getAuthHeader(isJson: false);
    final res = await http.get(Uri.parse(API.cart), headers: headers);
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body)['data'] ?? [];
      return data.map((e) => CartModel.fromJson(e)).toList();
    } else {
      throw Exception('❌ Lỗi khi lấy giỏ hàng: ${res.body}');
    }
  }

  /// 💰 Tính tổng tiền giỏ hàng (dựa trên fetchCart)
  static Future<double> getCartTotalPrice() async {
    final cartList = await fetchCart();
    return cartList.fold<double>(
      0.0,
          (double sum, item) => sum + (item.quantity * item.product.gia),
    );
  }

  /// 📥 Lấy lịch sử đơn hàng
  static Future<List<OrderModel>> fetchOrderHistory() async {
    final headers = await getAuthHeader();
    final res = await http.get(Uri.parse(API.orderHistory), headers: headers);
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body)['data'] ?? [];
      return data.map((e) => OrderModel.fromJson(e)).toList();
    } else {
      throw Exception('❌ Lỗi khi lấy lịch sử đơn hàng: ${res.body}');
    }
  }
}
