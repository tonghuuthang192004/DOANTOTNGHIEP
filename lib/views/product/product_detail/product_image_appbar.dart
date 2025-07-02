import 'package:flutter/material.dart';
import '../../../services/favourite/favorite_service.dart';
import '../../favourite/favorite_page.dart';
import '../../../utils/dimensions.dart';

class ProductImageAppBar extends StatelessWidget {
  final Map<String, dynamic>? product;
  final int cartItemCount; // 👈 thêm biến để hiển thị số lượng giỏ hàng

  const ProductImageAppBar({
    Key? key,
    required this.product,
    this.cartItemCount = 0, // mặc định = 0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: Dimensions.screenHeight * 0.4,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(height: Dimensions.height50),
                  Center(
                    child: Container(
                      width: Dimensions.screenWidth * 0.6,
                      height: Dimensions.screenWidth * 0.6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 12,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          product?['hinh_anh'] ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.fastfood, size: 60, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Nút Back + Giỏ hàng + Yêu thích
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width15,
                  vertical: Dimensions.height10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Nút quay lại
                    // _buildIconButton(context, Icons.arrow_back, () {
                    //   Navigator.pop(context);
                    // }),

                    Row(
                      children: [
                        // Nút giỏ hàng có badge
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            _buildIconButton(context, Icons.shopping_cart, () {
                              // TODO: Điều hướng tới giỏ hàng
                            }),
                            Positioned(
                              right: 6,
                              top: 6,
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '3', // 👈 thay bằng số thực tế
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Dimensions.font12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: Dimensions.width10),
                        // Nút yêu thích
                        _buildIconButton(context, Icons.favorite_border, () async {
                          final productId = product?['id_san_pham'];
                          if (productId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Không tìm thấy sản phẩm')),
                            );
                            return;
                          }

                          try {
                            final userId = await FavoriteService.getCurrentUserId();
                            if (userId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Bạn cần đăng nhập để sử dụng')),
                              );
                              return;
                            }

                            final favorites = await FavoriteService.getFavorites(userId);
                            final exists = favorites.any((p) => p.id == productId);

                            if (exists) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('💡 Sản phẩm đã có trong yêu thích')),
                              );
                            } else {
                              final success = await FavoriteService.addFavorite(productId);
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('❤️ Đã thêm vào yêu thích')),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('❌ Thêm yêu thích thất bại')),
                                );
                              }
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Lỗi: $e')),
                            );
                          }
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  // Nút icon bình thường
  Widget _buildIconButton(BuildContext context, IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black87),
        onPressed: onPressed,
      ),
    );
  }


  // Nút giỏ hàng có badge
  Widget _buildCartWithBadge(BuildContext context) {
    return Stack(
      children: [
        _buildIconButton(context, Icons.shopping_cart_outlined, () {
          // TODO: mở giỏ hàng (sau này)
        }),
        if (cartItemCount > 0)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                cartItemCount.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
