// 📁 lib/pages/cart/cart_summary_widget.dart
import 'package:flutter/material.dart';
import '../../utils/dimensions.dart';

class CartSummary extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double totalCart;
  final VoidCallback onCheckout;

  const CartSummary({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.totalCart,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.height20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.radius20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildPriceRow("Tạm tính", subtotal),
          SizedBox(height: Dimensions.height10),
          _buildPriceRow("Phí giao hàng", deliveryFee),
          SizedBox(height: Dimensions.height10),
          _buildPriceRow("Thuế", tax),
          Divider(height: Dimensions.height20),
          _buildPriceRow("Tổng cộng", totalCart, isTotal: true),
          SizedBox(height: Dimensions.height20),
          ElevatedButton(
            onPressed: onCheckout,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: EdgeInsets.symmetric(vertical: Dimensions.height12),
              minimumSize: Size(double.infinity, Dimensions.height50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius15),
              ),
            ),
            child: Text(
              "Thanh toán \$${totalCart.toStringAsFixed(2)}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? Dimensions.font18 : Dimensions.font14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? Colors.black : Colors.grey[700],
          ),
        ),
        Text(
          "\$${amount.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: isTotal ? Dimensions.font18 : Dimensions.font14,
            fontWeight: FontWeight.bold,
            color: isTotal ? Colors.orange : Colors.black,
          ),
        ),
      ],
    );
  }
}
