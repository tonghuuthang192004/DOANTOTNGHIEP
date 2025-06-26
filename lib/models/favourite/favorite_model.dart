class FavoriteProduct {
  final int idSanPham;
  final int idDanhMuc;
  final String ten;
  final int gia;
  final String moTa;
  final String trangThai;
  final String ngayCapNhat;
  final String ngayTao;
  final String hinhAnh;
  final int deleted;
  final int noiBat;

  FavoriteProduct({
    required this.idSanPham,
    required this.idDanhMuc,
    required this.ten,
    required this.gia,
    required this.moTa,
    required this.trangThai,
    required this.ngayCapNhat,
    required this.ngayTao,
    required this.hinhAnh,
    required this.deleted,
    required this.noiBat,
  });

  factory FavoriteProduct.fromJson(Map<String, dynamic> json) {
    return FavoriteProduct(
      idSanPham: json['id_san_pham'],
      idDanhMuc: json['id_danh_muc'],
      ten: json['ten'],
      gia: json['gia'],
      moTa: json['mo_ta'],
      trangThai: json['trang_thai'],
      ngayCapNhat: json['ngay_cap_nhat'],
      ngayTao: json['ngay_tao'],
      hinhAnh: json['hinh_anh'],
      deleted: json['deleted'],
      noiBat: json['noi_bat'],
    );
  }
}