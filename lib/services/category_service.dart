import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/api_constants.dart.dart';
import '../models/home/category_model.dart';

class ApiService {
  static Future<List<CategoryModel>> getCategories() async {
    final response = await http.get(Uri.parse(API.getCategory));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => CategoryModel.fromJson(item)).toList();
    } else {
      throw Exception('Không thể tải danh mục');
    }
  }
}
