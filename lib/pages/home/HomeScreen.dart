import 'package:flutter/material.dart';
import 'package:frontendtn1/pages/home/popular_food_grid.dart';
import '../../models/Home/food_model.dart';
import '../../utils/dimensions.dart';
import '../Cart/Cart.dart';
import '../pay/payment.dart';
import '../product/list_food.dart';
import 'banner_promotion.dart';
import 'food_category_list.dart';
import 'home_header.dart';

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
        backgroundColor: Colors.grey[100], // Màu nền sáng nhẹ
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// --- Header ---
              HomeHeader(),

              SizedBox(height: Dimensions.height20),

              /// --- Banner ---
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                child: Text(
                  "Ưu đãi hôm nay",
                  style: TextStyle(
                    fontSize: Dimensions.font18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height10),
              BannerPromotion(),

              SizedBox(height: Dimensions.height30),

              /// --- Danh mục ---
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                child: Text(
                  "Danh mục",
                  style: TextStyle(
                    fontSize: Dimensions.font20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height15),
              FoodCategoryList(
                selectedIndex: selectedCategoryIndex,
                onCategorySelected: (index) {
                  setState(() => selectedCategoryIndex = index);

                  // Lấy tên danh mục từ danh sách
                  String selectedCategoryName = foodCategories[index]['name'];

                  // Điều hướng sang trang danh sách món ăn
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FoodListPage(
                        categoryIndex: index,
                        categoryName: selectedCategoryName,
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: Dimensions.height30),

              /// --- Dòng phân cách gọn gàng (nếu muốn thêm mục sản phẩm) ---
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                child: Divider(
                  color: Colors.grey[300],
                  thickness: 1,
                ),
              ),

              SizedBox(height: Dimensions.height20),
              // TODO: Hiển thị danh sách món ăn theo danh mục
              // --- Sản phẩm phổ biến ---
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                child: Text(
                  "Sản phẩm phổ biến",
                  style: TextStyle(
                    fontSize: Dimensions.font20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height15),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                child: PopularFoodGrid(
                  foods: [
                    {
                      'name': 'Burger Bò Phô Mai',
                      'price': 8.99,
                      'image': 'fried_chicken.png',
                      'rating': 4.5,
                    },
                    {
                      'name': 'Pizza Hải Sản',
                      'price': 12.99,
                      'image': 'fried_chicken.png',
                      'rating': 4.7,
                    },
                    {
                      'name': 'Gà Rán Giòn',
                      'price': 6.99,
                      'image': 'fried_chicken.png',
                      'rating': 4.3,
                    },
                    {
                      'name': 'Mì Ý Sốt Bò',
                      'price': 10.99,
                      'image': 'fried_chicken.png',
                      'rating': 4.4,
                    },
                  ],
                  onAddToCart: (context, food) {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (_) => AddToCartBottomSheet(food: food),
                    );
                  },
                ),
              ),

              SizedBox(height: Dimensions.height30),
            ],
          ),
        ),
      ),
    );
  }
}

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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${food['price']}',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.orange,
                          fontWeight: FontWeight.w600),
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
                            color: Colors.orange),
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
                        borderRadius: BorderRadius.circular(12)),
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
                        fontWeight: FontWeight.w600),
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
