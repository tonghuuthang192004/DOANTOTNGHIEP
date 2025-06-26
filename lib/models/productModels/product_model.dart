
class ProductModel {
  final int id;
  final String ten;
  final String hinhAnh;
  final double gia;
  final double danhGia;

  ProductModel({
    required this.id,
    required this.ten,
    required this.hinhAnh,
    required this.gia,
    required this.danhGia,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      ten: json['ten'] ?? '',
      hinhAnh: json['hinh_anh'] ?? '', // Mapping the database field
      gia: json['gia'] != null ? (json['gia'] as num).toDouble() : 0.0,
      danhGia: json['danhGia'] != null ? (json['danhGia'] as num).toDouble() : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ten': ten,
      'hinh_anh': hinhAnh,
      'gia': gia,
      'danhGia': danhGia,
    };
  }
}