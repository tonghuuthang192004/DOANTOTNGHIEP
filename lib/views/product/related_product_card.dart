import 'package:flutter/material.dart';
import '../../../utils/dimensions.dart';

class RelatedProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const RelatedProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String name = product['ten'] ?? 'Sản phẩm'; // ✅ đúng key từ API
    final double price = product['gia'] != null
        ? (product['gia'] as num).toDouble()
        : 0.0;
    final String imageUrl = product['hinh_anh'] ?? '';
    final double rating = product['danh_gia'] != null
        ? (product['danh_gia'] as num).toDouble()
        : 4.5;

    return Container(
      width: Dimensions.screenWidth * 0.4,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(Dimensions.radius12),
            ),
            child: imageUrl.isNotEmpty
                ? Image.network(
              imageUrl,
              height: Dimensions.screenHeight * 0.12,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.fastfood,
                size: Dimensions.iconSize30 * 2,
                color: Colors.white.withOpacity(0.8),
              ),
            )
                : Container(
              height: Dimensions.screenHeight * 0.12,
              width: double.infinity,
              color: Colors.orange.shade50,
              child: Icon(
                Icons.fastfood,
                size: Dimensions.iconSize30 * 2,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(Dimensions.width10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: Dimensions.height5),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 4),
                      Text(rating.toStringAsFixed(1)),
                    ],
                  ),
                  SizedBox(height: Dimensions.height5),
                  Text(
                    "${price.toStringAsFixed(0)}đ", // ✅ hiện đúng đơn vị
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


