import 'dart:math';
import 'package:flutter/material.dart';

import '../../utils/dimensions.dart';
import '../pay/payment.dart';

// Màu sắc sử dụng
const kbgColor = Color(0xFFF8F9FA);
const kblack = Colors.black;
const korange = Color(0xFFFF6B35);
const kpink = Color(0xFFE91E63);
const kyellow = Color(0xFFFFC107);
const kgrey = Color(0xFF9E9E9E);
const klightGrey = Color(0xFFF5F5F5);
const kgreen = Color(0xFF4CAF50);

// Model sản phẩm
class ProductModel1 {
  final String name;
  final double price;
  final double rate;
  final String image;
  final int distance;

  ProductModel1({
    required this.name,
    required this.price,
    required this.rate,
    required this.image,
    required this.distance,
  });
}

// Model giỏ hàng
class CartModel {
  final ProductModel1 productModel;
  int quantity;

  CartModel({required this.productModel, required this.quantity});
}

// Màn hình giỏ hàng chính
class CartPage extends StatefulWidget {
  const CartPage({super.key});
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  List<CartModel> carts = [
    CartModel(
      productModel: ProductModel1(
        name: "Pizza Margherita",
        price: 12.99,
        rate: 4.5,
        image: "images/fried_chicken.png",
        distance: 800,
      ),
      quantity: 2,
    ),
    CartModel(
      productModel: ProductModel1(
        name: "Burger Deluxe",
        price: 9.49,
        rate: 4.2,
        image: "images/fried_chicken.png",
        distance: 500,
      ),
      quantity: 1,
    ),
    CartModel(
      productModel: ProductModel1(
        name: "Sushi Set",
        price: 18.99,
        rate: 4.8,
        image: "images/fried_chicken.png",
        distance: 1200,
      ),
      quantity: 1,
    ),
  ];

  @override
  void initState() {
    super.initState();
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
    _animationController.dispose();
    super.dispose();
  }

  double get subtotal => carts.fold(
      0, (sum, item) => sum + item.productModel.price * item.quantity);

  double get deliveryFee => 5.99;
  double get tax => subtotal * 0.08; // 8% tax
  double get totalCart => subtotal + deliveryFee + tax;

  void addCart(ProductModel1 product) {
    setState(() {
      final index =
      carts.indexWhere((element) => element.productModel.name == product.name);
      if (index != -1) carts[index].quantity += 1;
    });
  }

  void reduceQuantity(ProductModel1 product) {
    setState(() {
      final index =
      carts.indexWhere((element) => element.productModel.name == product.name);
      if (index != -1 && carts[index].quantity > 1) {
        carts[index].quantity -= 1;
      }
    });
  }

  void removeItem(product) {
    setState(() {
      carts.removeWhere((element) => element.productModel.name == product.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbgColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: Column(
            children: [
              // Header cải tiến
              _buildHeader(context),

              // Thống kê giỏ hàng
              _buildCartSummary(),

              // Danh sách sản phẩm
              Expanded(
                child: carts.isEmpty
                    ? _buildEmptyCart()
                    : ListView.builder(
                  itemCount: carts.length,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (context, index) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(
                          index * 0.1,
                          1.0,
                          curve: Curves.easeOut,
                        ),
                      )),
                      child: CartItem(
                        cart: carts[index],
                        onAdd: () => addCart(carts[index].productModel),
                        onReduce: () => reduceQuantity(carts[index].productModel),
                        onRemove: () => removeItem(carts[index].productModel),
                      ),
                    );
                  },
                ),
              ),

              // Footer thanh toán cải tiến
              if (carts.isNotEmpty) _buildCheckoutSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // IconButton(
          //   onPressed: () => Navigator.pop(context),
          //   icon: const Icon(Icons.arrow_back_ios, color: kblack),
          //   style: IconButton.styleFrom(
          //     backgroundColor: klightGrey,
          //     padding: const EdgeInsets.all(12),
          //   ),
          // ),
          const Expanded(
            child: Text(
              "Giỏ hàng của tôi",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: kblack,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: korange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "${carts.length}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: korange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartSummary() {
    if (carts.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [korange.withOpacity(0.1), kpink.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: korange.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: korange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.local_offer, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Ưu đại đặc biệt!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: korange,
                  ),
                ),
                Text(
                  "Miễn phí giao hàng cho đơn từ \$30",
                  style: TextStyle(
                    fontSize: 12,
                    color: kgrey,
                  ),
                ),
              ],
            ),
          ),
          if (subtotal >= 30)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: kgreen,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "✓ Đủ điều kiện",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: klightGrey,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: kgrey,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Giỏ hàng trống",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kblack,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Hãy thêm một số món ăn vào giỏ hàng",
            style: TextStyle(
              fontSize: 14,
              color: kgrey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: korange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Khám phá menu"),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutSection() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -4),
          ),
        ],
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Chi tiết thanh toán
          _buildPriceRow("Tạm tính", subtotal),
          const SizedBox(height: 8),
          _buildPriceRow("Phí giao hàng", deliveryFee),
          const SizedBox(height: 8),
          _buildPriceRow("Thuế", tax),
          const Divider(height: 20),
          _buildPriceRow("Tổng cộng", totalCart, isTotal: true),

          const SizedBox(height: 20),

          // Nút thanh toán
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [korange, kpink],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: korange.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                // _showCheckoutDialog();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CheckoutPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.payment, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    "Thanh toán \$${totalCart.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? kblack : kgrey,
          ),
        ),
        Text(
          "\$${amount.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: FontWeight.bold,
            color: isTotal ? korange : kblack,
          ),
        ),
      ],
    );
  }

  void _showCheckoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: kgreen, size: 28),
            SizedBox(width: 8),
            Text("Xác nhận thanh toán"),
          ],
        ),
        content: Text(
          "Bạn có muốn thanh toán \$${totalCart.toStringAsFixed(2)} cho đơn hàng này không?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: korange,
              foregroundColor: Colors.white,
            ),
            child: const Text("Xác nhận"),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: kgreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 32),
            ),
            const SizedBox(height: 16),
            const Text(
              "Đặt hàng thành công!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Đơn hàng của bạn đang được xử lý",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  carts.clear();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kgreen,
                foregroundColor: Colors.white,
              ),
              child: const Text("OK"),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget mỗi item trong giỏ hàng cải tiến
class CartItem extends StatelessWidget {
  final CartModel cart;
  final VoidCallback onAdd;
  final VoidCallback onReduce;
  final VoidCallback onRemove;

  const CartItem({
    super.key,
    required this.cart,
    required this.onAdd,
    required this.onReduce,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(cart.productModel.name),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onRemove(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Hình ảnh sản phẩm
            Container(
              margin: const EdgeInsets.all(12),
              child: Hero(
                tag: cart.productModel.name,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [korange.withOpacity(0.1), kpink.withOpacity(0.1)],
                    ),
                  ),
                  child: Transform.rotate(
                    angle: 5 * pi / 180,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        cart.productModel.image,
                        fit: BoxFit.contain, // Hiển thị toàn bộ ảnh, không cắt, giữ tỉ lệ
                        alignment: Alignment.center, // Ảnh canh giữa trong khung
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Thông tin sản phẩm
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12, top: 12, bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            cart.productModel.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kblack,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: onRemove,
                          icon: const Icon(Icons.close, size: 20),
                          style: IconButton.styleFrom(
                            backgroundColor: klightGrey,
                            padding: const EdgeInsets.all(4),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Rating và khoảng cách
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: kyellow.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, color: kyellow, size: 14),
                              const SizedBox(width: 2),
                              Text(
                                cart.productModel.rate.toStringAsFixed(1),
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: kpink.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.location_on, color: kpink, size: 14),
                              const SizedBox(width: 2),
                              Text(
                                "${cart.productModel.distance}m",
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Giá và điều khiển số lượng
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "\$${cart.productModel.price.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: korange,
                              ),
                            ),
                            Text(
                              "x${cart.quantity} = \$${(cart.productModel.price * cart.quantity).toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 12,
                                color: kgrey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        // Điều khiển số lượng
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: klightGrey,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildQuantityButton(
                                Icons.remove,
                                onReduce,
                                cart.quantity <= 1,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  cart.quantity.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              _buildQuantityButton(Icons.add, onAdd, false),
                            ],
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
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed, bool disabled) {
    return Material(
      color: disabled ? klightGrey : korange.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: disabled ? null : onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 18,
            color: disabled ? kgrey : korange,
          ),
        ),
      ),
    );
  }
}