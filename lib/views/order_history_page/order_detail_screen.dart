import 'package:flutter/material.dart';
import '../../models/order/order_model.dart';
import '../../models/order/order_detail_model.dart';
import '../../services/order/order_service.dart';
import '../../utils/dimensions.dart';

class OrderDetailPage extends StatefulWidget {
  final int orderId;
  const OrderDetailPage({super.key, required this.orderId});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  OrderModel? order;
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

      if (result is Map<String, dynamic>) {
        final orderData = result['order'];
        final itemsData = result['items'];

        debugPrint('📥 orderData type: ${orderData.runtimeType}');
        debugPrint('📥 itemsData type: ${itemsData.runtimeType}');

        if (itemsData is List<OrderItemModel>) {
          items = itemsData;
        } else {
          throw Exception('❌ itemsData không đúng kiểu List<OrderItemModel>');
        }

        if (orderData == null) {
          debugPrint('📥 Chỉ có danh sách sản phẩm, orderData == null');
          setState(() {
            order = null;
            isLoading = false;
          });
        } else if (orderData is Map<String, dynamic>) {
          debugPrint('📥 Có order và items');
          order = OrderModel.fromJson(orderData);
          setState(() {
            isLoading = false;
          });
        } else {
          throw Exception('❌ Dữ liệu order không đúng định dạng');
        }
      } else {
        throw Exception('❌ Dữ liệu trả về không phải Map');
      }
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
        title: Text('Chi tiết ${_formatOrderCode(widget.orderId)}'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOrderInfo(), // Ẩn nếu order == null
          const Divider(height: 1, thickness: 1),
          Expanded(child: _buildProductList()),
          _buildTotalSection(),
        ],
      ),
    );
  }

  Widget _buildOrderInfo() {
    if (order == null) {
      return const SizedBox.shrink(); // ✅ Ẩn luôn phần này nếu không có order
    }
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Dimensions.width15),
      color: Colors.orange.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📦 Mã đơn: ${_formatOrderCode(order!.id)}',
            style: TextStyle(
              fontSize: Dimensions.font16,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          SizedBox(height: Dimensions.height8),
          _infoRow(Icons.payment, 'Thanh toán', order!.paymentMethod),
          _infoRow(Icons.local_shipping, 'Trạng thái', order!.status),
          if (order!.note != null && order!.note!.isNotEmpty)
            _infoRow(Icons.note, 'Ghi chú', order!.note!),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radius10),
          child: Image.network(
            item.imageUrl.isNotEmpty
                ? item.imageUrl
                : 'https://via.placeholder.com/100',
            width: Dimensions.width50,
            height: Dimensions.height50,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey[300],
              width: Dimensions.width50,
              height: Dimensions.height50,
              child:
              const Icon(Icons.broken_image, color: Colors.grey),
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
              Text('Giá: ${_formatCurrency(item.price)}đ'),
              Text('Số lượng: ${item.quantity}'),
              Text(
                'Tổng: ${_formatCurrency(item.total)}đ',
                style: const TextStyle(color: Colors.orange),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTotalSection() {
    double total =
    items.fold(0.0, (sum, item) => sum + item.total);
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
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600)),
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
