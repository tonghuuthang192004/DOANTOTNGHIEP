import 'package:flutter/material.dart';
import '../../../utils/dimensions.dart';

class BottomBarActions extends StatelessWidget {
  final double totalPrice;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const BottomBarActions({
    Key? key,
    required this.totalPrice,
    required this.onAddToCart,
    required this.onBuyNow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Nút Thêm vào giỏ hàng
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onAddToCart,
                icon: Icon(Icons.shopping_cart),
                label: Text("Add \$${totalPrice.toStringAsFixed(2)}"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: Dimensions.height15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius10),
                  ),
                ),
              ),
            ),

            SizedBox(height: Dimensions.height10),

            /// Nút Mua ngay
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onBuyNow,
                icon: Icon(Icons.payment),
                label: Text("Buy Now - \$${totalPrice.toStringAsFixed(2)}"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: Dimensions.height15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
