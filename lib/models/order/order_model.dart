class OrderModel {
  final int id;
  final int? userId;
  final int? addressId;
  final String paymentMethod;
  final String status;
  final String paymentStatus;
  final double totalPrice;
  final String? note;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    this.userId,
    this.addressId,
    required this.paymentMethod,
    required this.status,
    required this.paymentStatus,
    required this.totalPrice,
    this.note,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    print("📦 JSON trả về: $json");
    print("👉 tong_gia: ${json['tong_gia']} (${json['tong_gia']?.runtimeType})");
    return OrderModel(
      id: json['id_don_hang'] is int
          ? json['id_don_hang']
          : int.tryParse(json['id_don_hang']?.toString() ?? '') ?? 0,
      userId: json['id_nguoi_dung'] is int
          ? json['id_nguoi_dung']
          : int.tryParse(json['id_nguoi_dung']?.toString() ?? '') ?? 0,
      addressId: json['id_dia_chi'] is int
          ? json['id_dia_chi']
          : int.tryParse(json['id_dia_chi']?.toString() ?? '') ?? 0,
      paymentMethod: json['phuong_thuc_thanh_toan']?.toString() ?? '',
      status: json['trang_thai']?.toString() ?? '',
      paymentStatus: json['trang_thai_thanh_toan']?.toString() ?? '',
      totalPrice: json['tong_gia'] is num
          ? (json['tong_gia'] as num).toDouble()
          : double.tryParse(json['tong_gia']?.toString() ?? '') ?? 0.0,
      note: json['ghi_chu']?.toString(),
      createdAt: DateTime.tryParse(json['ngay_tao']?.toString() ?? '') ??
          DateTime.now(),
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
          (match) => '${match[1]}.',
    );
  }

  String get orderCode => '#DH$id';
}
