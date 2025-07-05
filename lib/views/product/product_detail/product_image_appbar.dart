import 'package:flutter/material.dart';
import '../../../services/favourite/favorite_service.dart';
import '../../../utils/dimensions.dart';

class ProductImageAppBar extends StatefulWidget {
  final Map<String, dynamic>? product;
  final int cartItemCount;

  const ProductImageAppBar({
    Key? key,
    required this.product,
    this.cartItemCount = 0,
  }) : super(key: key);

  @override
  State<ProductImageAppBar> createState() => _ProductImageAppBarState();
}

class _ProductImageAppBarState extends State<ProductImageAppBar> {
  bool isFavorite = false;
  bool isLoading = false; // chống spam click

  @override
  void initState() {
    super.initState();
    _fetchFavoriteStatus();
  }

  Future<void> _fetchFavoriteStatus() async {
    final productId = widget.product?['id_san_pham'];
    if (productId == null) return;

    try {
      final userId = await FavoriteService.getCurrentUserId();
      if (userId != null) {
        final status = await FavoriteService.isFavorite(productId, userId);
        if (!mounted) return;
        setState(() {
          isFavorite = status == true;
        });
      }
    } catch (e) {
      debugPrint('❌ Lỗi load trạng thái yêu thích: $e');
    }
  }

  Future<void> _toggleFavorite() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    final productId = widget.product?['id_san_pham'];
    if (productId == null) {
      _showSnackBar('Không tìm thấy sản phẩm');
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      bool success = false;
      final userId = await FavoriteService.getCurrentUserId();
      if (userId == null) {
        _showSnackBar('Bạn cần đăng nhập để sử dụng');
        setState(() {
          isLoading = false;
        });
        return;
      }

      if (isFavorite) {
        success = await FavoriteService.removeFavorite(productId, userId);
        if (success) {
          _showSnackBar('💔 Đã xoá khỏi yêu thích');
        }
      } else {
        success = await FavoriteService.addFavorite(userId, productId);
        if (success) {
          _showSnackBar('❤️ Đã thêm vào yêu thích');
        }
      }

      if (success) {
        setState(() {
          isFavorite = !isFavorite;
        });
      } else {
        _showSnackBar('❌ Thao tác thất bại');
      }
    } catch (e) {
      _showSnackBar('Lỗi: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

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
            _buildProductImage(),
            _buildTopButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
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
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  widget.product?['hinh_anh'] ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.fastfood, size: 60, color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopButtons() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width15,
          vertical: Dimensions.height10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildFavoriteButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.red : Colors.black87,
        ),
        onPressed: isLoading ? null : _toggleFavorite,
      ),
    );
  }
}
