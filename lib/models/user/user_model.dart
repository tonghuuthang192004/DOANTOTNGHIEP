class UserModel {
  final int? id; // ID người dùng
  final String ten;
  final String email;
  final String matKhau;
  final String soDienThoai;
  final String? avatar;

  UserModel({
    this.id,
    required this.ten,
    required this.email,
    required this.matKhau,
    required this.soDienThoai,
    this.avatar,
  });

  /// ✅ Parse từ JSON khi lấy từ API
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id_nguoi_dung'] ?? json['id'],
      ten: json['ten'] ?? '',
      email: json['email'] ?? '',
      matKhau: json['mat_khau'] ?? '',
      soDienThoai: json['so_dien_thoai'] ?? '',
      avatar: json['avatar'],
    );
  }

  /// ✅ Convert sang JSON khi gửi lên API
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id_nguoi_dung': id,
      'ten': ten,
      'email': email,
      'mat_khau': matKhau,
      'so_dien_thoai': soDienThoai,
      if (avatar != null) 'avatar': avatar,
    };
  }
}
