import 'package:flutter/material.dart';

import '../../utils/dimensions.dart';

class HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade400, Colors.orange.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(Dimensions.width20),
        child: Column(
          children: [
            SizedBox(height: Dimensions.height10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Giao hàng đến", style: TextStyle(fontSize: Dimensions.font16, color: Colors.white70)),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.white, size: Dimensions.iconSize16),
                        SizedBox(width: 4),
                        Text("New York, USA", style: TextStyle(fontSize: Dimensions.font16, fontWeight: FontWeight.bold, color: Colors.white)),
                        Icon(Icons.keyboard_arrow_down, color: Colors.white, size: Dimensions.iconSize24),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.notifications_outlined, color: Colors.white, size: Dimensions.iconSize24),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height20),
            // Search bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width15, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                ],
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Tìm kiếm món ăn yêu thích...",
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.orange, size: Dimensions.iconSize24),
                  suffixIcon: Icon(Icons.tune, color: Colors.grey[400], size: Dimensions.iconSize24),
                ),
              ),
            ),
            SizedBox(height: Dimensions.height15),
          ],
        ),
      ),
    );
  }
}
