class RegisterRequest {
  final String ten;
  final String email;
  final String password;
  final String soDienThoai;

  RegisterRequest({
    required this.ten,
    required this.email,
    required this.password,
    required this.soDienThoai,
  });

  Map<String, dynamic> toJson() => {
    'ten': ten,
    'email': email,
    'mat_khau': password,
    'so_dien_thoai': soDienThoai,
  };
}
