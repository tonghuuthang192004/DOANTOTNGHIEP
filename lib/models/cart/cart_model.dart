import '../product/product_model.dart';

class CartModel {
  final String id; // ID dòng chi tiết giỏ hàng (gio_hang_chi_tiet.id)
  final ProductModel product;
  final int quantity;

  CartModel({
    required this.id,
    required this.product,
    required this.quantity,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'].toString(),
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
        'danh_muc_id': json['danh_muc_id'],
      }),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'so_luong': quantity,
      'id_san_pham': product.id,
    };
  }
}
