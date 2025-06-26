// 📁 lib/pages/cart/cart_empty_widget.dart
import 'package:flutter/material.dart';
import '../../utils/dimensions.dart';

class CartEmptyState extends StatelessWidget {
  const CartEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Dimensions.height20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: Dimensions.height100,
              color: Colors.grey[400],
            ),
            SizedBox(height: Dimensions.height20),
            const Text(
              "Giỏ hàng trống",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: Dimensions.height10),
            Text(
              "Hãy thêm một số món ăn vào giỏ hàng để bắt đầu.",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Dimensions.height20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width30,
                  vertical: Dimensions.height12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
              ),
              child: const Text("Quay lại menu"),
            ),
          ],
        ),
      ),
    );
  }
}
