import 'package:flutter/material.dart';

import '../ favourite/favourite.dart';
import '../../utils/dimensions.dart';
import '../Cart/Cart.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? product;

  const ProductDetailScreen({Key? key, this.product}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  String selectedSize = 'Medium';
  List<String> selectedExtras = [];

  final List<String> sizes = ['Small', 'Medium', 'Large'];
  final List<Map<String, dynamic>> extras = [
    {
      'name': 'Extra Cheese',
      'price': 1.50,
      'image': 'images/fried_chicken.png'
    },
    {'name': 'Bacon', 'price': 2.00, 'image': 'images/fried_chicken.png'},
    {'name': 'Avocado', 'price': 1.75, 'image': 'images/fried_chicken.png'},
    {'name': 'Pickles', 'price': 0.50, 'image': 'images/fried_chicken.png'},
  ];

  final List<Map<String, dynamic>> relatedProducts = [
    {
      'name': 'Classic Burger',
      'price': 9.99,
      'image': 'images/fried_chicken.png',
      'rating': 4.5
    },
    {
      'name': 'Chicken Wings',
      'price': 12.99,
      'image': 'images/fried_chicken.png',
      'rating': 4.7
    },
    {
      'name': 'French Fries',
      'price': 4.99,
      'image': 'images/fried_chicken.png',
      'rating': 4.3
    },
    {
      'name': 'Onion Rings',
      'price': 5.99,
      'image': 'images/fried_chicken.png',
      'rating': 4.4
    },
  ];

  double getBasePrice() {
    if (widget.product != null) {
      switch (selectedSize) {
        case 'Small':
          return (widget.product!['price'] ?? 10.99) * 0.8;
        case 'Medium':
          return widget.product!['price'] ?? 10.99;
        case 'Large':
          return (widget.product!['price'] ?? 10.99) * 1.2;
        default:
          return widget.product!['price'] ?? 10.99;
      }
    }

    switch (selectedSize) {
      case 'Small':
        return 8.99;
      case 'Medium':
        return 10.99;
      case 'Large':
        return 12.99;
      default:
        return 10.99;
    }
  }

  double getExtrasPrice() {
    double extrasTotal = 0;
    for (String extraName in selectedExtras) {
      final extra = extras.firstWhere((e) => e['name'] == extraName);
      extrasTotal += extra['price'];
    }
    return extrasTotal;
  }

  double getTotalPrice() {
    return (getBasePrice() + getExtrasPrice()) * quantity;
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // App Bar với hình ảnh sản phẩm
          SliverAppBar(
            expandedHeight: Dimensions.screenHeight * 0.35,
            pinned: true,
            backgroundColor: Colors.orange.shade600,
            leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: Colors.white,
                  size: Dimensions.iconSize20
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.favorite_border,
                    color: Colors.white,
                    size: Dimensions.iconSize20
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FavoritePage(favoriteProducts: favoriteProducts,)),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.orange.shade400,
                      Colors.orange.shade600,
                    ],
                  ),
                ),
                child: Center(
                  child: Container(
                    width: Dimensions.screenWidth * 0.5,
                    height: Dimensions.screenWidth * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(Dimensions.screenWidth * 0.25),
                    ),
                    child: widget.product != null && widget.product!['image'] != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.screenWidth * 0.25),
                      child: Image.asset(
                        widget.product!['image'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.fastfood,
                            size: Dimensions.iconSize30 * 2,
                            color: Colors.white.withOpacity(0.8),
                          );
                        },
                      ),
                    )
                        : Icon(
                      Icons.fastfood,
                      size: Dimensions.iconSize30 * 2,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Chi tiết sản phẩm
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(Dimensions.width20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên sản phẩm và đánh giá
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product?['name'] ?? 'Deluxe Cheeseburger',
                          style: TextStyle(
                            fontSize: Dimensions.font26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.width12,
                            vertical: Dimensions.height8
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(Dimensions.radius20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star,
                                color: Colors.amber.shade600,
                                size: Dimensions.iconSize16
                            ),
                            SizedBox(width: Dimensions.width5),
                            Text(
                              widget.product?['rating']?.toString() ?? '4.8',
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: Dimensions.font14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: Dimensions.height8),

                  // Giá
                  Text(
                    '\$${getBasePrice().toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: Dimensions.font22,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade600,
                    ),
                  ),

                  SizedBox(height: Dimensions.height15),

                  // Mô tả
                  Text(
                    widget.product?['description'] ??
                        'Juicy beef patty with melted cheese, fresh lettuce, tomatoes, onions, and our signature sauce on a toasted bun.',
                    style: TextStyle(
                      fontSize: Dimensions.font16,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: Dimensions.height25),

                  // Chọn số lượng
                  Text(
                    'Quantity',
                    style: TextStyle(
                      fontSize: Dimensions.font20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: Dimensions.height12),

                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(Dimensions.radius10),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: quantity > 1
                                  ? () => setState(() => quantity--)
                                  : null,
                              icon: Icon(Icons.remove, size: Dimensions.iconSize20),
                              color: Colors.orange.shade600,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.width15),
                              child: Text(
                                quantity.toString(),
                                style: TextStyle(
                                  fontSize: Dimensions.font18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => setState(() => quantity++),
                              icon: Icon(Icons.add, size: Dimensions.iconSize20),
                              color: Colors.orange.shade600,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Total: \$${getTotalPrice().toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: Dimensions.font20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade600,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: Dimensions.height30 + Dimensions.height10),

                  // Sản phẩm liên quan
                  Text(
                    'You might also like',
                    style: TextStyle(
                      fontSize: Dimensions.font20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: Dimensions.height15),

                  SizedBox(
                    height: Dimensions.screenHeight * 0.25,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: relatedProducts.length,
                      itemBuilder: (context, index) {
                        final product = relatedProducts[index];
                        return Container(
                          width: Dimensions.screenWidth * 0.4,
                          margin: EdgeInsets.only(right: Dimensions.width15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(Dimensions.radius15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(Dimensions.radius15)
                                ),
                                child: Image.asset(
                                  product['image'],
                                  height: Dimensions.screenHeight * 0.12,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: Dimensions.screenHeight * 0.12,
                                      color: Colors.grey.shade300,
                                      child: Icon(Icons.fastfood,
                                          size: Dimensions.iconSize30,
                                          color: Colors.grey
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(Dimensions.width12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product['name'],
                                      style: TextStyle(
                                        fontSize: Dimensions.font14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: Dimensions.height5),
                                    Row(
                                      children: [
                                        Icon(Icons.star,
                                            color: Colors.amber.shade600,
                                            size: Dimensions.font14
                                        ),
                                        SizedBox(width: Dimensions.width5),
                                        Text(
                                          product['rating'].toString(),
                                          style: TextStyle(
                                            fontSize: Dimensions.font14,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: Dimensions.height5),
                                    Text(
                                      '\$${product['price'].toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: Dimensions.font14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: Dimensions.height30 + Dimensions.height10),
                ],
              ),
            ),
          ),
        ],
      ),

      // Nút hành động ở dưới
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(Dimensions.width20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Hàng nút hành động
              Row(
                children: [
                  // Thêm vào giỏ hàng
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      // onPressed: () {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(
                      //       content: Text('Added $quantity item(s) to cart!'),
                      //       backgroundColor: Colors.green,
                      //     ),
                      //   );
                      // },
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CartPage()),
                        );
                      },
                      icon: Icon(Icons.shopping_cart_outlined,
                          size: Dimensions.iconSize16
                      ),
                      label: Text(
                        'Add \$${getTotalPrice().toStringAsFixed(2)}',
                        style: TextStyle(fontSize: Dimensions.font16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade600,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: Dimensions.height12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimensions.radius10),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: Dimensions.height12),

              // Nút mua ngay
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  // onPressed: () {
                  //   showDialog(
                  //     context: context,
                  //     builder: (BuildContext context) {
                  //       return AlertDialog(
                  //         title: Text(
                  //           'Confirm Purchase',
                  //           style: TextStyle(fontSize: Dimensions.font18),
                  //         ),
                  //         content: Text(
                  //           'Buy $quantity item(s) for \$${getTotalPrice().toStringAsFixed(2)}?',
                  //           style: TextStyle(fontSize: Dimensions.font16),
                  //         ),
                  //         actions: [
                  //           TextButton(
                  //             onPressed: () => Navigator.of(context).pop(),
                  //             child: Text(
                  //               'Cancel',
                  //               style: TextStyle(fontSize: Dimensions.font16),
                  //             ),
                  //           ),
                  //           ElevatedButton(
                  //             onPressed: () {
                  //               Navigator.of(context).pop();
                  //               ScaffoldMessenger.of(context).showSnackBar(
                  //                 const SnackBar(
                  //                   content: Text('Order placed successfully!'),
                  //                   backgroundColor: Colors.green,
                  //                 ),
                  //               );
                  //             },
                  //             style: ElevatedButton.styleFrom(
                  //               backgroundColor: Colors.green,
                  //               foregroundColor: Colors.white,
                  //             ),
                  //             child: Text(
                  //               'Confirm',
                  //               style: TextStyle(fontSize: Dimensions.font16),
                  //             ),
                  //           ),
                  //         ],
                  //       );
                  //     },
                  //   );
                  // },
                  // GestureDetector(
                  //   onTap: onAddToCart,
                  //   child: Container(
                  //     padding: EdgeInsets.all(8),
                  //     decoration: BoxDecoration(
                  //         color: Colors.orange,
                  //         borderRadius: BorderRadius.circular(12)),
                  //     child: Icon(Icons.add_shopping_cart,
                  //         color: Colors.white, size: 16),
                  //   ),
                  // ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartPage()),
                    );
                  },
                  icon: Icon(Icons.payment, size: Dimensions.iconSize16),
                  label: Text(
                    'Buy Now - \$${getTotalPrice().toStringAsFixed(2)}',
                    style: TextStyle(fontSize: Dimensions.font16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: Dimensions.height15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius10),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}