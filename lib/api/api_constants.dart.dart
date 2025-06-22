class API {
  static const String baseUrl = 'http://localhost:3002/api';

  static const String getCategory = '$baseUrl/categories';
  static const String getProductByCategory = '$baseUrl/product/category';
  static const String getAllProducts = '$baseUrl/product'; // ✅ Đã sửa
  static const String searchProducts = '$baseUrl/product/search';
  static const String getHotProducts = '$baseUrl/product/hot';
  static const String getProductById = '$baseUrl/product/productId';
}
