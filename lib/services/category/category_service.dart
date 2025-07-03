import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../api/api_constants.dart';
import '../../models/category/category_model.dart';

class CategoryService {
  static Future<List<CategoryModel>> getCategories() async {
    final uri = Uri.parse(API.getAllCategories);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
        final List<dynamic> jsonData = jsonResponse['data'];
        return jsonData.map((item) => CategoryModel.fromJson(item)).toList();
      } else {
        throw Exception('Dữ liệu danh mục không hợp lệ');
      }
    } else {
      throw Exception('Không thể tải danh mục (Mã lỗi: ${response.statusCode})');
    }
  }


}
