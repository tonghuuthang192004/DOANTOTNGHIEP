// // components/favorite_appbar.dart
// import 'package:flutter/material.dart';
// import '../../utils/dimensions.dart';
//
// class FavoriteAppBar extends StatelessWidget {
//   final int cartItemsCount;
//   final int favProductsCount;
//   final VoidCallback onCartPressed;
//
//   const FavoriteAppBar({
//     Key? key,
//     required this.cartItemsCount,
//     required this.favProductsCount,
//     required this.onCartPressed,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SliverAppBar(
//       expandedHeight: Dimensions.height50 * 2.4, // ~120
//       floating: false,
//       pinned: true,
//       elevation: 0,
//       backgroundColor: Color(0xFFFF8A65),
//       foregroundColor: Colors.white,
//       flexibleSpace: FlexibleSpaceBar(
//         centerTitle: true,
//         titlePadding: EdgeInsets.only(bottom: Dimensions.height15),
//         title: Text(
//           'Yêu thích',
//           style: TextStyle(
//             fontSize: Dimensions.font20,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         background: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 Color(0xFFFF8A65),
//                 Color(0xFFFF7043),
//               ],
//             ),
//           ),
//         ),
//       ),
//       actions: [
//         // cart icon with badge
//         Padding(
//           padding: EdgeInsets.only(top: Dimensions.height10, right: Dimensions.width8),
//           child: Stack(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(Dimensions.radius20),
//                 ),
//                 child: IconButton(
//                   onPressed: onCartPressed,
//                   icon: Icon(
//                     Icons.shopping_cart,
//                     color: Colors.white,
//                     size: Dimensions.iconSize24,
//                   ),
//                 ),
//               ),
//               if (cartItemsCount > 0)
//                 Positioned(
//                   right: Dimensions.width5 + 1,
//                   top: Dimensions.height5 + 1,
//                   child: Container(
//                     padding: EdgeInsets.all(Dimensions.width5 - 1),
//                     decoration: BoxDecoration(
//                       color: Colors.red,
//                       shape: BoxShape.circle,
//                     ),
//                     constraints: BoxConstraints(
//                       minWidth: Dimensions.width15 + 1,
//                       minHeight: Dimensions.height15 + 1,
//                     ),
//                     child: Text(
//                       '$cartItemsCount',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: Dimensions.font12 - 2,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//         // Favorite counter
//         Padding(
//           padding: EdgeInsets.only(
//             top: Dimensions.height10,
//             right: Dimensions.width15 + 1,
//           ),
//           child: Container(
//             padding: EdgeInsets.symmetric(
//               horizontal: Dimensions.width12,
//               vertical: Dimensions.height5 + 1,
//             ),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(Dimensions.radius20),
//               border: Border.all(color: Colors.white.withOpacity(0.3)),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   Icons.favorite,
//                   size: Dimensions.iconSize16,
//                   color: Colors.white,
//                 ),
//                 SizedBox(width: Dimensions.width5 - 1),
//                 Text(
//                   '$favProductsCount',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: Dimensions.font14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }