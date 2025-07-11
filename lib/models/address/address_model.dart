class AddressModel {
  final int id;
  final int userId;
  final String name;
  final String phone;
  final String address;
  final bool isDefault;
  final String? city;
  final String? district;
  final String? ward;

  AddressModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    required this.address,
    required this.isDefault,
    required this.city,
    required this.district,
    required this.ward,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    // Assuming `dia_chi_day_du` contains the full address in the format:
    // "address, ward, district, city"
    String fullAddress = json['dia_chi_day_du'] ?? '';
    List<String> addressParts = fullAddress.split(',').map((part) => part.trim()).toList();

    return AddressModel(
      id: json['id'] ?? 0,
      userId: json['id_nguoi_dung'] ?? 0,
      name: json['ten_nguoi_dung'] ?? '',
      phone: json['so_dien_thoai'] ?? '',
      address: addressParts.isNotEmpty ? addressParts[0] : '', // The actual address (excluding ward, district, and city)
      isDefault: (json['mac_dinh'] ?? 0) == 1,
      city: addressParts.length > 3 ? addressParts[3] : null, // City is the last part
      district: addressParts.length > 2 ? addressParts[2] : null, // District is the second-to-last part
      ward: addressParts.length > 1 ? addressParts[1] : null, // Ward is the second part
    );
  }

  Map<String, dynamic> toJson() {
    // Combine city, district, and ward into the full address
    String fullAddress = '$address, ${ward ?? ''}, ${district ?? ''}, ${city ?? ''}';
    return {
      'ten_nguoi_dung': name.trim(),
      'so_dien_thoai': phone.trim(),
      'dia_chi_day_du': fullAddress, // Full address for storage
      'mac_dinh': isDefault ? 1 : 0,
      'thanh_pho': city ?? '',  // Store the name of the city
      'quan_huyen': district ?? '',  // Store the name of the district
      'phuong_xa': ward ?? '',  // Store the name of the ward
    };
  }

}



class District {
  final int id;
  final String name;

  District({required this.id, required this.name});

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['code'],
      name: json['name'],
    );
  }
}

class City {
  final int id;
  final String name;

  City({required this.id, required this.name});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['code'],
      name: json['name'],
    );
  }
}
class Ward {
  final int id;
  final String name;

  Ward({required this.id, required this.name});

  factory Ward.fromJson(Map<String, dynamic> json) {
    return Ward(
      id: json['code'],
      name: json['name'],
    );
  }
}
