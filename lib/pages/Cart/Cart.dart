import 'dart:math';
import 'package:flutter/material.dart';

// Màu sắc sử dụng
const kbgColor = Color(0xFFF5F5F5);
const kblack = Colors.black;
const korange = Colors.deepOrange;
const kpink = Colors.pink;
const kyellow = Colors.amber;

// Model sản phẩm
class ProductModel {
  final String name;
  final double price;
  final double rate;
  final String image;
  final int distance;

  ProductModel({
    required this.name,
    required this.price,
    required this.rate,
    required this.image,
    required this.distance,
  });
}

// Model giỏ hàng
class CartModel {
  final ProductModel productModel;
  int quantity;

  CartModel({required this.productModel, required this.quantity});
}

// Màn hình giỏ hàng chính
class CartPage extends StatefulWidget {
  const CartPage({super.key});
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartModel> carts = [
    CartModel(
      productModel: ProductModel(
        name: "Pizza Margherita",
        price: 12.99,
        rate: 4.5,
        image: "images/Pizza.png",
        distance: 800,
      ),
      quantity: 2,
    ),
    CartModel(
      productModel: ProductModel(
        name: "Burger Deluxe",
        price: 9.49,
        rate: 4.2,
        image: "images/Burger.png",
        distance: 500,
      ),
      quantity: 1,
    ),
  ];

  double get totalCart => carts.fold(
      0, (sum, item) => sum + item.productModel.price * item.quantity);

  void addCart(ProductModel product) {
    setState(() {
      final index =
      carts.indexWhere((element) => element.productModel.name == product.name);
      if (index != -1) carts[index].quantity += 1;
    });
  }

  void reduceQuantity(ProductModel product) {
    setState(() {
      final index =
      carts.indexWhere((element) => element.productModel.name == product.name);
      if (index != -1 && carts[index].quantity > 1) {
        carts[index].quantity -= 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbgColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  BackButton(color: kblack),
                  Text("My Cart",
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(width: 40),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: carts.length,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (context, index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(bottom: 20),
                    child: CartItem(
                      cart: carts[index],
                      onAdd: () => addCart(carts[index].productModel),
                      onReduce: () => reduceQuantity(carts[index].productModel),
                    ),
                  );
                },
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Text("Delivery",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      Spacer(),
                      Text("\$5.99",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: korange)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text("Total",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Text(
                        "\$${totalCart.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: korange),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kblack,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      "Pay \$${(totalCart + 5.99).toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 18),
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
}

// Widget mỗi item trong giỏ hàng
class CartItem extends StatelessWidget {
  final CartModel cart;
  final VoidCallback onAdd;
  final VoidCallback onReduce;

  const CartItem({
    super.key,
    required this.cart,
    required this.onAdd,
    required this.onReduce,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image
          Padding(
            padding: const EdgeInsets.all(12),
            child: Transform.rotate(
              angle: 10 * pi / 180,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  cart.productModel.image,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 12, top: 12, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cart.productModel.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: kyellow, size: 18),
                      Text(cart.productModel.rate.toStringAsFixed(1)),
                      const SizedBox(width: 8),
                      Icon(Icons.location_on, color: kpink, size: 18),
                      Text("${cart.productModel.distance}m"),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${cart.productModel.price.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: korange),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: kblack.withOpacity(0.05),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: onReduce,
                              icon: const Icon(Icons.remove),
                              splashRadius: 18,
                            ),
                            Text(cart.quantity.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            IconButton(
                              onPressed: onAdd,
                              icon: const Icon(Icons.add),
                              splashRadius: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
