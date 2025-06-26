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
  final List<String> filters = ['Tất cả', 'Chờ xác nhận', 'Đang chuẩn bị', 'Đang giao hàng', 'Hoàn thành', 'Đã huỷ'];
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
      final fetched = await OrderService.fetchOrders(
        status: selectedFilter == 'Tất cả' ? null : selectedFilter,
      );
      setState(() => orders = fetched);
    } catch (e) {
      print('❌ Lỗi khi tải đơn hàng: $e');
    }
    setState(() => isLoading = false);
  }

  Future<void> _cancelOrder(int orderId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc muốn huỷ đơn hàng này không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Không')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Huỷ đơn')),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await OrderService.cancelOrder(orderId);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Huỷ đơn hàng thành công')),
        );
        _loadOrders();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Không thể huỷ đơn hàng')),
        );
      }
    }
  }

  Future<void> _reorder(int orderId) async {
    final success = await OrderService.reorder(orderId);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🛒 Đã thêm lại các sản phẩm vào giỏ hàng')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Mua lại thất bại')),
      );
    }
  }

  void _navigateToReview(int orderId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductReviewPage(orderId: orderId)),
    );
  }

  bool canCancelOrder(String status) {
    return status == 'Chờ xác nhận' ||
        status == 'Đang chuẩn bị' ||
        status == 'Đang giao hàng';
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
                ? const Center(child: Text('Không có đơn hàng nào'))
                : ListView.builder(
              itemCount: orders.length,
              padding: EdgeInsets.all(Dimensions.width15),
              itemBuilder: (context, index) => _buildOrderCard(orders[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
      height: Dimensions.height50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;
          return Padding(
            padding: EdgeInsets.only(right: Dimensions.width10),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              selectedColor: Colors.orange.shade100,
              onSelected: (_) {
                setState(() => selectedFilter = filter);
                _loadOrders();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    Color statusColor;
    IconData statusIcon;

    switch (order.status) {
      case 'Hoàn thành':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'Đang giao hàng':
        statusColor = Colors.blue;
        statusIcon = Icons.local_shipping;
        break;
      case 'Đang chuẩn bị':
        statusColor = Colors.deepOrangeAccent;
        statusIcon = Icons.kitchen;
        break;
      case 'Chờ xác nhận':
        statusColor = Colors.orange;
        statusIcon = Icons.access_time;
        break;
      case 'Đã huỷ':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radius12)),
      elevation: 2,
      margin: EdgeInsets.only(bottom: Dimensions.height12),
      child: Padding(
        padding: EdgeInsets.all(Dimensions.width12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(order.orderCode, style: TextStyle(fontSize: Dimensions.font16, fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                  ),
                  child: Row(
                    children: [
                      Icon(statusIcon, color: statusColor, size: 16),
                      const SizedBox(width: 4),
                      Text(order.status, style: TextStyle(color: statusColor)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height10),
            // Date & Total
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 6),
                Text(order.formattedDate),
                const Spacer(),
                Text(
                  'Tổng: ${order.formattedPrice}đ',
                  style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height10),
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailPage(orderId: order.id),
                      ),
                    );
                  },
                  icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                  label: const Text(
                    'Xem chi tiết',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),

                if (canCancelOrder(order.status))
                  TextButton.icon(
                    onPressed: () => _cancelOrder(order.id),
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    label: const Text('Huỷ đơn', style: TextStyle(color: Colors.red)),
                  ),

                if (order.status == 'Hoàn thành') ...[
                  TextButton.icon(
                    onPressed: () => _reorder(order.id),
                    icon: const Icon(Icons.shopping_cart, color: Colors.green),
                    label: const Text('Mua lại', style: TextStyle(color: Colors.green)),
                  ),
                  TextButton.icon(
                    onPressed: () => _navigateToReview(order.id),
                    icon: const Icon(Icons.star_rate, color: Colors.orange),
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
