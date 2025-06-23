import 'package:flutter/material.dart';
import '../ favourite/favourite.dart';
import '../../controllers/product_controller.dart';
import '../../models/home/product_model.dart';
import '../../utils/dimensions.dart';
import 'product_detail_screen.dart';

class FoodListPage extends StatefulWidget {
  final int? categoryIndex;
  final String? categoryName;
  final String? keyword;

  const FoodListPage({
    this.categoryIndex,
    this.categoryName,
    this.keyword,
    Key? key,
  }) : super(key: key);

  @override
  _FoodListPageState createState() => _FoodListPageState();
}

class _FoodListPageState extends State<FoodListPage> {
  List<ProductModel> products = [];
  final Set<int> favorites = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      if (widget.keyword != null) {
        products = await ProductController.searchProducts(widget.keyword!);
      } else if (widget.categoryIndex != null) {
        products = await ProductController.getByCategory(widget.categoryIndex!);
      }
      setState(() => isLoading = false);
    } catch (e) {
      print('Lỗi khi tải sản phẩm: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.keyword ?? widget.categoryName ?? 'Danh sách món ăn'),
        leading: BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
        padding: EdgeInsets.all(Dimensions.width15),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: Dimensions.width15,
          mainAxisSpacing: Dimensions.height15,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (context, index) {
          final food = products[index];
          final isFavorite = favorites.contains(food.id);

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailScreen(product: food.toJson()),
                ),
              );
            },

            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Dimensions.radius15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image + Favorite
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Dimensions.radius15),
                          topRight: Radius.circular(Dimensions.radius15),
                        ),
                        child: Image.network(
                          food.hinhAnh,
                          height: Dimensions.screenHeight * 0.15,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: Dimensions.height8,
                        right: Dimensions.width8,
                        child: GestureDetector(
                          onTap: () {
                            // Chuyển đến trang yêu thích
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FavoritePage(
                                    favoriteProducts: favoriteProducts),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(Dimensions.height5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                )
                              ],
                            ),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.red,
                              size: Dimensions.iconSize20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Info
                  Padding(
                    padding: EdgeInsets.all(Dimensions.width10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            food.ten,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Dimensions.font16,
                            ),
                          ),
                        ),
                        SizedBox(height: Dimensions.height5),
                        Text(
                          '${food.gia.toInt()}đ',
                          style: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold,
                            fontSize: Dimensions.font14,
                          ),
                        ),
                        SizedBox(height: Dimensions.height5),
                        Row(
                          children: [
                            Icon(Icons.star,
                                size: 16, color: Colors.amber),
                            SizedBox(width: 4),
                            Text(food.danhGia.toStringAsFixed(1)),
                          ],
                        ),
                      ],
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
