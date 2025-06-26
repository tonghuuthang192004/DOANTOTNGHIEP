import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/product/product_model.dart';

class FavoriteListItem extends StatelessWidget {
  final ProductModel product;
  final int index;
  final VoidCallback onRemove;
  final VoidCallback? onAddToCart;

  const FavoriteListItem({
    super.key,
    required this.product,
    required this.index,
    required this.onRemove,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Ảnh sản phẩm
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.hinhAnh,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.fastfood, size: 40),
              ),
            ),
            const SizedBox(width: 12),

            // Thông tin sản phẩm
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.ten,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.moTa,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${NumberFormat("#,###", "vi_VN").format(product.gia)}đ',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // ✅ Nút thêm vào giỏ hàng (nếu có truyền)
            if (onAddToCart != null)
              IconButton(
                onPressed: onAddToCart,
                icon: const Icon(Icons.add_shopping_cart, color: Colors.blueAccent),
                tooltip: 'Thêm vào giỏ hàng',
              ),

            // ❌ Nút xoá khỏi yêu thích
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              tooltip: 'Xoá khỏi yêu thích',
            ),
          ],
        ),
      ),
    );
  }
}
