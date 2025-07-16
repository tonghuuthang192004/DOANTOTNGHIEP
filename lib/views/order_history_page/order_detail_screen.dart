import 'package:flutter/material.dart';
import '../../models/order/order_detail_model.dart';
import '../../services/order/order_service.dart';
import '../../utils/dimensions.dart';
import '../product/product_detail/product_detail_screen.dart';

class OrderDetailPage extends StatefulWidget {
  final int orderId;
  const OrderDetailPage({super.key, required this.orderId});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  Map<String, dynamic>? orderInfo;
  List<OrderItemModel> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrderDetail();
  }

  Future<void> _fetchOrderDetail() async {
    try {
      debugPrint('📥 Bắt đầu tải chi tiết đơn hàng ID=${widget.orderId}');
      final result = await OrderService.fetchOrderDetail(widget.orderId);
      debugPrint('📥 Dữ liệu trả về từ fetchOrderDetail: $result');

      final fetchedItems = result['items'] as List<OrderItemModel>;
      final fetchedOrder = result['order'] as Map<String, dynamic>?;

      setState(() {
        items = fetchedItems;
        orderInfo = fetchedOrder;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Lỗi khi tải chi tiết đơn hàng: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⚠️ Không thể tải chi tiết đơn hàng')),
        );
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin chi tiết ${_formatOrderCode(widget.orderId)}'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
          ? const Center(child: Text('❌ Không có sản phẩm trong đơn hàng'))
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOrderInfo(),
          const Divider(height: 1, thickness: 1),
          Expanded(child: _buildProductList()),
          _buildTotalSection(),
        ],
      ),
    );
  }

  Widget _buildOrderInfo() {
    if (orderInfo == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Dimensions.width15),
      color: Colors.orange.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📦 Người nhận: ${orderInfo!['customerName'] ?? 'Không rõ'}',
            style: TextStyle(
              fontSize: Dimensions.font16,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          SizedBox(height: Dimensions.height8),
          _infoRow(Icons.phone, 'SĐT', orderInfo!['customerPhone'] ?? ''),
          _infoRow(Icons.location_on, 'Địa chỉ', orderInfo!['shippingAddress'] ?? ''),
          _infoRow(Icons.payment, 'Thanh toán', orderInfo!['paymentStatus'] ?? ''),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height5),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade700),
          SizedBox(width: Dimensions.width8),
          Text(
            '$title: ',
            style: TextStyle(
              fontSize: Dimensions.font14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: Dimensions.font14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return ListView.separated(
      padding: EdgeInsets.all(Dimensions.width15),
      itemCount: items.length,
      separatorBuilder: (_, __) => Divider(height: Dimensions.height15),
      itemBuilder: (context, index) => _buildProductItem(items[index]),
    );
  }

  Widget _buildProductItem(OrderItemModel item) {
    return InkWell(
      onTap: () {
        final productData = {
          'id': item.productId,
          'gia': item.price ?? 0,
          'ten_san_pham': item.productName ?? 'Không rõ',
          'hinh_anh': (item.imageUrl?.isNotEmpty == true)
              ? (item.imageUrl.startsWith('http')
              ? item.imageUrl
              : 'http://10.0.2.2:3000/uploads/${item.imageUrl}')
              : 'https://via.placeholder.com/150',
          'trang_thai': item.status ?? 'Đã hủy', // 👈 Gửi trạng thái thực tế của sản phẩm
        };

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: productData),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radius10),
            child: Image.network(
              (item.imageUrl?.isNotEmpty == true)
                  ? (item.imageUrl.startsWith('http')
                  ? item.imageUrl
                  : 'http://10.0.2.2:3000/uploads/${item.imageUrl}')
                  : 'https://via.placeholder.com/100',
              width: Dimensions.width50,
              height: Dimensions.height50,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey[300],
                width: Dimensions.width50,
                height: Dimensions.height50,
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ),
          SizedBox(width: Dimensions.width12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: TextStyle(
                    fontSize: Dimensions.font16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Dimensions.height5),
                Text('Giá: ${_formatCurrency(item.price ?? 0)}đ'),
                Text('Số lượng: ${item.quantity}'),
                Text(
                  'Tổng: ${_formatCurrency(item.total)}đ',
                  style: const TextStyle(color: Colors.orange),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildTotalSection() {
    double total = items.fold(0.0, (sum, item) => sum + item.total);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Dimensions.width15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border(top: BorderSide(color: Colors.grey.shade400)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Tổng cộng:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Text(
            '${_formatCurrency(total)}đ',
            style: const TextStyle(
                color: Colors.orange,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
    );
  }

  String _formatOrderCode(int id) => '#DH$id';
}
