import 'package:flutter/material.dart';

import '../ favourite/favourite.dart';

class FoodCard extends StatelessWidget {
  final Map<String, dynamic> food;
  final VoidCallback onAddToCart;

  const FoodCard({required this.food, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: Offset(0, 8))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.asset('images/${food['image']}',
                    fit: BoxFit.contain,
                    // Hiển thị toàn bộ ảnh, không cắt, giữ tỉ lệ
                    alignment: Alignment.center,
                    height: 120,
                    width: double.infinity),
              ),
              if (food['isPopular'])
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12)),
                    child: Text("Phổ biến",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: IconButton(
                    icon: Icon(Icons.favorite_border, size: 16, color: Colors.grey[600]),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FavoritePage(favoriteProducts: favoriteProducts,)),
                      );
                    },
                  ),

                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(food['name'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star_rounded,
                          color: Colors.amber[600], size: 16),
                      SizedBox(width: 2),
                      Text("${food['rating']}",
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600])),
                      SizedBox(width: 8),
                      Icon(Icons.location_on,
                          size: 14, color: Colors.grey[500]),
                      SizedBox(width: 2),
                      Text(food['distance'],
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[500])),
                    ],
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("\$${food['price']}",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[600])),
                      GestureDetector(
                        onTap: onAddToCart,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(12)),
                          child: Icon(Icons.add_shopping_cart,
                              color: Colors.white, size: 16),
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
    );
  }
}
