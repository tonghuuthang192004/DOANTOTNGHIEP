import 'package:flutter/material.dart';

class CategoryModel {
  final String name;
  final Color color;
  final IconData icon;

  CategoryModel({
    required this.name,
    required this.color,
    required this.icon,
  });

  static List<CategoryModel> sampleCategories() {
    return [
      CategoryModel(name: 'Burger', color: Colors.orange.shade100, icon: Icons.lunch_dining),
      CategoryModel(name: 'Pizza', color: Colors.red.shade100, icon: Icons.local_pizza),
      CategoryModel(name: 'Sushi', color: Colors.green.shade100, icon: Icons.restaurant),
      CategoryModel(name: 'Dessert', color: Colors.purple.shade100, icon: Icons.cake),
      CategoryModel(name: 'Drink', color: Colors.blue.shade100, icon: Icons.local_drink),
      CategoryModel(name: 'Salad', color: Colors.teal.shade100, icon: Icons.eco),
    ];
  }
}
