import 'package:flutter/material.dart';

import '../../utils/dimensions.dart';
import 'HomeScreen.dart';

class FoodCategoryList extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onCategorySelected;

  FoodCategoryList({required this.selectedIndex, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
        itemCount: foodCategories.length,
        itemBuilder: (context, index) {
          final item = foodCategories[index];
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onCategorySelected(index),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 8),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                //scolor: isSelected ? Colors.orange : item['color'],
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected ? [BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 10, offset: Offset(0, 5))] : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item['icon'], color: isSelected ? Colors.white : Colors.grey[700], size: 30),
                  SizedBox(height: 8),
                  Text(item['name'], style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: isSelected ? Colors.white : Colors.grey[700])),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
