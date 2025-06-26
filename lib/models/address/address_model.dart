class AddressModel {
  final int id;
  final int userId;
  final String name;
  final String phone;
  final String address;
  bool isDefault;

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
      id: json['id'] ?? 0,
      userId: json['id_nguoi_dung'] ?? 0,
      name: json['ten_nguoi_nhan'] ?? '',
      phone: json['so_dien_thoai'] ?? '',
      address: json['dia_chi_day_du'] ?? '',
      isDefault: json['mac_dinh'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_nguoi_dung': userId,
      'ten_nguoi_nhan': name,
      'so_dien_thoai': phone,
      'dia_chi_day_du': address,
      'mac_dinh': isDefault ? 1 : 0,
    };
  }
}
