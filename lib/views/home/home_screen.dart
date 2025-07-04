import 'package:flutter/material.dart';
import 'package:frontendtn1/views/home/food_category_list.dart';
import 'package:frontendtn1/views/home/popular_food_grid.dart';
import '../../controllers/category/category_controller.dart';
import '../../controllers/product/product_controller.dart';
import '../../models/category/category_model.dart';
import '../../models/product/product_model.dart';
import '../../utils/dimensions.dart';
import '../product/list_food.dart';
import 'banner_promotion.dart';
import 'home_header.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategoryIndex = 0;
  List<CategoryModel> categoryList = [];
  List<ProductModel> hotProducts = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadHotProducts();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await CategoryController.getCategories();
      if (!mounted) return;
      setState(() {
        categoryList = categories.cast<CategoryModel>();
      });
    } catch (e) {
      print('Lỗi tải danh mục: $e');
    }
  }

  Future<void> _loadHotProducts() async {
    try {
      final products = await ProductController.getHotProducts();
      if (!mounted) return;
      setState(() {
        hotProducts = products;
      });
    } catch (e) {
      print('Lỗi tải sản phẩm HOT: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              HomeHeader(),
              SizedBox(height: Dimensions.height20),

              /// Banner ưu đãi
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

              /// Danh mục
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

              categoryList.isEmpty
                  ? SizedBox(
                height: Dimensions.height100,
                child: Center(child: CircularProgressIndicator()),
              )
                  : FoodCategoryList(
                selectedIndex: selectedCategoryIndex,
                categories: categoryList,
                onCategorySelected: (category, index) {
                  setState(() => selectedCategoryIndex = index);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FoodListPage(
                        categoryIndex: category.id,
                        categoryName: category.ten ?? '',
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: Dimensions.height30),

              /// Divider
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                child: Divider(
                  color: Colors.grey[300],
                  thickness: 1,
                ),
              ),
              SizedBox(height: Dimensions.height20),

              /// Sản phẩm phổ biến
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
                child: hotProducts.isEmpty
                    ? SizedBox(
                  height: Dimensions.height100,
                  child: Center(child: CircularProgressIndicator()),
                )
                    : PopularFoodGrid(foods: hotProducts),
              ),

              SizedBox(height: Dimensions.height30),
            ],
          ),
        ),
      ),
    );
  }
}
