import 'package:flutter/material.dart';
import '../../models/category/category_model.dart';
import '../../utils/dimensions.dart';

class FoodCategoryList extends StatefulWidget {
  final int selectedIndex;
  final Function(CategoryModel, int) onCategorySelected;
  final List<CategoryModel> categories;

  const FoodCategoryList({
    Key? key,
    required this.selectedIndex,
    required this.onCategorySelected,
    required this.categories,
  }) : super(key: key);

  @override
  State<FoodCategoryList> createState() => _FoodCategoryListState();
}

class _FoodCategoryListState extends State<FoodCategoryList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimensions.height100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories.length,
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
        itemBuilder: (context, index) {
          final category = widget.categories[index];
          final isSelected = index == widget.selectedIndex;

          return GestureDetector(
            onTap: () => widget.onCategorySelected(category, index),
            child: Container(
              width: Dimensions.width100, // Thêm width cố định
              height: Dimensions.height100,
              margin: EdgeInsets.only(right: Dimensions.width10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.orange.shade100 : Colors.white,
                borderRadius: BorderRadius.circular(Dimensions.height15),
                border: Border.all(
                  color: isSelected ? Colors.orange : Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    category.hinhAnh ?? 'https://via.placeholder.com/60',
                    width: Dimensions.width40,
                    height: Dimensions.height40,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image, size: 40);
                    },
                  ),
                  SizedBox(height: Dimensions.height5),
                  Text(
                    category.ten ?? 'Không tên',
                    textAlign: TextAlign.center,
                    maxLines: 2, // giới hạn dòng
                    overflow: TextOverflow.ellipsis, // nếu quá dài
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
