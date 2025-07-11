import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/address/address_model.dart';

class ProvincesService {
  static const String baseUrl = 'https://provinces.open-api.vn/api/';

  // Lấy danh sách thành phố
  static Future<List<City>> fetchCities() async {
    final response = await http.get(Uri.parse(baseUrl + '?depth=1'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => City.fromJson(json)).toList();
    } else {
      throw Exception('Lỗi khi tải danh sách thành phố');
    }
  }

  // Lấy danh sách quận/huyện theo mã thành phố
  static Future<List<District>> fetchDistricts(String cityCode) async {
    final response = await http.get(Uri.parse(baseUrl + 'p/$cityCode?depth=2'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> districtsData = data['districts'];
      return districtsData.map((json) => District.fromJson(json)).toList();
    } else {
      throw Exception('Lỗi khi tải danh sách quận huyện');
    }
  }

  // Lấy danh sách phường/xã theo mã quận huyện
  static Future<List<Ward>> fetchWards(String districtCode) async {
    final response = await http.get(Uri.parse(baseUrl + 'd/$districtCode?depth=2'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> wardsData = data['wards'];
      return wardsData.map((json) => Ward.fromJson(json)).toList();
    } else {
      throw Exception('Lỗi khi tải danh sách phường xã');
    }
  }
}
