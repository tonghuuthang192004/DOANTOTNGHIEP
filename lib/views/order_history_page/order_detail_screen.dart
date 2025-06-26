import 'package:flutter/material.dart';
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
  List<OrderItemModel> items = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchOrderDetail();
  }

  Future<void> _fetchOrderDetail() async {
    setState(() => isLoading = true);
    try {
      final fetched = await OrderService.fetchOrderDetail(widget.orderId);
      if (mounted) setState(() => items = fetched);
    } catch (e) {
      print('❌ Lỗi khi tải chi tiết đơn hàng: $e');
    }
    if (mounted) setState(() => isLoading = false);
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
          : items.isEmpty
          ? const Center(child: Text('Không có sản phẩm trong đơn hàng'))
          : ListView.separated(
        padding: EdgeInsets.all(Dimensions.width15),
        itemCount: items.length,
        separatorBuilder: (_, __) => Divider(height: Dimensions.height15),
        itemBuilder: (context, index) => _buildItem(items[index]),
      ),
    );
  }

  Widget _buildItem(OrderItemModel item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radius12),
          child: Image.network(
            item.imageUrl,
            width: Dimensions.width100,
            height: Dimensions.height100,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(width: Dimensions.width12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.productName,
                style: TextStyle(fontSize: Dimensions.font16, fontWeight: FontWeight.bold),
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

  String _formatCurrency(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},');
  }

  String _formatOrderCode(int id) => '#DH$id';
}
