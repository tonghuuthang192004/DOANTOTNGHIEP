import 'package:flutter/material.dart';
import '../../models/cart/cart_model.dart';
import '../../models/product/product_model.dart';
import '../../services/cart/cart_service.dart';

class CartController extends ChangeNotifier {
  List<CartModel> _cartItems = [];
  List<CartModel> get cartItems => _cartItems;

  bool isLoading = false;
  String? error;

  double get subtotal => _cartItems.fold(
      0, (sum, item) => sum + ((item.product.gia ?? 0) * item.quantity));

  double get deliveryFee => 5.99;
  double get tax => subtotal * 0.08;
  double get total => subtotal + deliveryFee + tax;

  /// 🚚 Load giỏ hàng từ backend
  Future<void> loadCart() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      _cartItems = await CartService.fetchCart();
    } catch (e) {
      error = "❌ Không thể tải giỏ hàng: $e";
      _cartItems = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ➕ Thêm sản phẩm vào giỏ
  Future<void> addProduct(ProductModel product, {int quantity = 1}) async {
    try {
      // Kiểm tra nếu sản phẩm đã có trong giỏ
      final existingItem = _cartItems.firstWhere(
            (item) => item.product.id == product.id,
        orElse: () => CartModel(id: "", product: product, quantity: 0),
      );

      if (existingItem.id.isNotEmpty) {
        final newQuantity = existingItem.quantity + quantity;
        await CartService.updateQuantity(product.id.toString(), newQuantity);
      } else {
        await CartService.addToCart(product, quantity: quantity);
      }

      await loadCart();
    } catch (e) {
      error = "❌ Không thể thêm sản phẩm: $e";
      notifyListeners();
    }
  }

  /// 🔁 Cập nhật số lượng
  Future<void> updateQuantity(String productId, int quantity) async {
    try {
      await CartService.updateQuantity(productId, quantity);
      await loadCart();
    } catch (e) {
      error = "❌ Không thể cập nhật số lượng: $e";
      notifyListeners();
    }
  }

  /// ❌ Xoá 1 sản phẩm
  Future<void> removeItem(String productId) async {
    try {
      await CartService.removeCartItem(productId);
      await loadCart();
    } catch (e) {
      error = "❌ Không thể xoá sản phẩm: $e";
      notifyListeners();
    }
  }

  /// 🧹 Xoá toàn bộ giỏ hàng
  Future<void> clearCart() async {
    try {
      await CartService.clearCart();
      _cartItems.clear();
      notifyListeners();
    } catch (e) {
      error = "❌ Không thể xoá toàn bộ giỏ hàng: $e";
      notifyListeners();
    }
  }
}
