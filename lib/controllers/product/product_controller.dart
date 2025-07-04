import '../../models/product/product_model.dart';
import '../../services/product/product_service.dart';

class ProductController {
  // Lấy sản phẩm theo danh mục
  static Future<List<ProductModel>> getByCategory(int categoryId) async {
    try {
      return await ProductService.getProductsByCategory(categoryId);
    } catch (e) {
      print('Lỗi trong ProductController.getByCategory: $e');
      return [];
    }
  }

  // Lấy tất cả sản phẩm (phục vụ tìm kiếm hoặc hiển thị toàn bộ)
  static Future<List<ProductModel>> getAll() async {
    try {
      return await ProductService.getAllProducts();
    } catch (e) {
      print('Lỗi trong ProductController.getAll: $e');
      return [];
    }
  }

  //  Tìm kiếm sản phẩm theo từ khóa
  static Future<List<ProductModel>> searchProducts(String keyword) async {
    try {
      return await ProductService.searchProducts(keyword);
    } catch (e) {
      print('Lỗi trong ProductController.search: $e');
      return [];
    }
  }

  // Lấy sản phẩm hot
  static Future<List<ProductModel>> getHotProducts() async {
    try {
      return await ProductService.getHotProducts();
    } catch (e) {
      print('Lỗi trong ProductController.getHotProducts: $e');
      return [];
    }
  }

  // ✅ Lấy chi tiết sản phẩm theo ID
  static Future<ProductModel?> getProductById(int id) async {
    try {
      return await ProductService.getProductById(id);
    } catch (e) {
      print('Lỗi trong ProductController.getProductById: $e');
      return null;
    }
  }
}
