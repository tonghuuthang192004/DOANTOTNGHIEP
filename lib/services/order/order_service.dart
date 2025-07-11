import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontendtn1/models/discount/discount_model.dart';
import 'package:frontendtn1/services/discount/discount_service.dart';
import 'package:http/http.dart' as http;
import '../../api/api_constants.dart';
import '../../models/cart/cart_model.dart';
import '../../models/order/order_model.dart';
import '../../models/order/order_detail_model.dart';
import '../../models/user/user_token.dart';
import '../cart/cart_service.dart';
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
  }/// 📦 Lấy danh sách đơn hàng
  /// 📦 Lấy danh sách đơn hàng
  /// 📦 Lấy danh sách đơn hàng
  static Future<List<OrderModel>> fetchOrders({String? trang_thai, required int userId}) async {
    try {
      final headers = await getAuthHeader();

      // Clean 'trang_thai' value to ensure no quotes are added
      final cleanTrangThai = trang_thai?.replaceAll("'", "");

      // Check if trang_thai is valid and set the query parameters accordingly
      final queryParams = {
        if (cleanTrangThai != null && cleanTrangThai.isNotEmpty) 'trang_thai': cleanTrangThai,
      };

      // Build the final URL, making sure 'trang_thai' is included if it's not empty
      final url = Uri.parse('${API.myOrders}?${Uri(queryParameters: queryParams).query}');

      // Log the URL to check correctness
      debugPrint('Request URL: $url');

      // Make the GET request
      final res = await http.get(url, headers: headers);

      print('Response status: ${res.statusCode}');
      print('Response body: ${res.body}');

      if (res.statusCode == 200) {
        // Parse the response body: use the correct key 'orders'
        final List data = jsonDecode(res.body)['orders'] ?? [];
        return data.map((e) => OrderModel.fromJson(e)).toList();
      } else {
        throw Exception('❌ Lỗi khi tải đơn hàng: ${res.body}');
      }
    } catch (e) {
      debugPrint('❌ [OrderController] fetchOrders error: $e');
      rethrow;
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
  static Future<Map<String, dynamic>> checkout({
    required int addressId,
    required String paymentMethod,
    String? note,
  }) async {
    // Lấy thông tin giỏ hàng từ CartService
    List<CartModel> cartItems = await CartService.fetchCart();
    List<DiscountModel> disItem = await DiscountService.getAllDiscounts();

    if (cartItems.isEmpty) {
      debugPrint('❌ Giỏ hàng trống.');
      throw Exception('Giỏ hàng của bạn trống, vui lòng thêm sản phẩm vào giỏ hàng.');
    }

    // Lấy id_nguoi_dung từ UserSession
    final userId = await UserSession.getUserId();

    // Nếu không lấy được id_nguoi_dung, ném lỗi
    if (userId == null) {
      debugPrint('❌ Không lấy được ID người dùng.');
      throw Exception('Vui lòng đăng nhập để tiếp tục.');
    }

    // Chuyển giỏ hàng thành danh sách chi tiết sản phẩm
    List<Map<String, dynamic>> orderDetails = cartItems.map((item) {
      return {
        'id_san_pham': item.product.id,  // Đảm bảo tên trường chính xác là id_san_pham
        'so_luong': item.quantity,        // Đảm bảo tên trường là so_luong
        'ghi_chu': note ?? '',           // Thêm ghi chú nếu có
      };
    }).toList();

    // Kiểm tra nếu có mã giảm giá và chỉ lấy mã giảm giá đầu tiên
    List<String> discountCodes = [];
    if (disItem.isNotEmpty && disItem[0].ma.isNotEmpty) {
      discountCodes.add(disItem[0].ma); // Lấy mã giảm giá đầu tiên từ danh sách
    }

    print("Mã giảm giá đang sử dụng: $discountCodes");

    // Kiểm tra cấu trúc orderDetails trước khi gửi
    debugPrint("Order Details: $orderDetails");
    debugPrint("Discount Codes: $discountCodes");

    // Lấy header xác thực (token hoặc các thông tin khác nếu cần)
    final headers = await getAuthHeader();

    // Kiểm tra nếu headers là null hoặc không hợp lệ
    if (headers.isEmpty) {
      debugPrint('❌ Không có header xác thực.');
      throw Exception('Không thể xác thực yêu cầu, vui lòng đăng nhập lại.');
    }

    // Chuẩn bị body yêu cầu API
    final body = jsonEncode({
      'id_nguoi_dung': userId,            // Thêm id_nguoi_dung vào body
      'id_dia_chi': addressId,            // Địa chỉ người nhận
      'phuong_thuc_thanh_toan': paymentMethod, // Phương thức thanh toán
      'ghi_chu': note ?? '',              // Ghi chú, nếu có
      'chi_tiet_san_pham': orderDetails,
      'ma_giam_gia': discountCodes.isNotEmpty ? discountCodes[0] : null, // Truyền 1 mã giảm giá nếu có, nếu không thì truyền null
    });

    // Debug body để kiểm tra cấu trúc
    debugPrint("Request Body: $body");

    try {
      // Gửi yêu cầu thanh toán tới API checkout
      final res = await http.post(Uri.parse(API.checkout), headers: headers, body: body);

      // Kiểm tra phản hồi từ server
      Map<String, dynamic> data;
      try {
        data = jsonDecode(res.body);
      } catch (e) {
        debugPrint('❌ Không thể parse JSON: ${res.body}');
        throw Exception('⚠️ Server trả về dữ liệu không hợp lệ.');
      }

      // Kiểm tra mã trạng thái phản hồi
      if (res.statusCode == 200 || res.statusCode == 201) {
        return {
          'orderId': data['orderId'],
          'message': data['message'],
          'payUrl': data['payUrl'], // URL thanh toán (nếu có, ví dụ: MoMo)
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
