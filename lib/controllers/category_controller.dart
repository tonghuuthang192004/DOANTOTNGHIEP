import '../services/category_service.dart';
import '../models/home/category_model.dart';

class CategoryController {
  static Future<List<CategoryModel>> getCategories() async {
    return await ApiService.getCategories();
  }
}
