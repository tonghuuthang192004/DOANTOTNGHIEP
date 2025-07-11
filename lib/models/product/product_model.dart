class ProductModel {
  final int id;
  final String ten; // giữ đúng tên gốc từ API
  final String moTa;
  final double gia;
  final String hinhAnh;
  final double danhGia;
  final int? danhMucId;
  final int soLuongkho;

  ProductModel({
    required this.id,
    required this.ten,
    required this.moTa,
    required this.gia,
    required this.hinhAnh,
    required this.danhGia,
    required this.danhMucId,
    required this.soLuongkho, // Thêm trường này vào constructor

  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    print('Parsing product data: $json');  // In toàn bộ dữ liệu JSON

    return ProductModel(
      id: json['id'] ?? json['id_san_pham'] ?? 0,
      ten: json['ten'] ?? json['ten_san_pham'] ?? 'Không có tên',
      moTa: json['mo_ta'] ?? '',
      gia: (json['gia'] is int)
          ? (json['gia'] as int).toDouble()
          : double.tryParse(json['gia']?.toString() ?? '0') ?? 0.0,
      hinhAnh: json['hinh_anh'] ?? '',
      danhGia: json['danh_gia'] != null
          ? double.tryParse(json['danh_gia'].toString()) ?? 0.0
          : 0.0,
      danhMucId: json['danh_muc_id'] ?? json['id_danh_muc'],
      soLuongkho: json['so_luong_kho'] ?? 0, // Thêm dòng này để parse số lượng tồn kho

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
      'so_luong_ton': soLuongkho, // Thêm dòng này để đưa số lượng tồn kho vào JSON
    };
  }
}
