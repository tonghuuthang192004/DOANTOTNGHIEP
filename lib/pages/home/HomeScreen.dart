import 'package:flutter/material.dart';
import 'package:frontendtn1/pages/home/popular_food_grid.dart';
import '../../utils/dimensions.dart';
import '../Cart/Cart.dart';
import '../pay/payment.dart';
import '../product/list_food.dart';
import 'banner_promotion.dart';
import 'food_category_list.dart';
import 'home_header.dart';

final List<Map<String, dynamic>> foodCategories = [
  {
    'name': 'Burger',
    'color': Colors.orange.shade100,
    'icon': Icons.lunch_dining,
  },
  {
    'name': 'Pizza',
    'color': Colors.red.shade100,
    'icon': Icons.local_pizza,
  },
  {
    'name': 'Sushi',
    'color': Colors.green.shade100,
    'icon': Icons.restaurant,
  },
  {
    'name': 'Dessert',
    'color': Colors.purple.shade100,
    'icon': Icons.cake,
  },
  {
    'name': 'Drink',
    'color': Colors.blue.shade100,
    'icon': Icons.local_drink,
  },
  {
    'name': 'Salad',
    'color': Colors.teal.shade100,
    'icon': Icons.eco,
  },
];

final List<Map<String, dynamic>> allFoods = [
  {
    'name': 'Cheese Burger',
    'image': 'fried_chicken.png',
    'rating': 4.5,
    'distance': '1.2 km',
    'price': 5.99,
    'isPopular': true,
  },
  {
    'name': 'Pepperoni Pizza',
    'image': 'fried_chicken.png',
    'rating': 4.7,
    'distance': '0.8 km',
    'price': 8.99,
    'isPopular': false,
  },
  {
    'name': 'California Roll',
    'image': 'fried_chicken.png',
    'rating': 4.3,
    'distance': '2.0 km',
    'price': 12.99,
    'isPopular': true,
  },
  {
    'name': 'Chocolate Cake',
    'image': 'fried_chicken.png',
    'rating': 4.8,
    'distance': '1.5 km',
    'price': 6.50,
    'isPopular': false,
  },
];

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SingleChildScrollView(
          child: Column(
            children: [
              HomeHeader(),
              SizedBox(height: Dimensions.height20),
              BannerPromotion(),
              SizedBox(height: Dimensions.height30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                child: Text("Danh mục", style: TextStyle(fontSize: Dimensions.font20, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: Dimensions.height15),
              FoodCategoryList(
                selectedIndex: selectedCategoryIndex,
                onCategorySelected: (index) => setState(() => selectedCategoryIndex = index),
              ),
              SizedBox(height: Dimensions.height30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Món ăn phổ biến", style: TextStyle(fontSize: Dimensions.font20, fontWeight: FontWeight.bold)),
                    TextButton(onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FoodListPage()),
                      );
                    }, child: Text("Xem tất cả", style: TextStyle(color: Colors.orange))),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height10),
              PopularFoodGrid(
                foods: allFoods,
                onAddToCart: _showAddToCartBottomSheet,
              ),
              SizedBox(height: Dimensions.height30),
            ],
          ),
        ),
      ),
    );
  }
}

void _showAddToCartBottomSheet(BuildContext context, Map<String, dynamic> food) {
  int quantity = 1;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'images/${food['image']}',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
                          child: Icon(Icons.fastfood),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            food['name'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${food['price']}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove, color: Colors.orange),
                              onPressed: () {
                                if (quantity > 1) {
                                  setState(() {
                                    quantity--;
                                  });
                                }
                              },
                            ),
                            Text(
                              '$quantity',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add, color: Colors.orange),
                              onPressed: () {
                                setState(() {
                                  quantity++;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CartPage()),
                          );
                        },
                        child: Text(
                          'Thêm vào giỏ hàng',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          );
        },
      );
    },
  );
}


// void _showBuyNowBottomSheet(BuildContext context, Map<String, dynamic> food) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     builder: (context) {
//       return Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//         ),
//         padding: EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Center(
//               child: Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Mua ngay "${food['name']}"?',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 24),
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: () => Navigator.pop(context),
//                     style: OutlinedButton.styleFrom(
//                       padding: EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       side: BorderSide(color: Colors.green),
//                     ),
//                     child: Text(
//                       'Hủy',
//                       style: TextStyle(color: Colors.green, fontSize: 16),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   flex: 2,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       padding: EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       elevation: 0,
//                     ),
//                     onPressed: () {
//                       Navigator.pop(context);
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => CheckoutPage()),
//                       );
//                     },
//                     child: Text(
//                       'Thanh toán ngay',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
//           ],
//         ),
//       );
//     },
//   );
// }

class AddToCartBottomSheet extends StatefulWidget {
  final Map<String, dynamic> food;

  const AddToCartBottomSheet({Key? key, required this.food}) : super(key: key);

  @override
  _AddToCartBottomSheetState createState() => _AddToCartBottomSheetState();
}

class _AddToCartBottomSheetState extends State<AddToCartBottomSheet> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final food = widget.food;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'images/${food['image']}',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[300],
                    child: Icon(Icons.fastfood),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food['name'],
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${food['price']}',
                      style: TextStyle(fontSize: 16, color: Colors.orange, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove, color: Colors.orange),
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                            });
                          }
                        },
                      ),
                      Text(
                        '$quantity',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
                      ),
                      IconButton(
                        icon: Icon(Icons.add, color: Colors.orange),
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartPage()),
                    );
                  },
                  child: Text(
                    'Thêm vào giỏ hàng',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
