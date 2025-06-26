import 'package:flutter/material.dart';
import '../../models/product/product_model.dart';
import '../../utils/dimensions.dart';

class FoodCard extends StatelessWidget {
  final ProductModel food;
  final VoidCallback onTap;

  const FoodCard({
    super.key,
    required this.food,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Dimensions.height280, // Giới hạn chiều cao toàn card
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: Dimensions.height15,
              offset: Offset(0, Dimensions.height8),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(Dimensions.radius20),
              ),
              child: Image.network(
                food.hinhAnh,
                height: Dimensions.height100,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: Dimensions.height100,
                  color: Colors.grey[200],
                  child: Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Padding(
                padding: EdgeInsets.all(Dimensions.height10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // ✅ sửa chỗ này
                  children: [
                    Text(
                      food.ten,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: Dimensions.font16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: Dimensions.height5),
                    Text(
                      "${food.gia.toInt()}₫",
                      style: TextStyle(
                        fontSize: Dimensions.font16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800],
                      ),
                    ),
                    SizedBox(height: Dimensions.height5),
                    Row(
                      children: [
                        Icon(Icons.star_rounded,
                            color: Colors.amber[600],
                            size: Dimensions.iconSize16),
                        SizedBox(width: Dimensions.width5),
                        Text(
                          "${food.danhGia}",
                          style: TextStyle(
                            fontSize: Dimensions.font12,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(width: Dimensions.width5),
                        Text(
                          "(120)",
                          style: TextStyle(
                            fontSize: Dimensions.font12,
                            color: Colors.grey[500],
                          ),
                        ),
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
}
