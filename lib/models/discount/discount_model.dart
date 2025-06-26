class DiscountModel {
  final int id;
  final String ma;             // Mã giảm giá
  final String ten;            // Tên chương trình
  final String loai;           // 'money' hoặc 'percent'
  final int giaTri;            // Giá trị giảm
  final int dieuKien;          // Điều kiện áp dụng
  final DateTime batDau;       // Ngày bắt đầu
  final DateTime ketThuc;      // Ngày kết thúc
  final int soLuong;           // Tổng số lượng
  final int soLuongConLai;     // Số lượng còn lại

  DiscountModel({
    required this.id,
    required this.ma,
    required this.ten,
    required this.loai,
    required this.giaTri,
    required this.dieuKien,
    required this.batDau,
    required this.ketThuc,
    required this.soLuong,
    required this.soLuongConLai,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      id: json['id_giam_gia'],
      ma: json['ma_giam_gia'],
      ten: json['ten'],
      loai: json['loai'],
      giaTri: json['gia_tri'],
      dieuKien: int.tryParse(json['dieu_kien'].toString()) ?? 0,
      batDau: DateTime.parse(json['ngay_bat_dau']),
      ketThuc: DateTime.parse(json['ngay_ket_thuc']),
      soLuong: json['so_luong'],
      soLuongConLai: json['so_luong_con_lai'],
    );
  }
}
