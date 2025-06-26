// 📁 lib/pages/cart/cart_item_widget.dart

import 'package:flutter/material.dart';
import '../../models/cart/cart_model.dart';
import '../../utils/dimensions.dart';

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
        child: const Icon(Icons.delete, color: Colors.white),
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
              child: Image.asset(
                cart.product.hinhAnh,
                width: Dimensions.height100,
                height: Dimensions.height100,
                fit: BoxFit.contain,
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
                  Text(
                    '\$${cart.product.gia.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.orange),
                  ),
                  SizedBox(height: Dimensions.height10),
                  Row(
                    children: [
                      _quantityButton(Icons.remove, onReduce, cart.quantity <= 1),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
                        child: Text('${cart.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      _quantityButton(Icons.add, onAdd, false),
                    ],
                  )
                ],
              ),
            )
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
