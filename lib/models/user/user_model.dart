
class UserModel {
  final String ten;
  final String email;
  final String matKhau;
  final String soDienThoai;

  UserModel({
    required this.ten,
    required this.email,
    required this.matKhau,
    required this.soDienThoai,
  });

  // Tạo từ JSON (nếu cần fetch từ API)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      ten: json['ten'] ?? '',
      email: json['email'] ?? '',
      matKhau: json['mat_khau'] ?? '',
      soDienThoai: json['so_dien_thoai'] ?? '',
    );
  }

  // Chuyển thành JSON để gửi đi
  Map<String, dynamic> toJson() {
    return {
      'ten': ten,
      'email': email,
      'mat_khau': matKhau,
      'so_dien_thoai': soDienThoai,
    };
  }
}

