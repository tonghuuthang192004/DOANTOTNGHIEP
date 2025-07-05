import '../../models/product/product_model.dart';
import '../../services/favourite/favorite_service.dart';

class FavoriteController {
  List<ProductModel> favoriteProducts = [];

  /// 📥 Load danh sách sản phẩm yêu thích từ backend
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
    final userId = await FavoriteService.getCurrentUserId();
    if (userId == null) {
      print('❌ User chưa đăng nhập');
      return false;
    }

    final success = await FavoriteService.addFavorite(userId, productId);
    if (success) {
      await loadFavorites();
    }
    return success;
  }

  /// ❌ Xoá một sản phẩm khỏi yêu thích
  Future<bool> removeFromFavorites(int productId) async {
    final userId = await FavoriteService.getCurrentUserId();
    if (userId == null) {
      print('❌ User chưa đăng nhập');
      return false;
    }

    final success = await FavoriteService.removeFavorite(productId, userId);
    if (success) {
      await loadFavorites();
    }
    return success;
  }
}
