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
      0, (sum, item) => sum + item.product.gia * item.quantity);

  double get deliveryFee => 5.99;
  double get tax => subtotal * 0.08;
  double get total => subtotal + deliveryFee + tax;

  /// 🚚 Load giỏ hàng của người dùng (userId được lấy từ session bên trong service)
  Future<void> loadCart() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      _cartItems = await CartService.fetchCart();
    } catch (e) {
      error = "Không thể tải giỏ hàng: $e";
      _cartItems = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ➕ Thêm sản phẩm vào giỏ
  Future<void> addProduct(ProductModel product) async {
    try {
      CartModel? existingItem;
      try {
        existingItem = _cartItems.firstWhere((item) => item.product.id == product.id);
      } catch (e) {
        existingItem = null;
      }

      if (existingItem != null) {
        final newQuantity = existingItem.quantity + 1;
        await CartService.updateQuantity(existingItem.id.toString(), newQuantity);
      } else {
        await CartService.addToCart(product);
      }

      await loadCart(); // Reload lại giỏ hàng
    } catch (e) {
      error = "Không thể thêm sản phẩm: $e";
      notifyListeners();
    }
  }

  /// 🔁 Cập nhật số lượng sản phẩm
  Future<void> updateQuantity(String itemId, int quantity) async {
    try {
      await CartService.updateQuantity(itemId, quantity);
      await loadCart();
    } catch (e) {
      error = "Không thể cập nhật số lượng: $e";
      notifyListeners();
    }
  }

  /// ❌ Xoá sản phẩm khỏi giỏ
  Future<void> removeItem(String itemId) async {
    try {
      await CartService.removeCartItem(itemId);
      await loadCart();
    } catch (e) {
      error = "Không thể xoá sản phẩm: $e";
      notifyListeners();
    }
  }
}
