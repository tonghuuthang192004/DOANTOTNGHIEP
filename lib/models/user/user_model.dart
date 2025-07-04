class UserModel {
  final int? id; // ✅ nếu API có trả về ID người dùng
  final String ten;
  final String email;
  final String matKhau;
  final String soDienThoai;
  final String? gioiTinh;
  final String? ngaySinh;
  final String? avatar;

  UserModel({
    this.id,
    required this.ten,
    required this.email,
    required this.matKhau,
    required this.soDienThoai,
    this.gioiTinh,
    this.ngaySinh,
    this.avatar,
  });

  // ✅ Dùng khi lấy dữ liệu từ server
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      ten: json['ten'] ?? '',
      email: json['email'] ?? '',
      matKhau: json['mat_khau'] ?? '',
      soDienThoai: json['so_dien_thoai'] ?? '',
      gioiTinh: json['gioi_tinh'],
      ngaySinh: json['ngay_sinh'],
      avatar: json['avatar'],
    );
  }

  // ✅ Dùng khi gửi dữ liệu lên server
  Map<String, dynamic> toJson() {
    return {
      'ten': ten,
      'email': email,
      'mat_khau': matKhau,
      'so_dien_thoai': soDienThoai,
      if (gioiTinh != null) 'gioi_tinh': gioiTinh,
      if (ngaySinh != null) 'ngay_sinh': ngaySinh,
      if (avatar != null) 'avatar': avatar,
    };
  }
}
