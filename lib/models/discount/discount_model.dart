class DiscountModel {
  final int id;
  final String ma;             // Mã giảm giá
  final String ten;            // Tên chương trình
  final String loai;           // 'tien_mat' hoặc 'phan_tram'
  final double giaTri;         // Giá trị giảm
  final DateTime batDau;       // Ngày bắt đầu
  final DateTime ketThuc;      // Ngày kết thúc
  final int soLuongConLai;     // Số lượng còn lại

  DiscountModel({
    required this.id,
    required this.ma,
    required this.ten,
    required this.loai,
    required this.giaTri,
    required this.batDau,
    required this.ketThuc,
    required this.soLuongConLai,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      id: json['id_giam_gia'],
      ma: json['ma_giam_gia'],
      ten: json['ten'],
      loai: json['loai'],
      giaTri: double.tryParse(json['gia_tri'].toString()) ?? 0,
      batDau: DateTime.parse(json['ngay_bat_dau']),
      ketThuc: DateTime.parse(json['ngay_ket_thuc']),
      soLuongConLai: json['so_luong_con_lai'] ?? 0,
    );
  }
}
