class API {
  static const String baseUrl = 'http://10.0.2.2:3000';

  // 🧑‍💻 User APIs
  static const String register        = '$baseUrl/user/dang-ky';
  static const String verifyEmail     = '$baseUrl/user/xac-minh-email';
  static const String login           = '$baseUrl/user/dang-nhap';
  static const String updateProfile   = '$baseUrl/user/cap-nhat';
  static const String changePassword  = '$baseUrl/user/doi-mat-khau';
  static const String getProfile      = '$baseUrl/user/me';
  static const String forgotPassword  = '$baseUrl/user/quen-mat-khau';
  static const String resetPassword   = '$baseUrl/user/reset-mat-khau';
  static const String verifyOtp = '$baseUrl/user/xac-minh-otp';
  static const String updateAvatar = '$baseUrl/user/upload-avatar';

  // // 🛍️ Product APIs
  // static const String getCategory = '$baseUrl/categories';
  // static const String getProductByCategory = '$baseUrl/categories'; // /:id
  // static const String getAllProducts = '$baseUrl/products';
  // static const String searchProducts = '$baseUrl/products?search=';
  // static const String getHotProducts = '$baseUrl/products/hot';
  // static const String getProductById = '$baseUrl/products'; // /:id

  // 🛍️ Category APIs
  static const String getAllCategories = '$baseUrl/category';
  static String getProductsByCategory(int id) => '$baseUrl/category/$id/products';

  // 🛍️ Product APIs
  static const String getAllProducts = '$baseUrl/products';
  static String searchProducts(String keyword) =>
      '$baseUrl/products/search?keyword=$keyword';

  static const String getHotProducts = '$baseUrl/products/hot';
  static String getProductById(int id) => '$baseUrl/products/$id';
  static String getRelatedProducts(int categoryId, int productId) => '$baseUrl/products/category/$categoryId/related/$productId';



  // 🛒 Cart APIs
  static const String cart = '$baseUrl/cart'; // GET: Lấy giỏ hàng
  static const String addToCart = '$baseUrl/cart/item'; // POST: Thêm sản phẩm
  static String updateCartItem(String idSanPham) =>
      '$baseUrl/cart/item/$idSanPham'; // PUT: Cập nhật số lượng
  static String deleteCartItem(String idSanPham) =>
      '$baseUrl/cart/item/$idSanPham'; // DELETE: Xoá sản phẩm
  static const String clearCart = '$baseUrl/cart/clear'; // DELETE: Xoá toàn bộ giỏ
  static String restoreCartItem(String idSanPham) =>
      '$baseUrl/cart/item/$idSanPham/restore'; // PATCH: Khôi phục sản phẩm



  // 📦 Order APIs
  static const String checkout = '$baseUrl/order/create';
  static const String myOrders = '$baseUrl/order';
  static const String orderHistory = '$baseUrl/order/lich-su';
  static String orderDetail(int id) => '$baseUrl/order/$id';
  static String cancelOrder(int id) => '$baseUrl/order/$id/cancel';
  static String reorder(int id) => '$baseUrl/order/$id/reorder';

// ⭐ Đánh giá sản phẩm - sửa thành đúng đường dẫn backend
  static String rateProduct(int productId) => '$baseUrl/order/$productId/review';
// 📥 Lấy danh sách đánh giá của 1 sản phẩm
  static String reviewProduct(int productId) => '$baseUrl/order/products/$productId/reviews';


  /// 📮 Address APIs (khớp backend lấy userId từ token)
  static const String getAddresses = '$baseUrl/address';              // GET /address
  static const String addAddress = '$baseUrl/address';                // POST /address
  static String updateAddress(int id) => '$baseUrl/address/$id';      // PUT /address/:id
  static String deleteAddress(int id) => '$baseUrl/address/$id';      // DELETE /address/:id
  static String setDefaultAddress(int id) =>                          // PATCH /address/default/:id
  '$baseUrl/address/default/$id';





  // 🔘 Mã giảm giá
  static const String getAllDiscounts    = '$baseUrl/voucher';              // GET /voucher
  static const String saveDiscount       = '$baseUrl/voucher/save';         // POST /voucher/save
  static const String getSavedDiscounts  = '$baseUrl/voucher/saved';        // GET /voucher/saved/:userId
  static const String applyDiscount      = '$baseUrl/voucher/use';          // POST /voucher/use


  // ❤️ Favourite APIs
  static const String getFavourites = '$baseUrl/favorite';
  static const String addToFavourites = '$baseUrl/favorite';
  static String removeFavourite(int userId, int productId) =>
      '$baseUrl/favorite/$userId/$productId';
  static String clearFavourites(int userId) =>
      '$baseUrl/favorite/user/$userId';
  static String isFavorite(int productId, int userId) =>
      '$baseUrl/favorite/is-favorite/$productId/$userId';

  // 💰 Payment APIs
  static const String momoPayment = '$baseUrl/admin/order/createOrder';
  static const String confirmCod = '$baseUrl/payment/confirm-cod';

}
