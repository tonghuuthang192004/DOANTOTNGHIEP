import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../api/api_constants.dart';
import '../../models/cart/cart_model.dart';
import '../../models/order/order_model.dart';
import '../../models/order/order_detail_model.dart';
import '../../models/user/user_token.dart';

class OrderService {
  /// 🔐 Tạo headers dùng token
  static Future<Map<String, String>> getAuthHeader({bool isJson = true}) async {
    final token = await UserToken.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("⚠️ Người dùng chưa đăng nhập.");
    }

    return {
      'Authorization': 'Bearer $token',
      if (isJson) 'Content-Type': 'application/json',
    };
  }

  /// 📦 Lấy danh sách đơn hàng người dùng (có thể lọc theo trạng thái)
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

  /// ❌ Hủy đơn hàng
  static Future<bool> cancelOrder(int orderId) async {
    final headers = await getAuthHeader();
    final res = await http.put(Uri.parse(API.cancelOrder(orderId)), headers: headers);
    return res.statusCode == 200;
  }

  /// 🔁 Mua lại đơn hàng
  static Future<bool> reorder(int orderId) async {
    final headers = await getAuthHeader();
    final res = await http.post(Uri.parse(API.reorder(orderId)), headers: headers);
    return res.statusCode == 200;
  }

  /// 📋 Lấy chi tiết đơn hàng
  static Future<List<OrderItemModel>> fetchOrderDetail(int orderId) async {
    final headers = await getAuthHeader();
    final res = await http.get(Uri.parse(API.orderDetail(orderId)), headers: headers);

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body)['data'] ?? [];
      return data.map((e) => OrderItemModel.fromJson(e)).toList();
    } else {
      throw Exception('❌ Lỗi khi lấy chi tiết đơn hàng: ${res.body}');
    }
  }

  /// ⭐ Gửi đánh giá sản phẩm
  static Future<bool> rateProduct({
    required int productId,
    required int score,
    String? comment,
  }) async {
    if (score < 1 || score > 5) {
      throw Exception('❌ Điểm đánh giá phải từ 1 đến 5.');
    }

    final headers = await getAuthHeader();
    final body = {
      'productId': productId,
      'score': score,
      'comment': comment ?? '',
    };

    final res = await http.post(Uri.parse(API.rateProduct),
        headers: headers, body: jsonEncode(body));

    return res.statusCode == 200;
  }

  /// ✅ Tạo đơn hàng từ giỏ hàng
  static Future<int> checkout({
    required int addressId,
    required String paymentMethod,
    required String note,
  }) async {
    final headers = await getAuthHeader();
    final body = {
      'id_dia_chi': addressId,
      'phuong_thuc_thanh_toan': paymentMethod,
      'ghi_chu': note,
    };

    final res = await http.post(
      Uri.parse(API.checkout),
      headers: headers,
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['id_don_hang']; // ✅ TRẢ VỀ ID đơn hàng
    }

    final error = jsonDecode(res.body);
    throw Exception("❌ ${error['message'] ?? 'Đặt hàng thất bại'}");
  }

  /// 🛒 Lấy giỏ hàng hiện tại
  static Future<List<CartModel>> fetchCart() async {
    final headers = await getAuthHeader(isJson: false);

    final res = await http.get(Uri.parse(API.cart), headers: headers);

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      final List data = body['data'] ?? [];
      print("📦 fetchCart raw data: $data");
      return data.map((e) => CartModel.fromJson(e)).toList();
    } else {
      print("❌ API cart error: ${res.body}");
      throw Exception('❌ Lỗi khi lấy giỏ hàng: ${res.body}');
    }
  }



  /// 🔗 Gửi yêu cầu thanh toán MoMo
  static Future<String?> createMomoPayment(int orderId, double amount) async {
    final headers = await getAuthHeader();
    final body = {'orderId': orderId, 'amount': amount.toInt()};

    final res = await http.post(
      Uri.parse(API.momoPayment),
      headers: headers,
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body)['payUrl'];
    } else {
      print('❌ MoMo lỗi: ${res.body}');
      return null;
    }
  }

  static Future<bool> confirmCodPayment(int orderId) async {
    final headers = await getAuthHeader();
    headers['Content-Type'] = 'application/json'; // ✅ BẮT BUỘC

    final body = {'orderId': orderId};

    final res = await http.post(
      Uri.parse(API.confirmCod), // ✅ dùng API.confirmCod đã sửa đúng
      headers: headers,
      body: jsonEncode(body),
    );

    print("📦 Xác nhận COD response: ${res.body}");
    print("📦 Status code: ${res.statusCode}");

    return res.statusCode == 200;
  }
  static Future<double> getCartTotalPrice() async {
    final cartList = await fetchCart();

    double total = 0;

    for (var item in cartList) {
      total += item.quantity * item.product.gia;
    }

    return total < 0 ? 0 : total;
  }

}
