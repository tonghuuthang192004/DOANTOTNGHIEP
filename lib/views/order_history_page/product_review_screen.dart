import 'package:flutter/material.dart';
import '../../models/order/order_detail_model.dart';
import '../../services/order/order_service.dart';
import '../../utils/dimensions.dart';

class ProductReviewPage extends StatefulWidget {
  final int orderId;

  const ProductReviewPage({super.key, required this.orderId});

  @override
  State<ProductReviewPage> createState() => _ProductReviewPageState();
}

class _ProductReviewPageState extends State<ProductReviewPage> {
  List<OrderItemModel> items = [];
  final Map<int, int> ratings = {}; // productId => rating
  final Map<int, String> comments = {}; // productId => comment
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadOrderItems();
  }

  Future<void> _loadOrderItems() async {
    setState(() => isLoading = true);
    try {
      final result = await OrderService.fetchOrderDetail(widget.orderId);
      if (mounted) setState(() => items = result);
    } catch (e) {
      print('❌ Lỗi tải sản phẩm đơn hàng: $e');
    }
    if (mounted) setState(() => isLoading = false);
  }

  Future<void> _submitReviews() async {
    final allRated = items.every((item) => ratings[item.productId] != null);
    if (!allRated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('👉 Vui lòng đánh giá tất cả sản phẩm')),
      );
      return;
    }

    try {
      for (final item in items) {
        final score = ratings[item.productId]!;
        final comment = comments[item.productId] ?? '';

        await OrderService.rateProduct(
          productId: item.productId,
          score: score,
          comment: comment,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Đánh giá thành công')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Gửi đánh giá thất bại')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đánh giá sản phẩm'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: items.length,
        padding: EdgeInsets.all(Dimensions.width15),
        itemBuilder: (context, index) {
          final item = items[index];
          final pid = item.productId;
          return _buildReviewCard(item, pid);
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(Dimensions.width15),
        child: ElevatedButton(
          onPressed: _submitReviews,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          child: const Text('Gửi đánh giá', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  Widget _buildReviewCard(OrderItemModel item, int pid) {
    return Card(
      margin: EdgeInsets.only(bottom: Dimensions.height12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radius10)),
      child: Padding(
        padding: EdgeInsets.all(Dimensions.width12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼️ Hình ảnh + Tên
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radius10),
                  child: Image.network(item.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                ),
                SizedBox(width: Dimensions.width10),
                Expanded(
                  child: Text(
                    item.productName,
                    style: TextStyle(fontSize: Dimensions.font16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height10),
            // ⭐ Đánh giá sao
            Row(
              children: List.generate(5, (index) {
                final selected = (ratings[pid] ?? 0) > index;
                return IconButton(
                  onPressed: () => setState(() => ratings[pid] = index + 1),
                  icon: Icon(Icons.star, color: selected ? Colors.orange : Colors.grey[300]),
                  iconSize: 28,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                );
              }),
            ),
            // 📝 Nhận xét
            TextField(
              decoration: const InputDecoration(
                hintText: 'Nhận xét của bạn...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              maxLines: 2,
              onChanged: (value) => comments[pid] = value,
            ),
          ],
        ),
      ),
    );
  }
}
