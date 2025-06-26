import '../../models/product/product_model.dart';
import '../../services/favourite/favorite_service.dart';

class FavoriteController {
  List<ProductModel> favoriteProducts = [];

  /// 📥 Load danh sách sản phẩm yêu thích từ SharedPreferences
  Future<List<ProductModel>> loadFavorites() async {
    try {
      final userId = await FavoriteService.getCurrentUserId();
      if (userId != null) {
        favoriteProducts = await FavoriteService.getFavorites(userId);
      } else {
        favoriteProducts = [];
        print("⚠️ Không thể tải yêu thích vì userId bị null");
      }
    } catch (e) {
      favoriteProducts = [];
      print('❌ Lỗi khi tải danh sách yêu thích: $e');
    }

    return favoriteProducts;
  }

  /// ➕ Thêm sản phẩm vào yêu thích
  Future<bool> addToFavorites(int productId) async {
    final success = await FavoriteService.addFavorite(productId);
    if (success) {
      await loadFavorites(); // tự động gọi lại theo user hiện tại
    }
    return success;
  }

  /// ❌ Xoá một sản phẩm khỏi yêu thích
  Future<bool> removeFromFavorites(int productId) async {
    final userId = await FavoriteService.getCurrentUserId();
    if (userId == null) return false;

    final success = await FavoriteService.removeFavorite(userId, productId);
    if (success) {
      await loadFavorites();
    }
    return success;
  }

  /// 🧹 Xoá toàn bộ yêu thích
  Future<bool> clearAllFavorites() async {
    final success = await FavoriteService.clearFavorites();
    if (success) {
      await loadFavorites();
    }
    return success;
  }
}
