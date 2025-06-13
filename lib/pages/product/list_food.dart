import 'package:flutter/material.dart';

import '../../utils/dimensions.dart';
import '../../widgets/bottom_navigation_bar.dart';

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

class FoodListPage extends StatefulWidget {
  @override
  _FoodListPageState createState() => _FoodListPageState();
}

class _FoodListPageState extends State<FoodListPage> {
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
    Food(
      id: '7',
      name: 'Sandwich',
      description: 'Sandwich thịt nguội và rau tươi',
      price: 55000,
      imageUrl: 'images/fried_chicken.png',
      rating: 4.4,
    ),
    Food(
      id: '8',
      name: 'Pasta',
      description: 'Mì Ý sốt cà chua và phô mai',
      price: 85000,
      imageUrl: 'images/fried_chicken.png',
      rating: 4.6,
    ),
    Food(
      id: '9',
      name: 'Salad',
      description: 'Salad rau xanh tươi mát',
      price: 40000,
      imageUrl: 'images/fried_chicken.png',
      rating: 4.1,
    ),
    Food(
      id: '10',
      name: 'Coca Cola',
      description: 'Nước ngọt Coca Cola mát lạnh',
      price: 20000,
      imageUrl: 'images/fried_chicken.png',
      rating: 4.5,
    ),
  ];

  List<Food> filteredFoods = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredFoods = foods;
  }

  void filterFoods(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredFoods = foods;
      } else {
        filteredFoods = foods.where((food) {
          return food.name.toLowerCase().contains(query.toLowerCase()) ||
              food.description.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Nút quay về nằm riêng phía trên
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(
                top: Dimensions.height20,
                left: Dimensions.width20,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: Dimensions.iconSize24,
                  color: Colors.black87,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainNavigation()),
                  );
                },
              ),
            ),

            // Search Bar
            Container(
              margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Dimensions.radius15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                onChanged: filterFoods,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm món ăn...',
                  hintStyle: TextStyle(
                    fontSize: Dimensions.font16,
                    color: Colors.grey[500],
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: Dimensions.iconSize24,
                    color: Colors.grey[500],
                  ),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      size: Dimensions.iconSize20,
                      color: Colors.grey[500],
                    ),
                    onPressed: () {
                      searchController.clear();
                      filterFoods('');
                    },
                  )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width20,
                    vertical: Dimensions.height15,
                  ),
                ),
              ),
            ),

            SizedBox(height: Dimensions.height10),

            // Product Grid
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: Dimensions.width15,
                  mainAxisSpacing: Dimensions.height15,
                ),
                itemCount: filteredFoods.length,
                itemBuilder: (context, index) {
                  return _buildFoodCard(filteredFoods[index]);
                },
              ),
            ),
          ],
        ),

      ),
    );
  }

  Widget _buildFoodCard(Food food) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Food Image
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimensions.radius20),
                  topRight: Radius.circular(Dimensions.radius20),
                ),
                image: DecorationImage(
                  image: AssetImage(food.imageUrl),
                  fit: BoxFit.contain,
                ),
              ),
              child: Stack(
                children: [
                  // Favorite Button
                  Positioned(
                    top: Dimensions.height10,
                    right: Dimensions.width10,
                    child: Container(
                      padding: EdgeInsets.all(Dimensions.width8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(Dimensions.radius15),
                      ),
                      child: Icon(
                        Icons.favorite_border,
                        size: Dimensions.iconSize20,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),

                  // Rating
                  Positioned(
                    top: Dimensions.height10,
                    left: Dimensions.width10,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width8,
                        vertical: Dimensions.height5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(Dimensions.radius10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            size: Dimensions.iconSize16,
                            color: Colors.amber,
                          ),
                          SizedBox(width: Dimensions.width5),
                          Text(
                            food.rating.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimensions.font14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),


          // Food Info
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(Dimensions.width25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Food Name
                  Text(
                    food.name,
                    style: TextStyle(
                      fontSize: Dimensions.font16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: Dimensions.height5),

                  // Food Description
                  Text(
                    food.description,
                    style: TextStyle(
                      fontSize: Dimensions.font14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Price and Add Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${food.price.toInt()}đ',
                        style: TextStyle(
                          fontSize: Dimensions.font16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(Dimensions.width8),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(Dimensions.radius10),
                        ),
                        child: Icon(
                          Icons.add_shopping_cart,
                          size: Dimensions.iconSize20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}