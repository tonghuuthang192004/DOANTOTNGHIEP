import 'package:flutter/material.dart';
import '../../utils/dimensions.dart';
import '../Cart/Cart.dart';
import 'food_detail.dart';

class Food {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final double rating;
  final String category;

  Food({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.category,
  });
}

class FoodListPage extends StatefulWidget {
  final int categoryIndex;
  final String categoryName;

  const FoodListPage({
    required this.categoryIndex,
    required this.categoryName,
    Key? key,
  }) : super(key: key);

  @override
  _FoodListPageState createState() => _FoodListPageState();
}

class _FoodListPageState extends State<FoodListPage> {
  final List<Food> foods = [
    Food(
        id: '1',
        name: 'Pizza Margherita',
        description: 'Pizza truyền thống',
        price: 120000,
        imageUrl: 'images/fried_chicken.png',
        rating: 4.6,
        category: 'Pizza'),
    Food(
        id: '2',
        name: 'Pasta',
        description: 'Mì Ý sốt cà chua',
        price: 85000,
        imageUrl: 'images/fried_chicken.png',
        rating: 4.4,
        category: 'Pizza'),
    // Thêm món khác...
  ];

  final Map<String, int> cartItems = {};
  final Set<String> favorites = {};

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    final filteredFoods =
        foods.where((f) => f.category == widget.categoryName).toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(widget.categoryName),
        leading: BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(Dimensions.width15),
        itemCount: filteredFoods.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: Dimensions.width15,
          mainAxisSpacing: Dimensions.height15,
          childAspectRatio: 0.68,
        ),
        itemBuilder: (context, index) {
          final food = filteredFoods[index];
          final isFavorite = favorites.contains(food.id);
          final quantity = cartItems[food.id] ?? 0;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailScreen(),
                  ));
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Dimensions.radius15),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 3)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image + favorite
                  Stack(
                    children: [
                      Container(
                        height: Dimensions.height100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(Dimensions.radius15),
                              topRight: Radius.circular(Dimensions.radius15)),
                          image: DecorationImage(
                              image: AssetImage(food.imageUrl),
                              fit: BoxFit.contain),
                        ),
                      ),
                      Positioned(
                        top: Dimensions.height10,
                        right: Dimensions.width10,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isFavorite) {
                                favorites.remove(food.id);
                              } else {
                                favorites.add(food.id);
                              }
                            });
                          },
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                            size: Dimensions.iconSize24,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Food name, price
                  Padding(
                    padding: EdgeInsets.all(Dimensions.width10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          food.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Dimensions.font16),
                        ),
                        SizedBox(height: Dimensions.height5),
                        Text(
                          '${food.price.toInt()}đ',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.orange,
                              fontSize: Dimensions.font14),
                        ),
                      ],
                    ),
                  ),

                  // Add to cart + quantity
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Dimensions.width10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Quantity Control
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                if (quantity > 0) {
                                  setState(() {
                                    cartItems[food.id] = quantity - 1;
                                  });
                                }
                              },
                            ),
                            Text(quantity.toString(),
                                style: TextStyle(fontSize: Dimensions.font14)),
                            IconButton(
                              icon: Icon(Icons.add_circle_outline),
                              onPressed: () {
                                setState(() {
                                  cartItems[food.id] = quantity + 1;
                                });
                              },
                            ),
                          ],
                        ),

                        // Add to Cart Button
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => CartPage()));
                          },
                          child: Container(
                            padding: EdgeInsets.all(Dimensions.width8),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radius10),
                            ),
                            child: Icon(Icons.shopping_cart,
                                color: Colors.white,
                                size: Dimensions.iconSize20),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
