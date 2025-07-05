import 'package:flutter/material.dart';
import '../../models/product/product_model.dart';
import '../../services/favourite/favorite_service.dart';
import '../../services/user/user_session.dart';
import '../../services/cart/cart_service.dart';
import '../cart/cart_page.dart';
import 'favorite_list_item.dart';
import 'favorite_empty_state.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<ProductModel> favoriteProducts = [];
  int? userId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final id = await UserSession.getUserId();
    print("🧑 [FavoritePage] User ID từ session: $id");
    if (id == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    userId = id;

    try {
      final data = await FavoriteService.getFavorites(userId!);
      setState(() {
        favoriteProducts = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        favoriteProducts = [];
        isLoading = false;
      });
      debugPrint('❌ Lỗi khi tải danh sách yêu thích: $e');
    }
  }

  Future<void> _removeFromFavorites(int productId) async {
    if (userId == null) return;
    final success = await FavoriteService.removeFavorite(productId, userId!); // Sửa thứ tự tham số
    if (success) {
      setState(() {
        favoriteProducts.removeWhere((p) => p.id == productId);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Xoá sản phẩm yêu thích thất bại')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Yêu thích'),
        centerTitle: true,
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favoriteProducts.isEmpty
          ? const FavoriteEmptyState()
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: favoriteProducts.length,
        itemBuilder: (context, index) {
          final product = favoriteProducts[index];
          return FavoriteListItem(
            product: product,
            index: index,
            onRemove: () => _removeFromFavorites(product.id!),
            onAddToCart: () async {
              try {
                await CartService.addToCart(product);
                if (!context.mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CartPage(),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('❌ Lỗi thêm vào giỏ hàng: $e')),
                );
              }
            },
          );
        },
      ),
    );
  }
}
