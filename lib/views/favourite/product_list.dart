//
// // components/product_list_item.dart
// import 'package:flutter/material.dart';
//
// import '../../utils/dimensions.dart';
// import 'model_product.dart';
//
// class ProductListItem extends StatelessWidget {
//   final Product product;
//   final int index;
//   final VoidCallback onRemove;
//   final VoidCallback onAddToCart;
//   final AnimationController heartAnimationController;
//
//   const ProductListItem({
//     Key? key,
//     required this.product,
//     required this.index,
//     required this.onRemove,
//     required this.onAddToCart,
//     required this.heartAnimationController,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: Duration(milliseconds: 300),
//       margin: EdgeInsets.only(bottom: Dimensions.height15 + 1),
//       child: Card(
//         elevation: 6,
//         shadowColor: Colors.black.withOpacity(0.08),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(Dimensions.radius20),
//         ),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(Dimensions.radius20),
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [Colors.white, Color(0xFFFAFAFA)],
//             ),
//           ),
//           child: Padding(
//             padding: EdgeInsets.all(Dimensions.width15 + 1),
//             child: Row(
//               children: [
//                 // Product Image
//                 Hero(
//                   tag: 'product_${product.name}_$index',
//                   child: Container(
//                     width: Dimensions.width50 + 30,
//                     height: Dimensions.height50 + 30,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(Dimensions.radius15 + 1),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: Dimensions.width8,
//                           offset: Offset(0, Dimensions.height5 - 1),
//                         ),
//                       ],
//                     ),
//                     child: Stack(
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(Dimensions.radius15 + 1),
//                           child: Image.asset(
//                             product.image,
//                             width: Dimensions.width50 + 30,
//                             height: Dimensions.height50 + 30,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) {
//                               return Container(
//                                 color: Color(0xFFF5F5F5),
//                                 child: Icon(
//                                   Icons.fastfood,
//                                   size: Dimensions.iconSize30 + 10,
//                                   color: Color(0xFFBDBDBD),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         if (product.isPopular)
//                           Positioned(
//                             top: Dimensions.height5 - 1,
//                             left: Dimensions.width5 - 1,
//                             child: Container(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: Dimensions.width5 + 1,
//                                 vertical: 2,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Color(0xFFFF8A65),
//                                 borderRadius: BorderRadius.circular(Dimensions.radius10 - 2),
//                               ),
//                               child: Text(
//                                 'HOT',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: Dimensions.font12 - 4,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 SizedBox(width: Dimensions.width15 + 1),
//
//                 // Product Details
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         product.name,
//                         style: TextStyle(
//                           fontSize: Dimensions.font18,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF2D3748),
//                         ),
//                       ),
//                       if (product.description != null) ...[
//                         SizedBox(height: Dimensions.height5 - 1),
//                         Text(
//                           product.description!,
//                           style: TextStyle(
//                             fontSize: Dimensions.font14,
//                             color: Color(0xFF718096),
//                             height: 1.3,
//                           ),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ],
//                       SizedBox(height: Dimensions.height8),
//                       Row(
//                         children: [
//                           // Rating
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: Dimensions.width8,
//                               vertical: Dimensions.height5 - 1,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Color(0xFFFFF8E1),
//                               borderRadius: BorderRadius.circular(Dimensions.radius10),
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Icon(
//                                   Icons.star,
//                                   color: Color(0xFFFFA726),
//                                   size: Dimensions.font14,
//                                 ),
//                                 SizedBox(width: Dimensions.width5 - 1),
//                                 Text(
//                                   '${product.rating}',
//                                   style: TextStyle(
//                                     fontSize: Dimensions.font12,
//                                     fontWeight: FontWeight.w600,
//                                     color: Color(0xFFFF8F00),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           SizedBox(width: Dimensions.width8),
//
//                           Text(
//                             '(${product.reviewCount})',
//                             style: TextStyle(
//                               fontSize: Dimensions.font12,
//                               color: Color(0xFFA0AEC0),
//                             ),
//                           ),
//                           Spacer(),
//                           // Price
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: Dimensions.width12,
//                               vertical: Dimensions.height5 + 1,
//                             ),
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [Color(0xFF48BB78), Color(0xFF38A169)],
//                               ),
//                               borderRadius: BorderRadius.circular(Dimensions.radius20),
//                             ),
//                             child: Text(
//                               '\$${product.price.toStringAsFixed(2)}',
//                               style: TextStyle(
//                                 fontSize: Dimensions.font16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: Dimensions.height12),
//                       // Action buttons
//                       Row(
//                         children: [
//                           Expanded(
//                             child: ElevatedButton.icon(
//                               onPressed: onAddToCart,
//                               icon: Icon(
//                                 Icons.add_shopping_cart,
//                                 size: Dimensions.iconSize20 - 2,
//                               ),
//                               label: Text('Thêm vào giỏ hàng'),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Color(0xFFFF8A65),
//                                 foregroundColor: Colors.white,
//                                 padding: EdgeInsets.symmetric(
//                                   vertical: Dimensions.height12,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(Dimensions.radius10),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: Dimensions.width12),
//                           GestureDetector(
//                             onTap: onRemove,
//                             child: Container(
//                               padding: EdgeInsets.all(Dimensions.width12),
//                               decoration: BoxDecoration(
//                                 color: Color(0xFFFFEBEE),
//                                 borderRadius: BorderRadius.circular(Dimensions.radius10),
//                                 border: Border.all(
//                                   color: Color(0xFFFF6B6B).withOpacity(0.3),
//                                 ),
//                               ),
//                               child: AnimatedBuilder(
//                                 animation: heartAnimationController,
//                                 builder: (context, child) {
//                                   return Transform.scale(
//                                     scale: 1.0 + (heartAnimationController.value * 0.3),
//                                     child: Icon(
//                                       Icons.delete_outline,
//                                       color: Color(0xFFFF6B6B),
//                                       size: Dimensions.iconSize20,
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }