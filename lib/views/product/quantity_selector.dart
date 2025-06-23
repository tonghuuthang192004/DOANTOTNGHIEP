import 'package:flutter/material.dart';
import '../../../utils/dimensions.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const QuantitySelector({
    Key? key,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Số lượng',
          style: TextStyle(
            fontSize: Dimensions.font18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: Dimensions.height10),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(Dimensions.radius10),
          ),
          padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: quantity > 1 ? onDecrease : null,
                icon: Icon(Icons.remove),
                color: Colors.orange,
              ),
              Text(
                quantity.toString(),
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: onIncrease,
                icon: Icon(Icons.add),
                color: Colors.orange,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
