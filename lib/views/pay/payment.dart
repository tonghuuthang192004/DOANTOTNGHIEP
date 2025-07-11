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
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  String selectedPaymentMethod = 'momo';
  bool isProcessing = false;

  double subtotal = 0.0;
  double discountAmount = 0.0;
  double get totalAmount => (subtotal - discountAmount).clamp(0, double.infinity);

  List<CartModel> cartItems = [];
  DiscountModel? selectedDiscount;

  final Map<String, String> orderData = {
    'address': '',
    'note': '',
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _loadDefaultAddress();
    _loadCartData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadDefaultAddress() async {
    try {
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
      debugPrint('❌ Lỗi tải địa chỉ: $e');
    }
  }

  Future<void> _loadCartData() async {
    try {
      final cartList = await CartService.fetchCart();
      final newSubtotal = cartList.fold<double>(0.0, (sum, item) => sum + (item.product.gia * item.quantity));
      final newDiscount = selectedDiscount != null
          ? (selectedDiscount!.loai == 'phan_tram' ? newSubtotal * (selectedDiscount!.giaTri / 100) : selectedDiscount!.giaTri.toDouble())
          : 0.0;
      if (!mounted) return;
      setState(() {
        cartItems = cartList;
        subtotal = newSubtotal;
        discountAmount = newDiscount;
      });
    } catch (e) {
      debugPrint("❌ Lỗi khi load giỏ hàng: $e");
    }
  }

  Future<void> _selectDiscount() async {
    final userId = await UserSession.getUserId();
    if (userId == null) return;

    final selected = await Navigator.push<DiscountModel?>(context, MaterialPageRoute(builder: (_) => SavedDiscountPage(userId: userId, isSelectionMode: true)));
    if (selected != null && mounted) {
      setState(() {
        selectedDiscount = selected;
        discountAmount = selected.loai == 'phan_tram' ? subtotal * (selected.giaTri / 100) : selected.giaTri.toDouble();
      });
    }
  }

  Future<void> _handlePlaceOrder() async {
    if ((orderData['address'] ?? '').isEmpty) {
      _showErrorSnack("⚠️ Vui lòng nhập địa chỉ giao hàng");
      return;
    }

    if (cartItems.isEmpty) {
      _showErrorSnack("⚠️ Giỏ hàng trống");
      return;
    }

    setState(() => isProcessing = true);

    try {
      final addresses = await AddressController().getAddresses();
      final address = addresses.firstWhere(
            (e) => e.address == orderData['address'],
        orElse: () => throw Exception('❌ Không tìm thấy địa chỉ'),
      );

      final result = await OrderService.checkout(
        addressId: address.id,
        paymentMethod: selectedPaymentMethod,
        note: orderData['note']?.trim(),
      );

      debugPrint("✅ Backend Response: ${result.toString()}");

      final orderId = result['orderId'];
      final message = result['message'];

      // Kiểm tra mã trạng thái của phản hồi
      if (result['status'] == 200 && result['status'] == 201) {
        _showErrorSnack("❌ ${message ?? 'Có lỗi xảy ra khi tạo đơn hàng'}");
        return;
      }

      debugPrint('✅ Đặt hàng thành công. ID đơn: $orderId');

      if (selectedPaymentMethod == 'momo') {
        final payUrl = result['payUrl'];
        if (payUrl != null && mounted) {
          final paymentResult = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => WebViewPaymentPage(url: payUrl)),
          );
          if (paymentResult == true) {
            await CartService.clearCart();
            _showSuccessDialog("✅ Thanh toán MoMo thành công");
            await CartService.clearCart();
          } else {
            _showErrorSnack("❌ Thanh toán bị hủy hoặc thất bại");
          }
        } else {
          _showErrorSnack("❌ Không thể tạo thanh toán MoMo");
        }
      } else if (selectedPaymentMethod == 'cod') {
        _showSuccessDialog(message ?? 'Đặt hàng thành công.Chúng tôi sẽ chuẩn bị hàng nhanh nhất.Chúc Ban Ngon Miệng ');
        await CartService.clearCart();
      }
    } catch (e) {
      debugPrint("❌ Lỗi khi đặt hàng: $e");
      _showErrorSnack("❌ ${e.toString()}");
    } finally {
      if (mounted) setState(() => isProcessing = false);
    }
  }

  void _showSuccessSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green, // Màu nền cho thông báo thành công
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }

  void _showErrorSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Bo góc đẹp
        ),
        backgroundColor: Colors.green[50], // Màu nền nhẹ nhàng
        title: Text(
          "Thành công",
          style: TextStyle(
            fontSize: 24, // Chỉnh font size tiêu đề
            fontWeight: FontWeight.bold, // Đậm cho tiêu đề
            color: Colors.green[800], // Màu sắc cho tiêu đề
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 16, // Kích thước chữ cho thông điệp
            color: Colors.black87, // Màu chữ thông điệp
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const MainNavigation()),
                    (route) => false,
              );
            },
            child: Text(
              "OK",
              style: TextStyle(
                color: Colors.green[700], // Màu chữ cho nút OK
                fontSize: 18, // Kích thước chữ
              ),
            ),
          ),
        ],
      ),
    );
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
        paymentMethodName: selectedPaymentMethod == 'momo' ? 'Ví MoMo' : 'COD',
        paymentMethodIcon: selectedPaymentMethod == 'momo'
            ? Icons.account_balance_wallet
            : Icons.money,
        paymentColor: selectedPaymentMethod == 'momo' ? Colors.pink : Colors.orange,
        paymentBgColor: selectedPaymentMethod == 'momo'
            ? Colors.pink.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
      ),
    );
  }
}
