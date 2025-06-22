// // components/product_grid_item.dart
// import 'package:flutter/material.dart';
// import '../../utils/dimensions.dart';
// import 'model_product.dart';
//
// class ProductGridItem extends StatelessWidget {
//   final Product product;
//   final int index;
//   final VoidCallback onRemove;
//   final VoidCallback onAddToCart;
//
//   const ProductGridItem({
//     Key? key,
//     required this.product,
//     required this.index,
//     required this.onRemove,
//     required this.onAddToCart,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: Duration(milliseconds: 300),
//       child: Card(
//         elevation: 8,
//         shadowColor: Colors.black.withOpacity(0.1),
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
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Image section
//               Expanded(
//                 flex: 3,
//                 child: Stack(
//                   children: [
//                     Container(
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.vertical(
//                           top: Radius.circular(Dimensions.radius20),
//                         ),
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.vertical(
//                           top: Radius.circular(Dimensions.radius20),
//                         ),
//                         child: Image.asset(
//                           product.image,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) {
//                             return Container(
//                               color: Color(0xFFF5F5F5),
//                               child: Icon(
//                                 Icons.fastfood,
//                                 size: Dimensions.iconSize30 + 10,
//                                 color: Color(0xFFBDBDBD),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                     // Popular badge
//                     if (product.isPopular)
//                       Positioned(
//                         top: Dimensions.height8,
//                         left: Dimensions.width8,
//                         child: Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: Dimensions.width8,
//                             vertical: Dimensions.height5 - 1,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Color(0xFFFF8A65),
//                             borderRadius: BorderRadius.circular(Dimensions.radius10),
//                           ),
//                           child: Text(
//                             'HOT',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: Dimensions.font12 - 2,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     // Remove from favorites button
//                     Positioned(
//                       top: Dimensions.height8,
//                       right: Dimensions.width8,
//                       child: GestureDetector(
//                         onTap: onRemove,
//                         child: Container(
//                           padding: EdgeInsets.all(Dimensions.width5 + 1),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             shape: BoxShape.circle,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.1),
//                                 blurRadius: 4,
//                                 offset: Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                           child: Icon(
//                             Icons.close,
//                             color: Color(0xFFFF6B6B),
//                             size: Dimensions.iconSize16,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // Content section
//               Expanded(
//                 flex: 3,
//                 child: Padding(
//                   padding: EdgeInsets.all(Dimensions.width12),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         product.name,
//                         style: TextStyle(
//                           fontSize: Dimensions.font16,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF2D3748),
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       SizedBox(height: Dimensions.height5 - 1),
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.star,
//                             color: Color(0xFFFFA726),
//                             size: Dimensions.font14,
//                           ),
//                           SizedBox(width: Dimensions.width5 - 1),
//                           Text(
//                             '${product.rating}',
//                             style: TextStyle(
//                               fontSize: Dimensions.font12,
//                               color: Color(0xFF718096),
//                             ),
//                           ),
//                           Text(
//                             ' (${product.reviewCount})',
//                             style: TextStyle(
//                               fontSize: Dimensions.font12,
//                               color: Color(0xFFA0AEC0),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: Dimensions.height8),
//                       Text(
//                         '\$${product.price.toStringAsFixed(2)}',
//                         style: TextStyle(
//                           fontSize: Dimensions.font18,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF38A169),
//                         ),
//                       ),
//                       Spacer(),
//                       // Action buttons
//                       Row(
//                         children: [
//                           Expanded(
//                             child: ElevatedButton.icon(
//                               onPressed: onAddToCart,
//                               icon: Icon(
//                                 Icons.add_shopping_cart,
//                                 size: Dimensions.iconSize16,
//                               ),
//                               label: Text(
//                                 'Thêm',
//                                 style: TextStyle(fontSize: Dimensions.font12),
//                               ),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Color(0xFFFF8A65),
//                                 foregroundColor: Colors.white,
//                                 padding: EdgeInsets.symmetric(
//                                   vertical: Dimensions.height8,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(Dimensions.radius10),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }