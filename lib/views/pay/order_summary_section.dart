import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderSummarySection extends StatelessWidget {
  final double subTotal;
  final double discount;
  final double total;

  const OrderSummarySection({
    super.key,
    required this.subTotal,
    required this.discount,
    required this.total,
  });

  String formatCurrency(double value) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.receipt_long, color: Color(0xFF2196F3)),
              SizedBox(width: 8),
              Text('Chi tiết đơn hàng',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          _buildRow('Tạm tính', formatCurrency(subTotal)),
          _buildRow('Giảm giá', '-${formatCurrency(discount)}',
              isDiscount: true),
          const Divider(height: 24, thickness: 1),
          _buildRow('Tổng cộng', formatCurrency(total), isTotal: true),
          const SizedBox(height: 12),
          if (discount > 0)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_offer,
                      color: Color(0xFF4CAF50), size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Bạn đã tiết kiệm được ${formatCurrency(discount)}!',
                    style: const TextStyle(
                      color: Color(0xFF4CAF50),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value,
      {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? Colors.black : Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 20 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal
                  ? const Color(0xFF4CAF50)
                  : isDiscount
                  ? const Color(0xFFE91E63)
                  : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
