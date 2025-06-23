import 'package:flutter/material.dart';
import '../../utils/dimensions.dart';

class PromotionProduct {
  final String id;
  final String name;
  final String description;
  final double originalPrice;
  final double discountedPrice;
  final int discountPercentage;
  final String image;
  final String category;
  final DateTime endDate;
  final bool isFlashSale;
  final int soldCount;
  final int totalStock;

  PromotionProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercentage,
    required this.image,
    required this.category,
    required this.endDate,
    this.isFlashSale = false,
    this.soldCount = 0,
    this.totalStock = 100,
  });

  double get savedAmount => originalPrice - discountedPrice;
}

class PromotionPage extends StatefulWidget {
  @override
  State<PromotionPage> createState() => _PromotionPageState();
}

class _PromotionPageState extends State<PromotionPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<PromotionProduct> promotionProducts = [
    PromotionProduct(
      id: '1',
      name: 'Burger Bò Phô Mai',
      description: 'Burger bò tươi ngon với phô mai cheddar tan chảy',
      originalPrice: 89000,
      discountedPrice: 45000,
      discountPercentage: 50,
      image: 'images/fried_chicken.png',
      category: 'Burger',
      endDate: DateTime.now().add(Duration(hours: 6)),
      isFlashSale: true,
      soldCount: 45,
      totalStock: 100,
    ),
    PromotionProduct(
      id: '2',
      name: 'Pizza Hải Sản Cao Cấp',
      description: 'Pizza hải sản tươi ngon với tôm, mực, cua',
      originalPrice: 299000,
      discountedPrice: 199000,
      discountPercentage: 33,
      image: 'images/fried_chicken.png',
      category: 'Pizza',
      endDate: DateTime.now().add(Duration(days: 2)),
      isFlashSale: false,
      soldCount: 28,
      totalStock: 50,
    ),
    PromotionProduct(
      id: '3',
      name: 'Gà Rán Giòn Tan',
      description: 'Gà rán giòn tan thơm ngon với 11 loại gia vị bí mật',
      originalPrice: 159000,
      discountedPrice: 99000,
      discountPercentage: 38,
      image: 'images/fried_chicken.png',
      category: 'Gà',
      endDate: DateTime.now().add(Duration(days: 1)),
      isFlashSale: false,
      soldCount: 67,
      totalStock: 80,
    ),
    PromotionProduct(
      id: '4',
      name: 'Combo Gia Đình',
      description: '2 Burger + 1 Pizza + 4 Nước ngọt + Khoai tây chiên',
      originalPrice: 450000,
      discountedPrice: 299000,
      discountPercentage: 34,
      image: 'images/fried_chicken.png',
      category: 'Combo',
      endDate: DateTime.now().add(Duration(days: 5)),
      isFlashSale: false,
      soldCount: 15,
      totalStock: 30,
    ),
    PromotionProduct(
      id: '5',
      name: 'Sandwich Thịt Nướng',
      description: 'Sandwich thịt nướng BBQ với rau tươi và sốt đặc biệt',
      originalPrice: 65000,
      discountedPrice: 39000,
      discountPercentage: 40,
      image: 'images/fried_chicken.png',
      category: 'Sandwich',
      endDate: DateTime.now().add(Duration(hours: 18)),
      isFlashSale: true,
      soldCount: 89,
      totalStock: 120,
    ),
  ];

  List<String> categories = [
    'Tất cả',
    'Flash Sale',
    'Burger',
    'Pizza',
    'Gà',
    'Combo'
  ];
  String selectedCategory = 'Tất cả';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  List<PromotionProduct> getFilteredProducts() {
    if (selectedCategory == 'Tất cả') {
      return promotionProducts;
    } else if (selectedCategory == 'Flash Sale') {
      return promotionProducts.where((p) => p.isFlashSale).toList();
    } else {
      return promotionProducts
          .where((p) => p.category == selectedCategory)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  _buildFlashSaleSection(),
                  _buildCategoryTabs(),
                  _buildProductGrid(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.orange,
      expandedHeight: 120,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: EdgeInsets.only(
            top: kToolbarHeight + 20,
            left: 16,
            right: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Khuyến Mãi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // SizedBox(height: 12),
              // Container(
              //   height: 40,
              //   padding: EdgeInsets.symmetric(horizontal: 12),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(20),
              //   ),
              //   child: Row(
              //     children: [
              //       Icon(Icons.search, color: Colors.grey),
              //       SizedBox(width: 8),
              //       Expanded(
              //         child: TextField(
              //           decoration: InputDecoration(
              //             hintText: 'Tìm món khuyến mãi...',
              //             border: InputBorder.none,
              //             isDense: true,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildFlashSaleSection() {
    final flashSaleProducts =
        promotionProducts.where((p) => p.isFlashSale).toList();

    return Container(
      margin: EdgeInsets.all(Dimensions.width15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flash_on,
                  color: Colors.red, size: Dimensions.iconSize24),
              SizedBox(width: Dimensions.width10),
              Text(
                'Flash Sale',
                style: TextStyle(
                  fontSize: Dimensions.font20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width10,
                  vertical: Dimensions.height10 / 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                ),
                child: Text(
                  'Kết thúc trong 6h',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.8,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height15),
          Container(
            height: Dimensions.screenHeight * 0.28,
            clipBehavior: Clip.hardEdge, // ẩn phần tràn
            decoration: BoxDecoration(), // cần thiết để clip hoạt động
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: flashSaleProducts.length,
              itemBuilder: (context, index) {
                return _buildFlashSaleCard(flashSaleProducts[index]);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFlashSaleCard(PromotionProduct product) {
    double progress = product.soldCount / product.totalStock;

    return Container(
      width: Dimensions.screenWidth * 0.5,
      margin: EdgeInsets.only(right: Dimensions.width15),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Ảnh sản phẩm (bo góc trên)
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(Dimensions.radius20),
                  ),
                  child: Image.asset(
                    product.image,
                    height: Dimensions.screenHeight * 0.12,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    // Hiển thị toàn bộ ảnh, không cắt, giữ tỉ lệ
                    alignment: Alignment.center,
                  ),
                ),

                // Nhãn giảm giá
                Positioned(
                  top: Dimensions.height10,
                  left: Dimensions.width10,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width10,
                      vertical: Dimensions.height10 / 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                    ),
                    child: Text(
                      '-${product.discountPercentage}%',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.8,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(Dimensions.width10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: Dimensions.font16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: Dimensions.height10),
                  Row(
                    children: [
                      Text(
                        '${(product.discountedPrice / 1000).toInt()}k',
                        style: TextStyle(
                          fontSize: Dimensions.font16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(width: Dimensions.width10),
                      Text(
                        '${(product.originalPrice / 1000).toInt()}k',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.8,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height10),
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.orange, Colors.red],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.height10 / 2),
                  Text(
                    'Đã bán ${product.soldCount}/${product.totalStock}',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.7,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimensions.width15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Danh mục khuyến mãi',
            style: TextStyle(
              fontSize: Dimensions.font16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: Dimensions.height15),
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: Dimensions.width10),
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width20,
                      vertical: Dimensions.height10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.orange : Colors.white,
                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                      border: Border.all(
                        color: isSelected ? Colors.orange : Colors.grey[300]!,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: Dimensions.font16,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    final filteredProducts = getFilteredProducts();

    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: filteredProducts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: Dimensions.width10,
        mainAxisSpacing: Dimensions.height10,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(Dimensions.radius15)),
                    color: Colors.grey[200],
                  ),
                  child: Center(
                    child: Image.asset(
                      product.image,
                      height: Dimensions.screenHeight * 0.12,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      // Hiển thị toàn bộ ảnh, không cắt, giữ tỉ lệ
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(Dimensions.width10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: Dimensions.font16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: Dimensions.height10 / 2),
                    Row(
                      children: [
                        Text(
                          '${(product.discountedPrice / 1000).toInt()}k',
                          style: TextStyle(
                            fontSize: Dimensions.font16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(width: Dimensions.width10),
                        Text(
                          '${(product.originalPrice / 1000).toInt()}k',
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.8,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget _buildProductCard(PromotionProduct product) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Dimensions.radius20),
    ),
    elevation: 4,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: Dimensions.screenHeight * 0.15,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(Dimensions.radius20)),
            color: Colors.grey[200],
          ),
          child: Center(
            child: Icon(
              Icons.fastfood,
              size: Dimensions.iconSize24 * 2,
              color: Colors.grey,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(Dimensions.width10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: Dimensions.height10 / 2),
              Row(
                children: [
                  Text(
                    '${(product.discountedPrice / 1000).toInt()}k',
                    style: TextStyle(
                      fontSize: Dimensions.font16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(width: Dimensions.width10),
                  Text(
                    '${(product.originalPrice / 1000).toInt()}k',
                    style: TextStyle(
                      fontSize: Dimensions.font14,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height10 / 2),
              Text(
                'Giảm ${product.discountPercentage}%',
                style: TextStyle(
                  fontSize: Dimensions.font14,
                  color: Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
