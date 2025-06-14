import 'package:flutter/material.dart';

class CategoryModel {
  final String name;
  final String image;

  CategoryModel({required this.name, required this.image});

  static List<CategoryModel> sampleCategories() {
    return [
      CategoryModel(name: 'Burger', image: 'images/fried_chicken.png'),
      CategoryModel(name: 'Pizza', image: 'images/fried_chicken.png'),
      CategoryModel(name: 'Sushi', image: 'images/fried_chicken.png'),
      CategoryModel(name: 'Dessert', image: 'images/fried_chicken.png'),
      CategoryModel(name: 'Drink', image: 'images/fried_chicken.png'),
      CategoryModel(name: 'Salad', image: 'images/fried_chicken.png'),
    ];
  }
}







