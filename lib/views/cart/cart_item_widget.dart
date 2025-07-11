import 'package:flutter/material.dart';
import '../../models/cart/cart_model.dart';
import '../../utils/dimensions.dart';
import 'package:intl/intl.dart';

class CartItem extends StatelessWidget {
  final CartModel cart;
  final VoidCallback onAdd;
  final VoidCallback onReduce;
  final VoidCallback onRemove;

  const CartItem({
    super.key,
    required this.cart,
    required this.onAdd,
    required this.onReduce,
    required this.onRemove,
  });

  String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(cart.id.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: Container(
        margin: EdgeInsets.only(bottom: Dimensions.height15),
        padding: EdgeInsets.only(right: Dimensions.width20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
        ),
        child: const Icon(Icons.delete, color: Colors.yellow),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: Dimensions.height15),
        padding: EdgeInsets.all(Dimensions.height10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radius12),
              child: Image.network(
                cart.product.hinhAnh.startsWith('http') || cart.product.hinhAnh.startsWith('https')
                    ? cart.product.hinhAnh
                    : 'http://10.0.2.2:3000/uploads/${cart.product.hinhAnh}',
                width: Dimensions.height100,
                height: Dimensions.height100,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: Dimensions.height100,
                    height: Dimensions.height100,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                  );
                },
              ),
            ),
            SizedBox(width: Dimensions.width10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cart.product.ten,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatCurrency(cart.product.gia),
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Thông tin số lượng còn lại đã bị loại bỏ
                    ],
                  ),
                  SizedBox(height: Dimensions.height10),
                  Row(
                    children: [
                      // Nút giảm số lượng
                      _quantityButton(Icons.remove, onReduce, cart.quantity <= 1),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
                        child: Text('${cart.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      // Nút cộng số lượng, vô hiệu hóa khi số lượng giỏ hàng đã đủ
                      _quantityButton(
                        Icons.add,
                        onAdd,
                        false,  // Sửa lại đây để không còn kiểm tra số lượng kho nữa
                      ),
                      SizedBox(width: Dimensions.width10),
                      // Nút xóa sản phẩm
                      InkWell(
                        onTap: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Xác nhận xoá'),
                              content: const Text('Bạn có chắc muốn xoá sản phẩm này khỏi giỏ hàng?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Huỷ'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Xoá'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            onRemove();
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(Dimensions.height8),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(Dimensions.radius10),
                          ),
                          child: const Icon(Icons.delete, size: 18, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onPressed, bool disabled) {
    return InkWell(
      onTap: disabled ? null : onPressed,
      child: Container(
        padding: EdgeInsets.all(Dimensions.height8),
        decoration: BoxDecoration(
          color: disabled ? Colors.grey[200] : Colors.orange.withOpacity(0.2),
          borderRadius: BorderRadius.circular(Dimensions.radius10),
        ),
        child: Icon(icon, size: 16, color: disabled ? Colors.grey : Colors.orange),
      ),
    );
  }
}
