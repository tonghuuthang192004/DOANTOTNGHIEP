import 'package:flutter/material.dart';
import '../../utils/dimensions.dart';
import '../../widgets/bottom_navigation_bar.dart';

class CartHeader extends StatelessWidget {
  final int itemCount;
  final VoidCallback? onClearAll;

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
          // ⬅️ Nút quay lại
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MainNavigation()),
                    (route) => false, // Xoá toàn bộ các route cũ
              );
            },
          ),
          // 🧾 Tiêu đề ở giữa
          Expanded(
            child: Text(
              "Giỏ hàng của tôi",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // 🔢 Số lượng sản phẩm
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

          // 🗑 Nút xoá tất cả
          if (itemCount > 0 && onClearAll != null)
            Padding(
              padding: EdgeInsets.only(left: Dimensions.width10),
              child: TextButton.icon(
                onPressed: onClearAll,
                icon: const Icon(Icons.delete_forever, color: Colors.redAccent, size: 20),
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
