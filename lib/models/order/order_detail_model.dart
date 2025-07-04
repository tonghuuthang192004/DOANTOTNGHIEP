class OrderItemModel {
  final int productId; // ✅ Thêm dòng này
  final String productName;
  final String imageUrl;
  final double price;
  final int quantity;
  final double total;

  OrderItemModel({
    required this.productId, // ✅
    required this.productName,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.total,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    final quantity = int.tryParse(json['quantity'].toString()) ?? 0;
    final price = double.tryParse(json['price'].toString()) ?? 0.0;

    final total = (json['total'] != null)
        ? double.tryParse(json['total'].toString()) ?? (price * quantity)
        : (price * quantity);

    return OrderItemModel(
      productId: json['productId'] ?? 0,
      productName: json['productName'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      quantity: quantity,
      price: price,
      total: total,
    );
  }
}
