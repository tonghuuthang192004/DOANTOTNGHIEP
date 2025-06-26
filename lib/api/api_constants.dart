class API {
  static const String baseUrl = 'http://10.0.2.2:3000';

  // 🧑‍💻 User APIs
  static const String register = '$baseUrl/users/dang-ky';
  static const String verifyEmail = '$baseUrl/users/xac-minh-email';
  static const String login = '$baseUrl/users/dang-nhap';
  static const String updateProfile = '$baseUrl/users/cap-nhat-thong-tin';
  static const String changePassword = '$baseUrl/users/doi-mat-khau';
  static const String getProfile = '$baseUrl/users/profile';

  // 🛍️ Product APIs
  static const String getCategory = '$baseUrl/categories';
  static const String getProductByCategory = '$baseUrl/categories'; // /:id
  static const String getAllProducts = '$baseUrl/products';
  static const String searchProducts = '$baseUrl/products?search=';
  static const String getHotProducts = '$baseUrl/products/hot';
  static const String getProductById = '$baseUrl/products'; // /:id

  // 🛒 Cart APIs
  static const String cart = '$baseUrl/cart';
  static const String createCart = '$baseUrl/cart/create';
  static const String getCartItems = '$baseUrl/cart/items';
  static const String addToCart = '$baseUrl/cart/add';
  static const String updateCartItem = '$baseUrl/cart/item';
  static const String deleteCartItem = '$baseUrl/cart/item';
  static const String clearCart = '$baseUrl/cart/clear';

  // 📦 Order APIs
  static const String checkout = '$baseUrl/order/checkout';
  static const String myOrders = '$baseUrl/order/my';
  static String orderDetail(int id) => '$baseUrl/order/$id';
  static String cancelOrder(int id) => '$baseUrl/order/$id/cancel';
  static String reorder(int id) => '$baseUrl/order/$id/reorder';
  static const String rateProduct = '$baseUrl/order/rate';
  static const String submitReview = '$baseUrl/ratings';

  // 📮 Address APIs
  static String getAddresses(int userId) => '$baseUrl/address/$userId';
  static const String addAddress = '$baseUrl/address';
  static String updateAddress(int id) => '$baseUrl/address/$id';
  static String deleteAddress(int id) => '$baseUrl/address/$id';
  static String setDefaultAddress(int id) => '$baseUrl/address/default/$id';

  // 🔘 Mã giảm giá
  static const String getAllDiscounts = '$baseUrl/discount';
  static const String applyDiscount = '$baseUrl/discount/apply';
  static const String saveDiscount = '$baseUrl/discount/save';
  static const String getSavedDiscounts = '$baseUrl/discount/saved';
  static const String applySavedDiscount = '$baseUrl/discount/apply-saved';

  // ❤️ Favourite APIs
  static const String getFavourites = '$baseUrl/favourite';
  static const String addToFavourites = '$baseUrl/favourite';
  static String removeFavourite(int userId, int productId) =>
      '$baseUrl/favourite/$userId/$productId';
  static String clearFavourites(int userId) =>
      '$baseUrl/favourite/user/$userId';

  // 💰 Payment APIs ✅
  static const String momoPayment = '$baseUrl/payment/momo/create';
  static const String confirmCod = '$baseUrl/payment/cod';


}
