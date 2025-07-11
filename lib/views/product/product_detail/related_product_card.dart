import 'package:flutter/material.dart';
import 'package:frontendtn1/views/product/product_detail/product_detail_screen.dart';
import 'package:intl/intl.dart';
import '../../../../utils/dimensions.dart';

class RelatedProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const RelatedProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String name = product['ten'] ?? 'Sản phẩm';
    final double price = (product['gia'] as num?)?.toDouble() ?? 0.0;
    final String imageUrl = product['hinh_anh'] ?? '';
    final double rating = (product['danh_gia'] as num?)?.toDouble() ?? 4.5;

    return GestureDetector(
      onTap: () {
        // 👇 Khi bấm vào card, mở ProductDetailScreen với sản phẩm đó
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        width: Dimensions.screenWidth * 0.4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.radius12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(imageUrl),
            Expanded(child: _buildInfo(name, rating, price)),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    final placeholder = Container(
      height: Dimensions.screenHeight * 0.12,
      width: double.infinity,
      color: Colors.orange.shade50,
      child: Icon(
        Icons.fastfood,
        size: Dimensions.iconSize30 * 2,
        color: Colors.white.withOpacity(0.8),
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(Dimensions.radius12),
      ),
      child: imageUrl.isNotEmpty
          ? Image.network(
        imageUrl,
        height: Dimensions.screenHeight * 0.12,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => placeholder,
      )
          : placeholder,
    );
  }

  Widget _buildInfo(String name, double rating, double price) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.width10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: Dimensions.height5),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text(rating.toStringAsFixed(1)),
            ],
          ),
          SizedBox(height: Dimensions.height5),
          Text(
            "${NumberFormat("#,###", "vi_VN").format(price)}đ",
            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
