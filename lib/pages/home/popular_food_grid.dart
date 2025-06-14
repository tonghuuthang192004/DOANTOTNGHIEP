import 'package:flutter/material.dart';

import '../../utils/dimensions.dart';
import '../product/food_detail.dart';
import 'food_card.dart';

class PopularFoodGrid extends StatelessWidget {
  final List<Map<String, dynamic>> foods;
  final void Function(BuildContext, Map<String, dynamic>) onAddToCart;

  PopularFoodGrid({required this.foods, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: foods.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: Dimensions.height20,
        crossAxisSpacing: Dimensions.width15,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        final food = foods[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen()));
          },
          child: FoodCard(food: food, onAddToCart: () => onAddToCart(context, food)),
        );
      },
    );
  }
}
