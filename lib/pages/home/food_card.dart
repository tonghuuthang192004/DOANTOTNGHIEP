import 'package:flutter/material.dart';
import '../../utils/dimensions.dart';

class FoodCard extends StatelessWidget {
  final Map<String, dynamic> food;
  final VoidCallback onAddToCart;

  const FoodCard({required this.food, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    final String name = food['name'] ?? 'Tên món ăn';
    final String image = food['image'] ?? 'default.png';
    final double price = (food['price'] ?? 0).toDouble();
    final double rating = (food['rating'] ?? 0).toDouble();
    final String distance = food['distance'] ?? '0km';
    final bool isPopular = food['isPopular'] == true;
    final bool isFavorite = food['isFavorite'] == true;

    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// --- Ảnh + Tag phổ biến + Yêu thích ---
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(Dimensions.radius20)),
                child: Image.asset(
                  'images/$image',
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  height: Dimensions.height100,
                  width: double.infinity,
                ),
              ),

              // 🔥 Nhãn HOT nếu phổ biến
              // 🔥 Nhãn HOT luôn hiển thị
              Positioned(
                top: Dimensions.height8,
                left: Dimensions.width8,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width8,
                    vertical: Dimensions.height5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(Dimensions.radius12),
                  ),
                  child: Text(
                    'HOT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Dimensions.font12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),


              // ❤️ Icon yêu thích
              Positioned(
                top: Dimensions.height8,
                right: Dimensions.width8,
                child: Container(
                  padding: EdgeInsets.all(Dimensions.height8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey[600],
                    size: Dimensions.iconSize16,
                  ),
                ),
              ),
            ],
          ),

          /// --- Nội dung chính ---
          Flexible(
            fit: FlexFit.tight,
            child: Padding(
              padding: EdgeInsets.all(Dimensions.height12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: Dimensions.font16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: Dimensions.height5),
                  Row(
                    children: [
                      Icon(Icons.star_rounded,
                          color: Colors.amber[600], size: Dimensions.iconSize16),
                      SizedBox(width: Dimensions.width5),
                      Text(
                        "$rating",
                        style: TextStyle(
                            fontSize: Dimensions.font12, color: Colors.grey[600]),
                      ),
                      SizedBox(width: Dimensions.width8),
                      Icon(Icons.location_on,
                          size: Dimensions.iconSize16, color: Colors.grey[500]),
                      SizedBox(width: Dimensions.width5),
                      Text(
                        distance,
                        style: TextStyle(
                            fontSize: Dimensions.font12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$$price",
                        style: TextStyle(
                            fontSize: Dimensions.font18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[600]),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(Dimensions.radius12),
                        onTap: onAddToCart,
                        child: Container(
                          padding: EdgeInsets.all(Dimensions.height8),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(Dimensions.radius12),
                          ),
                          child: Icon(Icons.add_shopping_cart,
                              color: Colors.white, size: Dimensions.iconSize16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
