class OrderItemModel {
  final int productId;        // ✅ ID sản phẩm
  final String productName;   // ✅ Tên sản phẩm
  final String imageUrl;      // ✅ Link hình ảnh
  final double price;         // ✅ Giá từng sản phẩm
  final int quantity;         // ✅ Số lượng
  final double total;         // ✅ Tổng giá (price * quantity)

  OrderItemModel({
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.total,
  });
  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['id_san_pham'] is int
          ? json['id_san_pham']
          : int.tryParse(json['id_san_pham']?.toString() ?? '') ?? 0,
      productName: json['productName']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      price: json['price'] is num
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price']?.toString() ?? '') ?? 0.0,
      quantity: json['quantity'] is int
          ? json['quantity']
          : int.tryParse(json['quantity']?.toString() ?? '') ?? 0,
      total: json['total'] is num
          ? (json['total'] as num).toDouble()
          : double.tryParse(json['total']?.toString() ?? '') ?? 0.0,
    );
  }

}
