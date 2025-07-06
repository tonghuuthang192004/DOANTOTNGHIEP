import 'package:flutter/material.dart';
import 'package:frontendtn1/views/order_history_page/product_review_screen.dart';
import '../../utils/dimensions.dart';
import '../../models/order/order_model.dart';
import '../../services/order/order_service.dart';
import 'order_detail_screen.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  String selectedFilter = 'Tất cả';
  final List<String> filters = [
    'Tất cả',
    'Chờ xác nhận',
    'Đang chuẩn bị',
    'Đang giao hàng',
    'Hoàn thành',
    'Đã huỷ'
  ];
  List<OrderModel> orders = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => isLoading = true);
    try {
      final fetched = selectedFilter == 'Tất cả'
          ? await OrderService.fetchOrderHistory()
          : await OrderService.fetchOrders(status: selectedFilter);
      setState(() => orders = fetched);
    } catch (e) {
      debugPrint('❌ Lỗi khi tải đơn hàng: $e');
      _showSnackBar('⚠️ Không thể tải lịch sử đơn hàng');
    }
    setState(() => isLoading = false);
  }

  void _showSnackBar(String message, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  void _navigateToDetail(int orderId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OrderDetailPage(orderId: orderId)),
    );
  }

  void _navigateToReview(int orderId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductReviewPage(orderId: orderId)),
    );
  }

  Future<void> _cancelOrder(int orderId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Huỷ đơn hàng?'),
        content: const Text('Bạn có chắc chắn muốn huỷ đơn hàng này không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Không')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Huỷ')),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await OrderService.cancelOrder(orderId);
      if (success) {
        _showSnackBar('✅ Huỷ đơn thành công', color: Colors.green);
        _loadOrders();
      } else {
        _showSnackBar('❌ Huỷ đơn thất bại', color: Colors.red);
      }
    }
  }

  Future<void> _reorder(int orderId) async {
    final success = await OrderService.reorder(orderId);
    if (success) {
      _showSnackBar('🛒 Các sản phẩm đã được thêm lại giỏ hàng', color: Colors.green);
    } else {
      _showSnackBar('❌ Mua lại thất bại', color: Colors.red);
    }
  }

  bool _canCancel(String status) {
    return ['Chờ xác nhận', 'Đang chuẩn bị', 'Đang giao hàng'].contains(status);
  }

  (Color, IconData) _getStatusStyle(String status) {
    switch (status) {
      case 'Hoàn thành':
        return (Colors.green, Icons.check_circle);
      case 'Đang giao hàng':
        return (Colors.blue, Icons.local_shipping);
      case 'Đang chuẩn bị':
        return (Colors.deepOrange, Icons.kitchen);
      case 'Chờ xác nhận':
        return (Colors.orange, Icons.access_time);
      case 'Đã huỷ':
        return (Colors.red, Icons.cancel);
      default:
        return (Colors.grey, Icons.help_outline);
    }
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử đơn hàng'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : orders.isEmpty
                ? const Center(child: Text('📦 Không có đơn hàng nào'))
                : ListView.builder(
              padding: EdgeInsets.all(Dimensions.width15),
              itemCount: orders.length,
              itemBuilder: (_, index) => _buildOrderCard(orders[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height8),
      height: Dimensions.height50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
        itemCount: filters.length,
        separatorBuilder: (_, __) => SizedBox(width: Dimensions.width8),
        itemBuilder: (_, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;
          return ChoiceChip(
            label: Text(filter),
            selected: isSelected,
            selectedColor: Colors.orange.shade200,
            onSelected: (_) {
              setState(() => selectedFilter = filter);
              _loadOrders();
            },
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    final (statusColor, statusIcon) = _getStatusStyle(order.status);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius12),
      ),
      margin: EdgeInsets.only(bottom: Dimensions.height12),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(Dimensions.width12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.orderCode,
                  style: TextStyle(fontSize: Dimensions.font16, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                  ),
                  child: Row(
                    children: [
                      Icon(statusIcon, size: 16, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        order.status,
                        style: TextStyle(color: statusColor, fontSize: Dimensions.font14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height8),
            // Date & Total
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 6),
                Text(order.formattedDate, style: TextStyle(fontSize: Dimensions.font14)),
                const Spacer(),
                Text(
                  'Tổng: ${order.formattedPrice}đ',
                  style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: Dimensions.font14),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height10),
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _navigateToDetail(order.id),
                  icon: const Icon(Icons.visibility, color: Colors.blue),
                  label: const Text('Chi tiết', style: TextStyle(color: Colors.blue)),
                ),
                if (_canCancel(order.status))
                  TextButton.icon(
                    onPressed: () => _cancelOrder(order.id),
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    label: const Text('Huỷ', style: TextStyle(color: Colors.red)),
                  ),
                if (order.status == 'Hoàn Thành') ...[
                  TextButton.icon(
                    onPressed: () => _reorder(order.id),
                    icon: const Icon(Icons.shopping_cart, color: Colors.green),
                    label: const Text('Mua lại', style: TextStyle(color: Colors.green)),
                  ),
                  TextButton.icon(
                    onPressed: () => _navigateToReview(order.id),
                    icon: const Icon(Icons.star, color: Colors.orange),
                    label: const Text('Đánh giá', style: TextStyle(color: Colors.orange)),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
