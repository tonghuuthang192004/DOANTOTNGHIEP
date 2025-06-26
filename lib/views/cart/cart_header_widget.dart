import 'package:flutter/material.dart';
import '../../utils/dimensions.dart';

class CartHeader extends StatelessWidget {
  final int itemCount;
  final VoidCallback? onClearAll; // Thêm callback xóa toàn bộ

  const CartHeader({
    super.key,
    required this.itemCount,
    this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width20,
        vertical: Dimensions.height15,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              "Giỏ hàng của tôi",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(Dimensions.height10),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(Dimensions.radius12),
            ),
            child: Text(
              "$itemCount",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ),

          // Thêm nút Xoá tất cả nếu có onClearAll và itemCount > 0
          if (itemCount > 0 && onClearAll != null)
            Padding(
              padding: EdgeInsets.only(left: Dimensions.width15),
              child: TextButton.icon(
                onPressed: onClearAll,
                icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                label: const Text(
                  "Xoá tất cả",
                  style: TextStyle(color: Colors.redAccent),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width10,
                    vertical: Dimensions.height5,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
