class API {
  static const String baseUrl = 'http://10.0.2.2:3000';

  // 🧑‍💻 User APIs
  static const String register = '$baseUrl/users/dang-ky';
  static const String verifyEmail = '$baseUrl/users/xac-minh-email';
  static const String login = '$baseUrl/users/dang-nhap';
  static const String updateProfile = '$baseUrl/users/cap-nhat-thong-tin';
  static const String changePassword = '$baseUrl/users/doi-mat-khau';
  static const String userInfo = '$baseUrl/users/thong-tin';

  // 🛍️ Product APIs
  static const String getCategory = '$baseUrl/categories';
  static const String getProductByCategory = '$baseUrl/categories'; // /:id
  static const String getAllProducts = '$baseUrl/products';
  static const String searchProducts = '$baseUrl/products?search=';
  static const String getHotProducts = '$baseUrl/products/hot';
  static const String getProductById = '$baseUrl/products'; // /:id

  // 🛒 Cart APIs (Đã xác thực)
  static const String cart = '$baseUrl/cart'; // GET / -> lấy thông tin giỏ hàng
  static const String createCart = '$baseUrl/cart/create'; // POST -> tạo mới nếu chưa có
  static const String getCartItems = '$baseUrl/cart/items'; // GET -> danh sách sản phẩm
  static const String addToCart = '$baseUrl/cart/add'; // POST
  static const String updateCartItem = '$baseUrl/cart/item'; // PUT
  static const String deleteCartItem = '$baseUrl/cart/item'; // DELETE
  static const String clearCart = '$baseUrl/cart/clear'; // DELETE -> xoá toàn bộ giỏ
}
