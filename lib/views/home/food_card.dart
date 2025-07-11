import 'package:flutter/material.dart';
import '../../models/product/product_model.dart';
import '../../utils/dimensions.dart';
import 'package:intl/intl.dart';
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
                food.hinhAnh.startsWith('http') || food.hinhAnh.startsWith('https')
                    ? food.hinhAnh
                    : 'http://10.0.2.2:3000/uploads/${food.hinhAnh}',
                width: double.infinity,
                height: Dimensions.height100,// Điều chỉnh theo yêu cầu của bạn
                fit: BoxFit.cover,       // Điều chỉnh cách hiển thị hình ảnh
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: Icon(Icons.broken_image, color: Colors.grey),
                  );
                },
              )
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
                      "${NumberFormat("#,###", "vi_VN").format(food.gia)}₫",
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
