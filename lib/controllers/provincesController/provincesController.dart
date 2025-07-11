import 'package:flutter/material.dart';

import '../../models/address/address_model.dart';
import '../../services/ProvincesService/ProvincesService.dart';
class ProvincesController with ChangeNotifier {
  List<City> _cities = [];
  List<District> _districts = [];
  List<Ward> _wards = [];

  List<City> get cities => _cities;
  List<District> get districts => _districts;
  List<Ward> get wards => _wards;

  // Tải danh sách thành phố
  Future<void> loadCities() async {
    try {
      // Lấy dữ liệu các thành phố từ API
      var cities = await ProvincesService.fetchCities();

      // Loại bỏ trùng lặp dựa trên `id` (hoặc `name`, tùy vào yêu cầu)
      _cities = _removeDuplicates(cities);

      // Thông báo cho các Listener để UI cập nhật
      notifyListeners();
    } catch (e) {
      throw Exception('Lỗi khi tải danh sách thành phố: $e');
    }
  }

// Hàm loại bỏ trùng lặp
  List<City> _removeDuplicates(List<City> cities) {
    // Sử dụng Set để loại bỏ các đối tượng trùng lặp dựa trên id
    var uniqueCities = <City>[];
    var seenIds = Set<int>();  // Set để theo dõi id đã xuất hiện

    for (var city in cities) {
      if (!seenIds.contains(city.id)) {
        uniqueCities.add(city);
        seenIds.add(city.id);
      }
    }

    return uniqueCities;
  }


  // Tải danh sách quận/huyện theo mã thành phố
  Future<void> loadDistricts(String cityCode) async {
    try {
      _districts = await ProvincesService.fetchDistricts(cityCode);
      notifyListeners();
    } catch (e) {
      throw Exception('Lỗi khi tải danh sách quận huyện');
    }
  }

  // Tải danh sách phường/xã theo mã quận huyện
  Future<void> loadWards(String districtCode) async {
    try {
      _wards = await ProvincesService.fetchWards(districtCode);
      notifyListeners();
    } catch (e) {
      throw Exception('Lỗi khi tải danh sách phường xã');
    }
  }
}
