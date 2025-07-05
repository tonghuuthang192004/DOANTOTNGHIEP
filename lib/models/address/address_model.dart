class AddressModel {
  final int id;
  final int userId;
  final String name;
  final String phone;
  final String address;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    required this.address,
    required this.isDefault,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as int? ?? 0,
      userId: json['id_nguoi_dung'] as int? ?? 0,
      name: json['ten_nguoi_dung'] as String? ?? '', // ✅ sửa tên field
      phone: json['so_dien_thoai'] as String? ?? '',
      address: json['dia_chi_day_du'] as String? ?? '',
      isDefault: (json['mac_dinh'] ?? 0) == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ten_nguoi_dung': name.trim(), // ✅ sửa tên field
      'so_dien_thoai': phone.trim(),
      'dia_chi_day_du': address.trim(),
      'mac_dinh': isDefault ? 1 : 0,
    };
  }
}
