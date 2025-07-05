import 'package:flutter/material.dart';
import 'package:frontendtn1/views/pay/payment_method_section.dart';
import '../../services/cart/cart_service.dart';
import '../../services/order/order_service.dart';
import '../../utils/dimensions.dart';
import '../../widgets/bottom_navigation_bar.dart';
import '../promotion/saved_discount_page.dart';
import 'WebViewPaymentPage.dart';
import 'checkout_bottom_bar.dart';
import 'delivery_info_card.dart';
import 'order_summary_section.dart';
import '../../controllers/address/address_controller.dart';
import '../../services/user/user_session.dart';
import '../../models/discount/discount_model.dart';
import '../../models/cart/cart_model.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String selectedPaymentMethod = 'momo';
  bool isProcessing = false;

  double subtotal = 0;
  double discountAmount = 0;
  double get totalAmount => (subtotal - discountAmount).clamp(0, double.infinity);

  List<CartModel> cartItems = [];
  DiscountModel? selectedDiscount;

  Map<String, String> orderData = {
    'address': '',
    'note': '',
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _animationController.forward();

    _loadDefaultAddress();
    _loadCartData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadDefaultAddress() async {
    final userId = await UserSession.getUserId();
    if (userId == null) return;

    try {
      // Gọi getAddresses không truyền tham số nếu hàm không nhận userId
      final addressList = await AddressController().getAddresses();
      if (addressList.isNotEmpty) {
        final defaultAddress = addressList.firstWhere(
              (e) => e.isDefault,
          orElse: () => addressList.first,
        );

        if (!mounted) return;
        setState(() {
          orderData['address'] = defaultAddress.address;
        });
      }
    } catch (e) {
      print('❌ Lỗi tải địa chỉ: $e');
    }
  }

  Future<void> _loadCartData() async {
    final userId = await UserSession.getUserId();
    if (userId == null) return;

    try {
      final cartList = await CartService.fetchCart();

      double newSubtotal = cartList.fold(
        0,
            (sum, item) => sum + item.product.gia * item.quantity,
      );

      double newDiscount = 0;
      if (selectedDiscount != null) {
        if (selectedDiscount!.loai == 'phan_tram') {
          newDiscount = newSubtotal * (selectedDiscount!.giaTri / 100);
        } else {
          newDiscount = selectedDiscount!.giaTri.toDouble();
        }
      }

      if (!mounted) return;
      setState(() {
        cartItems = cartList;
        subtotal = newSubtotal;
        discountAmount = newDiscount;
      });
    } catch (e) {
      print("❌ Lỗi khi load giỏ hàng: $e");
    }
  }

  Future<void> _selectDiscount() async {
    final userId = await UserSession.getUserId();
    if (userId == null) return;

    final selected = await Navigator.push<DiscountModel?>(
      context,
      MaterialPageRoute(
        builder: (_) => SavedDiscountPage(userId: userId, isSelectionMode: true),
      ),
    );

    if (selected != null) {
      if (!mounted) return;
      setState(() {
        selectedDiscount = selected;
        if (selected.loai == 'phan_tram') {
          discountAmount = subtotal * (selected.giaTri / 100);
        } else {
          discountAmount = selected.giaTri.toDouble();
        }
      });
    }
  }

  Future<void> _handlePlaceOrder() async {
    if (orderData['address'] == null || orderData['address']!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Vui lòng nhập địa chỉ giao hàng")),
      );
      return;
    }

    setState(() => isProcessing = true);

    try {
      final userId = await UserSession.getUserId();
      if (userId == null) throw Exception('User chưa đăng nhập');

      // Lấy danh sách địa chỉ để tìm id theo địa chỉ đã chọn
      final addresses = await AddressController().getAddresses();
      final address = addresses.firstWhere((e) => e.address == orderData['address']);
      final addressId = address.id;

      // Tạo đơn hàng
      final int orderId = await OrderService.checkout(
        addressId: addressId,
        paymentMethod: selectedPaymentMethod,
        note: orderData['note']?.trim() ?? '',
      );

      // Lấy chi tiết đơn hàng để tính tổng tiền
      final orderDetail = await OrderService.fetchOrderDetail(orderId);
      final totalPrice = orderDetail.fold<double>(0, (sum, item) => sum + item.total);

      if (selectedPaymentMethod == 'momo') {
        final payUrl = await OrderService.createMomoPayment(orderId, totalPrice);
        if (payUrl != null && mounted) {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => WebViewPaymentPage(url: payUrl)),
          );

          if (result == true && mounted) {
            await CartService.clearCart();
            _showSuccessDialog("✅ Thanh toán MoMo thành công");
          }
        } else {
          _showErrorSnack("❌ Không thể tạo thanh toán MoMo");
        }
      } else if (selectedPaymentMethod == 'cod') {
        final codConfirmed = await OrderService.confirmCodPayment(orderId);
        if (codConfirmed && mounted) {
          _showSuccessDialog("✅ Đặt hàng COD thành công");
        } else {
          _showErrorSnack("❌ Xác nhận thanh toán COD thất bại");
        }
      }
    } catch (e) {
      print("❌ Lỗi khi đặt hàng: $e");
      _showErrorSnack("❌ ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() => isProcessing = false);
      }
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Thành công"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const MainNavigation()),
                    (route) => false,
              );
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showErrorSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Thanh toán', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(Dimensions.height20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DeliveryInfoSection(
                  note: orderData['note'] ?? '',
                  onNoteChanged: (value) => orderData['note'] = value,
                  onAddressChanged: (address) => orderData['address'] = address.address,
                ),
                SizedBox(height: Dimensions.height20),
                PaymentMethodSection(
                  paymentMethods: [
                    PaymentMethod(
                      id: 'momo',
                      name: 'Ví MoMo',
                      subtitle: 'Thanh toán qua ứng dụng MoMo',
                      icon: Icons.account_balance_wallet,
                      color: Colors.pink,
                      backgroundColor: Colors.pink.withOpacity(0.1),
                    ),
                    PaymentMethod(
                      id: 'cod',
                      name: 'Thanh toán khi nhận hàng',
                      subtitle: 'Trả tiền mặt khi giao hàng',
                      icon: Icons.money,
                      color: Colors.orange,
                      backgroundColor: Colors.orange.withOpacity(0.1),
                    ),
                  ],
                  selectedId: selectedPaymentMethod,
                  onSelected: (value) => setState(() => selectedPaymentMethod = value),
                ),
                SizedBox(height: Dimensions.height20),
                ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  title: Text(
                    selectedDiscount != null
                        ? '${selectedDiscount!.ten} - ${selectedDiscount!.ma}'
                        : 'Chọn mã giảm giá',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: selectedDiscount != null
                      ? Text(selectedDiscount!.loai == 'phan_tram'
                      ? 'Giảm ${selectedDiscount!.giaTri}%'
                      : 'Giảm ${selectedDiscount!.giaTri}đ')
                      : null,
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _selectDiscount,
                ),
                SizedBox(height: Dimensions.height20),
                OrderSummarySection(
                  subTotal: subtotal,
                  discount: discountAmount,
                  total: totalAmount,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CheckoutBottomBar(
        total: totalAmount,
        isProcessing: isProcessing,
        onPlaceOrder: _handlePlaceOrder,
        paymentMethodName: selectedPaymentMethod == 'momo' ? 'MoMo' : 'COD',
        paymentMethodIcon:
        selectedPaymentMethod == 'momo' ? Icons.account_balance_wallet : Icons.money,
        paymentColor: selectedPaymentMethod == 'momo' ? Colors.pink : Colors.orange,
        paymentBgColor: selectedPaymentMethod == 'momo'
            ? Colors.pink.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
      ),
    );
  }
}
