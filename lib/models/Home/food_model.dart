import 'package:flutter/material.dart';

class Food {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final double rating;

  Food({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.rating,
  });
}

List<Food> foods = [
  Food(
    id: '1',
    name: 'Burger Deluxe',
    description: 'Burger bò đặc biệt với phô mai và rau xanh',
    price: 89000,
    imageUrl: 'images/fried_chicken.png',
    rating: 4.8,
  ),
  Food(
    id: '2',
    name: 'Pizza Margherita',
    description: 'Pizza truyền thống với phô mai mozzarella',
    price: 120000,
    imageUrl: 'images/fried_chicken.png',
    rating: 4.6,
  ),
  Food(
    id: '3',
    name: 'Chicken Wings',
    description: 'Cánh gà nướng BBQ cay nồng',
    price: 65000,
    imageUrl: 'images/fried_chicken.png',
    rating: 4.5,
  ),
  Food(
    id: '4',
    name: 'French Fries',
    description: 'Khoai tây chiên giòn rụm',
    price: 35000,
    imageUrl: 'images/fried_chicken.png',
    rating: 4.3,
  ),
  Food(
    id: '5',
    name: 'Hot Dog',
    description: 'Hot dog với xúc xích và bánh mì',
    price: 45000,
    imageUrl: 'images/fried_chicken.png',
    rating: 4.2,
  ),
  Food(
    id: '6',
    name: 'Fried Chicken',
    description: 'Gà rán giòn tan tẩm gia vị',
    price: 75000,
    imageUrl: 'images/fried_chicken.png',
    rating: 4.7,
  ),

];


final List<Map<String, dynamic>> foodCategories = [
  {
    'name': 'Burger',
  },
  {
    'name': 'Pizza',

  },
  {
    'name': 'Sushi',

  },
  {
    'name': 'Dessert',
  },
  {
    'name': 'Drink',
  },
  {
    'name': 'Salad',
  },
];
