import 'package:flutter/material.dart';
import '../../../services/order/order_service.dart';
import '../../../utils/dimensions.dart';

class ProductReviewSection extends StatefulWidget {
  final int productId;

  const ProductReviewSection({Key? key, required this.productId})
      : super(key: key);

  @override
  State<ProductReviewSection> createState() => _ProductReviewSectionState();
}

class _ProductReviewSectionState extends State<ProductReviewSection> {
  bool isLoading = true;
  List<Map<String, dynamic>> reviews = [];
  bool showAllReviews = false;

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    try {
      final result = await OrderService.fetchProductReviews(widget.productId);
      setState(() {
        reviews = result;
        isLoading = false;
      });
    } catch (e) {
      print('❌ Lỗi khi tải đánh giá: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildReviewItem(Map<String, dynamic> review) {
    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.height10),
      padding: EdgeInsets.all(Dimensions.height10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(Dimensions.radius12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.person, size: Dimensions.iconSize30, color: Colors.grey),
          SizedBox(width: Dimensions.width10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      review['ten_nguoi_dung'] ?? "Người dùng",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Dimensions.font16,
                      ),
                    ),
                    SizedBox(width: Dimensions.width10),
                    Icon(Icons.star,
                        color: Colors.amber, size: Dimensions.iconSize16),
                    Text(
                      review['diem_so'].toString(),
                      style: TextStyle(
                          fontSize: Dimensions.font14,
                          color: Colors.grey.shade700),
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.height5),
                Text(
                  review['nhan_xet'] ?? "",
                  style: TextStyle(fontSize: Dimensions.font14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Đánh giá sản phẩm",
              style: TextStyle(
                fontSize: Dimensions.font20,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (reviews.length > 1)
              TextButton(
                onPressed: () {
                  setState(() {
                    showAllReviews = !showAllReviews;
                  });
                },
                child: Text(
                  showAllReviews ? "Ẩn bớt" : "Xem tất cả (${reviews.length})",
                  style: TextStyle(
                    fontSize: Dimensions.font14,
                    color: Colors.blue,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: Dimensions.height10),
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else if (reviews.isEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Chưa có đánh giá nào.",
              style: TextStyle(fontSize: Dimensions.font16, color: Colors.grey),
            ),
          )
        else
          Column(
            children: [
              ...((showAllReviews ? reviews : [reviews.first])
                  .map(buildReviewItem)
                  .toList()),
            ],
          ),
      ],
    );
  }
}
