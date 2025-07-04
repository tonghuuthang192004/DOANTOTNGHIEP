class OrderModel {
  final int id;
  final int userId;
  final int addressId;
  final String paymentMethod;
  final String status;
  final String paymentStatus;
  final double totalPrice;
  final String? note;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.addressId,
    required this.paymentMethod,
    required this.status,
    required this.paymentStatus,
    required this.totalPrice,
    this.note,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    print("📦 JSON trả về: $json");
    print("👉 tong_gia: ${json['tong_gia']} (${json['tong_gia'].runtimeType})");
    return OrderModel(
      id: json['id_don_hang'],
      userId: json['id_nguoi_dung'],
      addressId: json['id_dia_chi'],
      paymentMethod: json['phuong_thuc_thanh_toan'] ?? '',
      status: json['trang_thai'] ?? '',
      paymentStatus: json['trang_thai_thanh_toan'] ?? '',
      totalPrice: double.tryParse(json['tong_gia'].toString()) ?? 0.0, // 🟢 chỗ này
      note: json['ghi_chu'],
      createdAt: DateTime.parse(json['ngay_tao']),
    );
  }


  String get formattedDate {
    return '${createdAt.day.toString().padLeft(2, '0')}/'
        '${createdAt.month.toString().padLeft(2, '0')}/'
        '${createdAt.year}';
  }

  String get formattedPrice {
    return totalPrice.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
    );
  }

  String get orderCode => '#DH$id';
}