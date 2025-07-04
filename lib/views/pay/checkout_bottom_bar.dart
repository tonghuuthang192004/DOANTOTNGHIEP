import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CheckoutBottomBar extends StatelessWidget {
  final double total;
  final bool isProcessing;
  final VoidCallback onPlaceOrder;
  final String paymentMethodName;
  final IconData paymentMethodIcon;
  final Color paymentColor;
  final Color paymentBgColor;

  const CheckoutBottomBar({
    super.key,
    required this.total,
    required this.isProcessing,
    required this.onPlaceOrder,
    required this.paymentMethodName,
    required this.paymentMethodIcon,
    required this.paymentColor,
    required this.paymentBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))],
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tổng thanh toán', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    Text(
                      NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(total),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4CAF50)),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: paymentBgColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: paymentColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(paymentMethodIcon, color: paymentColor, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        paymentMethodName,
                        style: TextStyle(color: paymentColor, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isProcessing ? null : onPlaceOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: isProcessing
                    ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text('Đang xử lý...', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                )
                    : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.payment, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Đặt hàng ngay', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
