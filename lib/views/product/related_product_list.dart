import 'package:flutter/material.dart';
import '../../../utils/dimensions.dart';
import 'related_product_card.dart'; //

class RelatedProductList extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  const RelatedProductList({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return SizedBox(); // Không hiển thị nếu không có sản phẩm

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Bạn cũng có thể thích",
          style: TextStyle(
            fontSize: Dimensions.font18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: Dimensions.height10),
        SizedBox(
          height: Dimensions.screenHeight * 0.25,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            padding: EdgeInsets.only(right: Dimensions.width15),
            separatorBuilder: (_, __) => SizedBox(width: Dimensions.width10),
            itemBuilder: (_, index) =>
                RelatedProductCard(product: products[index]),
          ),
        ),
      ],
    );
  }
}
