import 'package:flutter/material.dart';
import 'package:frontendtn1/pages/pay/payment.dart';

import '../../utils/dimensions.dart';
import '../../widgets/bottom_navigation_bar.dart';



// Payment Method Model
class PaymentMethod {
  final String id;
  final String name;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });
}

Map<String, dynamic> orderData = {
  'address': 'Nhà - 123 Đường Chính, Căn hộ 4B',
  'note': 'Giao giờ nghỉ trưa, gọi trước khi tới.',
};

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

  final List<PaymentMethod> paymentMethods = [
    PaymentMethod(
      id: 'momo',
      name: 'MoMo',
      subtitle: 'Ví điện tử MoMo',
      icon: Icons.account_balance_wallet,
      color: const Color(0xFFAE2070),
      backgroundColor: const Color(0xFFAE2070).withOpacity(0.1),
    ),
    PaymentMethod(
      id: 'bank',
      name: 'Ngân hàng',
      subtitle: 'Thẻ tín dụng/ghi nợ',
      icon: Icons.credit_card,
      color: const Color(0xFF2196F3),
      backgroundColor: const Color(0xFF2196F3).withOpacity(0.1),
    ),
    PaymentMethod(
      id: 'cash',
      name: 'Tiền mặt',
      subtitle: 'Thanh toán khi nhận hàng',
      icon: Icons.money,
      color: const Color(0xFF4CAF50),
      backgroundColor: const Color(0xFF4CAF50).withOpacity(0.1),
    ),
  ];

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
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(Dimensions.height20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDeliveryInfoCard(orderData['note'] ?? ''),
                SizedBox(height: Dimensions.height20),
                _buildPaymentMethodSection(),
                SizedBox(height: Dimensions.height20),
                _buildOrderSummarySection(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Thanh toán',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        style: IconButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(8),
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: const Color(0xFFF8F9FA),
      // actions: [
      //   Container(
      //     margin: const EdgeInsets.only(right: 16),
      //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      //     decoration: BoxDecoration(
      //       color: const Color(0xFF4CAF50).withOpacity(0.1),
      //       borderRadius: BorderRadius.circular(20),
      //     ),
      //     // child: const Text(
      //     //   'Bước 2/2',
      //     //   style: TextStyle(
      //     //     color: Color(0xFF4CAF50),
      //     //     fontWeight: FontWeight.bold,
      //     //     fontSize: 12,
      //     //   ),
      //     // ),
      //   ),
      // ],
    );
  }

  Widget _buildDeliveryInfoCard(String note) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isEditing = false;
        TextEditingController _noteController = TextEditingController(text: note);
        String currentNote = note;

        return Container(
          padding: EdgeInsets.all(Dimensions.height20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Phần địa chỉ giao hàng
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2196F3).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Color(0xFF2196F3),
                      size: 24,
                    ),
                  ),
                  SizedBox(width: Dimensions.width15),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Giao hàng tới',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Nhà - 123 Đường Chính, Căn hộ 4B',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {}, // Không cho sửa địa chỉ
                    icon: const Icon(Icons.edit, color: Colors.grey),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey.withOpacity(0.1),
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const Text(
                "Ghi chú:",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),

              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: isEditing ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                firstChild: Column(
                  children: [
                    TextField(
                      controller: _noteController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Nhập ghi chú...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              currentNote = _noteController.text;
                              isEditing = false;
                            });
                            // TODO: Gửi dữ liệu note mới lên server nếu cần
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                          icon: const Icon(Icons.check),
                          label: const Text("Lưu"),
                        ),
                        const SizedBox(width: 12),
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _noteController.text = currentNote;
                              isEditing = false;
                            });
                          },
                          icon: const Icon(Icons.close),
                          label: const Text("Hủy"),
                        ),
                      ],
                    ),
                  ],
                ),
                secondChild: Row(
                  children: [
                    Expanded(
                      child: Text(
                        currentNote.isEmpty ? "Không có ghi chú." : currentNote,
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isEditing = true;
                        });
                      },
                      icon: const Icon(Icons.edit, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }




  Widget _buildPaymentMethodSection() {
    return Container(
      padding: EdgeInsets.all(Dimensions.height20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.payment, color: Color(0xFF2196F3)),
              SizedBox(width: 8),
              Text(
                'Phương thức thanh toán',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...paymentMethods.map((method) => _buildPaymentMethodTile(method)),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodTile(PaymentMethod method) {
    final isSelected = selectedPaymentMethod == method.id;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = method.id;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? method.backgroundColor : Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? method.color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? method.color : Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                method.icon,
                color: isSelected ? Colors.white : Colors.grey,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? method.color : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    method.subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? method.color : Colors.transparent,
                border: Border.all(
                  color: isSelected ? method.color : Colors.grey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummarySection() {
    return Container(
      padding: EdgeInsets.all(Dimensions.height20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.receipt_long, color: Color(0xFF2196F3)),
              SizedBox(width: 8),
              Text(
                'Chi tiết đơn hàng',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSummaryRow('Tạm tính', '₫156.270', false),
          _buildSummaryRow('Giảm giá', '-₫47.400', false, isDiscount: true),
          _buildSummaryRow('Phí giao hàng', '+₫15.000', false),
          _buildSummaryRow('Phí dịch vụ', '+₫5.000', false),
          const Divider(height: 24, thickness: 1),
          _buildSummaryRow('Tổng cộng', '₫128.870', true),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.local_offer, color: Color(0xFF4CAF50), size: 16),
                SizedBox(width: 8),
                Text(
                  'Bạn đã tiết kiệm được ₫47.400!',
                  style: TextStyle(
                    color: Color(0xFF4CAF50),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, bool isTotal, {bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? Colors.black : Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 20 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal
                  ? const Color(0xFF4CAF50)
                  : isDiscount
                  ? const Color(0xFFE91E63)
                  : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width20,
        vertical: Dimensions.height15,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tổng thanh toán',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '₫128.870',
                      style: TextStyle(
                        fontSize: Dimensions.font20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF4CAF50),
                      ),
                    ),
                  ],
                ),
                _buildPaymentMethodPreview(),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: isProcessing ? null : _handlePlaceOrder,
                child: isProcessing
                    ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Đang xử lý...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
                    : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.payment, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Đặt hàng ngay',
                      style: TextStyle(
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
      ),
    );
  }

  Widget _buildPaymentMethodPreview() {
    final selectedMethod = paymentMethods.firstWhere(
          (method) => method.id == selectedPaymentMethod,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: selectedMethod.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: selectedMethod.color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(selectedMethod.icon, color: selectedMethod.color, size: 16),
          const SizedBox(width: 6),
          Text(
            selectedMethod.name,
            style: TextStyle(
              color: selectedMethod.color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _handlePlaceOrder() {
    setState(() {
      isProcessing = true;
    });

    // Simulate payment processing
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isProcessing = false;
      });
      _showSuccessDialog();
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Đặt hàng thành công!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Đơn hàng của bạn đang được xử lý\nvà sẽ được giao trong 25-30 phút',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Theo dõi đơn hàng'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MainNavigation()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Về trang chủ',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}