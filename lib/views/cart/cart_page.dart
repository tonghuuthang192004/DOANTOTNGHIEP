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

  List<CartModel> cartItems = [];
  bool isLoading = false;
  String? error;

  double get subtotal => cartItems.fold(
      0.0, (sum, item) => sum + (item.product.gia * item.quantity));
  double get deliveryFee => 0.0;
  double get tax => subtotal * 0.0;
  double get total => subtotal + deliveryFee + tax;

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
    if (!mounted) return;
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final items = await CartService.fetchCart();
      if (!mounted) return;
      setState(() => cartItems = items);
    } catch (e) {
      if (!mounted) return;
      setState(() => error = "❌ Không thể tải giỏ hàng: $e");
    } finally {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  Future<void> _changeQuantity(CartModel cart, int newQuantity) async {
    try {
      if (newQuantity <= 0) {
        await _remove(cart);
      } else {
        await CartService.updateQuantity(
            cart.product.id.toString(), newQuantity);
        await _loadCart();
      }
    } catch (e) {
      _showError('❌ Lỗi cập nhật số lượng: $e');
    }
  }

  Future<void> _remove(CartModel cart) async {
    try {
      await CartService.removeCartItem(cart.product.id.toString());
      await _loadCart();
    } catch (e) {
      _showError('❌ Lỗi xoá sản phẩm: $e');
    }
  }

  Future<void> _clearCart() async {
    if (!mounted) return;
    setState(() => isLoading = true);
    try {
      await CartService.clearCart();
      await _loadCart();
    } catch (e) {
      _showError('❌ Lỗi xoá toàn bộ giỏ hàng: $e');
    } finally {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

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
                const Icon(Icons.error,
                    color: Colors.red, size: 60),
                const SizedBox(height: 10),
                Text(
                  'Không thể tải giỏ hàng 😢',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
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
                itemCount: cartItems.length,
                onClearAll: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Xác nhận'),
                      content: const Text(
                          'Bạn có chắc muốn xoá toàn bộ giỏ hàng?'),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context, false),
                          child: const Text('Huỷ'),
                        ),
                        ElevatedButton(
                          onPressed: () =>
                              Navigator.pop(context, true),
                          child: const Text('Xoá'),
                        ),
                      ],
                    ),
                  );
                  if (confirmed == true) {
                    await _clearCart();
                  }
                },
              ),
              SizedBox(height: Dimensions.height20),
              Expanded(
                child: cartItems.isEmpty
                    ? const CartEmptyState()
                    : ListView.builder(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width20),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartItems[index];
                    return CartItem(
                      cart: cartItem,
                      onAdd: () => _changeQuantity(
                          cartItem, cartItem.quantity + 1),
                      onReduce: () => _changeQuantity(
                          cartItem, cartItem.quantity - 1),
                      onRemove: () => _remove(cartItem),
                    );
                  },
                ),
              ),
              if (cartItems.isNotEmpty)
                CartSummary(
                  totalCart: total,
                  onCheckout: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CheckoutPage(),
                      ),
                    ).then((_) => _loadCart());
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
