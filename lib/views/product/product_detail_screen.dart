import 'package:flutter/material.dart';
import '../../services/product_service.dart';
import '../../utils/dimensions.dart';
import '../Cart/Cart.dart';
import 'bottom_bar_actions.dart';
import 'product_image_appbar.dart';
import 'product_info_section.dart';
import 'quantity_selector.dart';
import 'related_product_list.dart';

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
    fetchRelatedProducts();
  }

  Future<void> fetchRelatedProducts() async {
    try {
      final categoryId = widget.product?['danh_muc_id'];
      final result = categoryId != null
          ? await ProductService.getProductsByCategory(categoryId)
          : await ProductService.getAllProducts();

      setState(() {
        // Loại bỏ chính sản phẩm hiện tại khỏi danh sách nếu trùng ID
        relatedProducts = result
            .where((item) => item.id != widget.product?['id'])
            .map((item) => item.toJson())
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print('Lỗi khi tải sản phẩm liên quan: $e');
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
          ProductImageAppBar(product: widget.product),
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
                    onIncrease: () => setState(() => quantity++),
                    onDecrease: () {
                      if (quantity > 1) setState(() => quantity--);
                    },
                  ),
                  SizedBox(height: Dimensions.height20),
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
        onAddToCart: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage()));
        },
        onBuyNow: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage()));
        },
      ),
    );
  }
}
