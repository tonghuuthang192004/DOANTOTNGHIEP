import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // ✅ Định dạng VNĐ
import '../../utils/dimensions.dart';

class CartSummary extends StatelessWidget {
  final double totalCart;
  final VoidCallback onCheckout;

  const CartSummary({
    super.key,
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
          _buildPriceRow("Tạm tính", totalCart), // <-- Thêm dòng này
          const SizedBox(height: 10),
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
              "Thanh toán ${_formatCurrency(totalCart)}",
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
          _formatCurrency(amount),
          style: TextStyle(
            fontSize: isTotal ? Dimensions.font18 : Dimensions.font14,
            fontWeight: FontWeight.bold,
            color: isTotal ? Colors.orange : Colors.black,
          ),
        ),
      ],
    );
  }

  /// ✅ Hàm định dạng tiền VNĐ
  String _formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(amount);
  }
}
