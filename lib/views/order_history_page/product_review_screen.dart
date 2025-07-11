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
  final Map<int, int> ratings = {};    // productId => rating
  final Map<int, String> comments = {}; // productId => comment
  bool isLoading = false;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadOrderItems();
  }

  Future<void> _loadOrderItems() async {
    setState(() => isLoading = true);
    try {
      final result = await OrderService.fetchOrderDetail(widget.orderId);
      if (mounted) setState(() => items = result['items']);
    } catch (e) {
      debugPrint('❌ Lỗi tải sản phẩm đơn hàng: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Không thể tải sản phẩm: $e')),
        );
      }
    }
    if (mounted) setState(() => isLoading = false);
  }

  Future<void> _submitReviews() async {
    // Kiểm tra đã đánh giá đầy đủ sao
    final allRated = items.every((item) => ratings[item.productId] != null && ratings[item.productId]! > 0);
    if (!allRated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('👉 Vui lòng đánh giá đầy đủ sao cho tất cả sản phẩm')),
      );
      debugPrint('❌ Chưa đánh giá đủ sao cho tất cả sản phẩm');
      return;
    }

    // Kiểm tra comment không được để trống
    final allCommented = items.every((item) {
      final c = comments[item.productId];
      return c != null && c.trim().isNotEmpty;
    });
    if (!allCommented) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('👉 Vui lòng nhập nhận xét cho tất cả sản phẩm')),
      );
      debugPrint('❌ Chưa nhập nhận xét cho tất cả sản phẩm');
      return;
    }

    setState(() => isSubmitting = true);
    debugPrint('🟡 Bắt đầu gửi đánh giá cho ${items.length} sản phẩm');

    try {
      await Future.wait(items.map((item) async {
        final score = ratings[item.productId]!;
        final comment = comments[item.productId]!.trim();

        debugPrint('➡️ Gửi đánh giá sản phẩm id=${item.productId}, điểm=$score, nhận xét="$comment"');
        await OrderService.rateProduct(
          productId: item.productId,
          score: score,
          comment: comment,
        );
        debugPrint('✅ Đã gửi đánh giá thành công sản phẩm id=${item.productId}');
      }));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Đánh giá thành công')),
      );
      debugPrint('🎉 Gửi đánh giá tất cả sản phẩm thành công');
      Navigator.pop(context);
    } catch (e) {
      debugPrint('❌ Lỗi gửi đánh giá: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Gửi đánh giá thất bại: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => isSubmitting = false);
      debugPrint('🟢 Kết thúc gửi đánh giá');
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
          onPressed: isSubmitting ? null : _submitReviews,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            minimumSize: Size(double.infinity, Dimensions.height50),
          ),
          child: isSubmitting
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Gửi đánh giá', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  Widget _buildReviewCard(OrderItemModel item, int pid) {
    return Card(
      margin: EdgeInsets.only(bottom: Dimensions.height12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius10),
      ),
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
                  child: Image.network(
                    item.imageUrl.isNotEmpty ? item.imageUrl : 'https://via.placeholder.com/60',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: Dimensions.width10),
                Expanded(
                  child: Text(
                    item.productName,
                    style: TextStyle(
                      fontSize: Dimensions.font16,
                      fontWeight: FontWeight.w600,
                    ),
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
                  icon: Icon(
                    Icons.star,
                    color: selected ? Colors.orange : Colors.grey[300],
                  ),
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
