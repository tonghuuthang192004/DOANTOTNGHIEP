import 'package:flutter/material.dart';

import '../../models/cart/cart_model.dart';
import '../../models/product/product_model.dart';
import '../../services/cart/cart_service.dart';
import '../../utils/dimensions.dart';

import '../pay/payment.dart';
import 'cart_empty_widget.dart';
import 'cart_header_widget.dart';
import 'cart_item_widget.dart';
import 'cart_summary_widget.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  List<CartModel> carts = [];

  bool isLoading = false;
  String? error;

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

    _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final items = await CartService.fetchCart();
      setState(() => carts = items);
    } catch (e) {
      setState(() => error = 'Lỗi kết nối hoặc máy chủ không phản hồi.\nChi tiết: ${e.toString()}');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _add(ProductModel product) async {
    try {
      await CartService.addToCart(product);
      _loadCart();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi thêm vào giỏ: $e')),
      );
    }
  }

  void _reduce(CartModel cart) async {
    if (cart.quantity > 1) {
      await CartService.updateQuantity(cart.id.toString(), cart.quantity - 1);
      _loadCart();
    }
  }

  void _remove(CartModel cart) async {
    await CartService.removeCartItem(cart.id.toString());
    _loadCart();
  }

  double get subtotal =>
      carts.fold(0, (sum, item) {
        final price = item.product.gia;
        final quantity = item.quantity;
        final validPrice = price > 0 ? price : 0;
        return sum + validPrice * quantity;
      });


  double get total => subtotal < 0 ? 0 : subtotal;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : error != null
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 60),
                const SizedBox(height: 10),
                const Text(
                  'Không thể tải giỏ hàng 😢',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _loadCart,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Thử lại"),
                ),
              ],
            ),
          )
              : Column(
            children: [
              CartHeader(
                itemCount: carts.length,
                onClearAll: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Xác nhận'),
                      content: const Text('Bạn có chắc muốn xoá toàn bộ giỏ hàng?'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Huỷ')),
                        ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Xoá')),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    setState(() => isLoading = true);
                    try {
                      await CartService.clearCart();
                      await _loadCart();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Lỗi khi xoá giỏ hàng: $e')),
                      );
                    } finally {
                      setState(() => isLoading = false);
                    }
                  }
                },
              ),
              SizedBox(height: Dimensions.height20),
              Expanded(
                child: carts.isEmpty
                    ? const CartEmptyState()
                    : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                  itemCount: carts.length,
                  itemBuilder: (context, index) {
                    final cartItem = carts[index];
                    return CartItem(
                      context: context,
                      cart: cartItem,
                      onAdd: () => _add(cartItem.product),
                      onReduce: () => _reduce(cartItem),
                      onRemove: () => _remove(cartItem),
                    );
                  },
                ),
              ),
              if (carts.isNotEmpty)
                CartSummary(
                  totalCart: total,
                  onCheckout: () {
                    // TODO: Điều hướng đến màn hình thanh toán
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CheckoutPage()),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
