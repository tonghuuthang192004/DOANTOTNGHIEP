import 'package:flutter/material.dart';

import '../../models/Home/category_model.dart';
import '../../utils/dimensions.dart';

class FoodCategoryList extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onCategorySelected;
  final List<CategoryModel> categories = CategoryModel.sampleCategories();

  FoodCategoryList({
    required this.selectedIndex,
    required this.onCategorySelected,
  });



  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimensions.height100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () => onCategorySelected(index),
            child: Container(
              margin: EdgeInsets.only(right: Dimensions.width10),
              padding: EdgeInsets.symmetric(
                vertical: Dimensions.height10,
                horizontal: Dimensions.width15,
              ),
              decoration: BoxDecoration(
                color: isSelected ? Colors.orange.shade100 : Colors.white,
                borderRadius: BorderRadius.circular(Dimensions.height15),
                border: Border.all(
                  color: isSelected ? Colors.orange : Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  Image.asset(
                    category.image,
                    width: Dimensions.width40,
                    height: Dimensions.height40,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: Dimensions.height5),
                  Text(
                    category.name,
                    style: TextStyle(
                      fontSize: Dimensions.font14,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.orange : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

