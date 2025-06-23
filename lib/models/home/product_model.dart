class ProductModel {
  final int id;
  final String ten; // giữ đúng tên gốc từ API
  final String moTa;
  final double gia;
  final String hinhAnh;
  final double danhGia;
  final int? danhMucId;

  ProductModel({
    required this.id,
    required this.ten,
    required this.moTa,
    required this.gia,
    required this.hinhAnh,
    required this.danhGia,
    required this.danhMucId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      ten: json['ten'] ?? json['ten_san_pham'] ?? 'Chưa có tên',
      moTa: json['mo_ta'] ?? '',
      gia: (json['gia'] is int)
          ? (json['gia'] as int).toDouble()
          : double.tryParse(json['gia'].toString()) ?? 0.0,
      hinhAnh: json['hinh_anh'] ?? '',
      danhGia: double.tryParse(json['danh_gia']?.toString() ?? '4.5') ?? 4.5,
      danhMucId: json['danh_muc_id'] ?? json['category_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ten': ten,
      'mo_ta': moTa,
      'gia': gia,
      'hinh_anh': hinhAnh,
      'danh_gia': danhGia,
      'danh_muc_id': danhMucId,
    };
  }
}
