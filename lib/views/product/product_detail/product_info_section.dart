import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../utils/dimensions.dart';

class ProductInfoSection extends StatelessWidget {
  final Map<String, dynamic>? product;
  final double basePrice;

  const ProductInfoSection({
    Key? key,
    required this.product,
    required this.basePrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = product?['ten'] ?? 'Tên sản phẩm';
    final description = product?['mo_ta'] ?? 'Không có mô tả.';
    final rating = double.tryParse(product?['danh_gia']?.toString() ?? '') ?? 4.5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Tên sản phẩm + đánh giá
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: Dimensions.font26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            _buildRatingBadge(rating),
          ],
        ),

        SizedBox(height: Dimensions.height8),

        /// Giá
        Text(
          '${NumberFormat("#,###", "vi_VN").format(basePrice)}đ',
          style: TextStyle(
            fontSize: Dimensions.font22,
            fontWeight: FontWeight.bold,
            color: Colors.orange.shade600,
          ),
        ),

        SizedBox(height: Dimensions.height15),

        /// Mô tả
        Text(
          description,
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: Dimensions.font16,
            color: Colors.grey.shade600,
            height: 1.5,
          ),
        ),

        SizedBox(height: Dimensions.height20),
      ],
    );
  }

  Widget _buildRatingBadge(double rating) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width10,
        vertical: Dimensions.height5,
      ),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
      ),
      child: Row(
        children: [
          Icon(Icons.star, color: Colors.amber, size: Dimensions.iconSize16),
          SizedBox(width: Dimensions.width5),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: Dimensions.font14,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
          ),
        ],
      ),
    );
  }
}
