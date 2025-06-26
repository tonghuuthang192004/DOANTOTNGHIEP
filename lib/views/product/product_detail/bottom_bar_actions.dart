import 'package:flutter/material.dart';
import '../../../../utils/dimensions.dart';

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
            buildActionButton(
              icon: Icons.add_shopping_cart,
              label: "Thêm ${totalPrice.toStringAsFixed(0)}₫",
              color: Colors.orange,
              onPressed: onAddToCart,
            ),
            SizedBox(height: Dimensions.height10),
            buildActionButton(
              icon: Icons.flash_on,
              label: "Mua ngay - ${totalPrice.toStringAsFixed(0)}₫",
              color: Colors.green,
              onPressed: onBuyNow,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: Dimensions.height15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius10),
          ),
        ),
      ),
    );
  }
}
