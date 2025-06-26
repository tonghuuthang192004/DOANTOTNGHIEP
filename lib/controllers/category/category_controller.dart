import '../../services/category/category_service.dart';
import '../../models/category/category_model.dart';

class CategoryController {
  static Future<List<CategoryModel>> getCategories() async {
    return await ApiService.getCategories();
  }
}
