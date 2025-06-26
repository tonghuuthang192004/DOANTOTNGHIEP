import 'package:flutter/material.dart';
import '../../models/product/product_model.dart';
import '../../utils/dimensions.dart';
import '../product/product_detail/product_detail_screen.dart';
import 'food_card.dart';

class PopularFoodGrid extends StatelessWidget {
  final List<ProductModel> foods;

  const PopularFoodGrid({
    Key? key,
    required this.foods,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: foods.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: Dimensions.height20,
        crossAxisSpacing: Dimensions.width15,

        /// 👇 Điều chỉnh tỉ lệ khung item để tránh lỗi tràn
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, index) {
        final food = foods[index];
        return FoodCard(
          food: food,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailScreen(product: food.toJson()),
              ),
            );
          },
        );
      },
    );
  }
}
