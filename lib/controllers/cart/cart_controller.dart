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

  /// Load giỏ hàng của người dùng
  Future<void> loadCart(String userId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      _cartItems = await CartService.fetchCart(userId);
    } catch (e) {
      error = "Không thể tải giỏ hàng: $e";
      _cartItems = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Thêm sản phẩm vào giỏ
  Future<void> addProduct(String userId, ProductModel product) async {
    try {
      await CartService.addToCart(userId, product);
      await loadCart(userId);
    } catch (e) {
      error = "Không thể thêm sản phẩm: $e";
      notifyListeners();
    }
  }

  /// Cập nhật số lượng sản phẩm
  Future<void> updateQuantity(String itemId, int quantity, String userId) async {
    try {
      await CartService.updateQuantity(itemId, quantity);
      await loadCart(userId);
    } catch (e) {
      error = "Không thể cập nhật số lượng: $e";
      notifyListeners();
    }
  }

  /// Xoá sản phẩm khỏi giỏ
  Future<void> removeItem(String itemId, String userId) async {
    try {
      await CartService.removeCartItem(itemId);
      await loadCart(userId);
    } catch (e) {
      error = "Không thể xoá sản phẩm: $e";
      notifyListeners();
    }
  }
}
