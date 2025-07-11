import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontendtn1/views/product/product_detail/product_image_appbar.dart';
import 'package:frontendtn1/views/product/product_detail/product_info_section.dart';
import 'package:frontendtn1/views/product/product_detail/product_review_section.dart';
import 'package:frontendtn1/views/product/product_detail/quantity_selector.dart';
import 'package:frontendtn1/views/product/product_detail/related_product_list.dart';

import '../../../models/product/product_model.dart';
import '../../../services/cart/cart_service.dart';
import '../../../services/product/product_service.dart';
import '../../../utils/dimensions.dart';
import '../../cart/cart_page.dart';
import '../../pay/payment.dart';
import 'bottom_bar_actions.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? product;

  const ProductDetailScreen({Key? key, this.product}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  bool isLoading = true;
  List<Map<String, dynamic>> relatedProducts = [];

  @override
  void initState() {
    super.initState();
    getRelatedProducts();
  }

  Future<void> getRelatedProducts() async {
    try {
      final categoryId = widget.product?['danh_muc_id'];
      final result = categoryId != null
          ? await ProductService.getProductsByCategory(categoryId)
          : await ProductService.getAllProducts();

      setState(() {
        relatedProducts = result
            .where((item) => item.id != widget.product?['id'])
            .map((item) => item.toJson())
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print('❌ Lỗi khi tải sản phẩm liên quan: $e');
    }
  }

  double getBasePrice() {
    return (widget.product?['gia'] ?? widget.product?['price']) * 1.0;
  }

  double getTotalPrice() {
    return getBasePrice() * quantity;
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          ProductImageAppBar(
            product: {
              ...?widget.product,
              'id_san_pham': widget.product?['id'], // 👈 Thêm trường id_san_pham thủ công nếu cần
            },
            cartItemCount: 2,
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(Dimensions.width20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductInfoSection(
                    product: widget.product,
                    basePrice: getBasePrice(),
                  ),
                  QuantitySelector(
                    quantity: quantity,
                    onIncrease: () {
                      setState(() => quantity++);  // Không cần kiểm tra stockQuantity nữa
                    },
                    onDecrease: () {
                      if (quantity > 1) setState(() => quantity--);
                    },
                  ),
                  SizedBox(height: Dimensions.height20),
                  // 👇 Thêm phần đánh giá sản phẩm
                  ProductReviewSection(
                    productId: widget.product?['id'],
                  ),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : RelatedProductList(products: relatedProducts),
                  SizedBox(height: Dimensions.height30),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBarActions(
        totalPrice: getTotalPrice(),
        onAddToCart: () async {
          try {
            final product = ProductModel.fromJson(widget.product!);
            await CartService.addToCart(product, quantity: quantity);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("✅ Đã thêm $quantity sản phẩm vào giỏ hàng")),
            );

            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartPage()),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Lỗi khi thêm sản phẩm vào giỏ hàng")),
            );
          }
        },
        onBuyNow: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CheckoutPage()),
          );
        },
      ),
    );
  }
}
