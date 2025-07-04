import 'package:flutter/material.dart';
import '../../../../utils/dimensions.dart';
import 'related_product_card.dart';

class RelatedProductList extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  const RelatedProductList({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: Dimensions.height10),
          child: Text(
            "Bạn cũng có thể thích",
            style: TextStyle(
              fontSize: Dimensions.font18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: Dimensions.screenHeight * 0.26,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width15),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: Dimensions.width10),
                child: RelatedProductCard(product: products[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
