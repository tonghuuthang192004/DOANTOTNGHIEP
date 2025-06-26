import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../api/api_constants.dart';
import '../../models/category/category_model.dart';

class ApiService {
  static Future<List<CategoryModel>> getCategories() async {
    final response = await http.get(Uri.parse(API.getCategory));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> jsonData = jsonResponse['data']; // ✅ Lấy từ key 'data'

      return jsonData.map((item) => CategoryModel.fromJson(item)).toList();
    } else {
      throw Exception('Không thể tải danh mục');
    }
  }

}
