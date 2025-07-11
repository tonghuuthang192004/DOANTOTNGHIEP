import '../product/product_model.dart';

class CartModel {
  final String id; // ID của sản phẩm trong giỏ hàng
  final ProductModel product; // Thông tin sản phẩm
  final int quantity; // Số lượng sản phẩm trong giỏ hàng

  CartModel({
    required this.id,
    required this.product,
    required this.quantity,
  });

  // Chuyển đổi từ dữ liệu JSON trả về từ API thành CartModel
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id_san_pham'].toString(), // ID sản phẩm trong giỏ hàng
      quantity: json['so_luong'] is int
          ? json['so_luong']
          : int.tryParse(json['so_luong'].toString()) ?? 1,
      product: ProductModel.fromJson({
        'id': json['id_san_pham'],
        'ten': json['ten'] ?? '',
        'gia': json['gia'],
        'hinh_anh': json['hinh_anh'],
        'mo_ta': json['mo_ta'] ?? '',
        'danh_gia': json['danh_gia'] ?? 4.5,
        'id_danh_muc': json['id_danh_muc'],
        'so_luong_kho': json['so_luong_kho'],
      }),
    );
  }

  // Chuyển CartModel thành dữ liệu JSON để gửi lên API khi cần thiết
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'so_luong': quantity,
      'id_san_pham': product.id,
    };
  }
}
