class FoodModel {
  final String name;
  final String image;
  final double rating;
  final String distance;
  final double price;
  final bool isPopular;

  FoodModel({
    required this.name,
    required this.image,
    required this.rating,
    required this.distance,
    required this.price,
    required this.isPopular,
  });

  static List<FoodModel> sampleFoods() {
    return [
      FoodModel(name: 'Cheese Burger', image: 'Burger.png', rating: 4.5, distance: '1.2 km', price: 5.99, isPopular: true),
      FoodModel(name: 'Pepperoni Pizza', image: 'Burger.png', rating: 4.7, distance: '0.8 km', price: 8.99, isPopular: false),
      FoodModel(name: 'California Roll', image: 'Burger.png', rating: 4.3, distance: '2.0 km', price: 12.99, isPopular: true),
      FoodModel(name: 'Chocolate Cake', image: 'Burger.png', rating: 4.8, distance: '1.5 km', price: 6.50, isPopular: false),
    ];
  }
}
