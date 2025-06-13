//
// // components/empty_state.dart
// import 'package:flutter/material.dart';
// import '../../utils/dimensions.dart';
//
// class EmptyFavoriteState extends StatelessWidget {
//   final VoidCallback onExplorePressed;
//
//   const EmptyFavoriteState({
//     Key? key,
//     required this.onExplorePressed,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Animated heart icon
//           TweenAnimationBuilder(
//             duration: Duration(seconds: 2),
//             tween: Tween<double>(begin: 0, end: 1),
//             builder: (context, double value, child) {
//               return Transform.scale(
//                 scale: 0.8 + (0.2 * value),
//                 child: Container(
//                   width: Dimensions.width50 * 2.4, // ~120
//                   height: Dimensions.height50 * 2.4, // ~120
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                       colors: [
//                         Color(0xFFFFE0E0),
//                         Color(0xFFFFF5F5),
//                       ],
//                     ),
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Color(0xFFFF8A65).withOpacity(0.2),
//                         blurRadius: Dimensions.radius20,
//                         offset: Offset(0, Dimensions.height10),
//                       ),
//                     ],
//                   ),
//                   child: Icon(
//                     Icons.favorite_border,
//                     size: Dimensions.iconSize30 * 2, // ~60
//                     color: Color(0xFFFF8A65),
//                   ),
//                 ),
//               );
//             },
//           ),
//
//           SizedBox(height: Dimensions.height30 + 2),
//
//           Text(
//             'Chưa có sản phẩm yêu thích',
//             style: TextStyle(
//               fontSize: Dimensions.font24,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF2D3748),
//             ),
//           ),
//
//           SizedBox(height: Dimensions.height12),
//
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: Dimensions.width30 + 2),
//             child: Text(
//               'Hãy thêm những sản phẩm bạn yêu thích vào đây để dễ dàng tìm kiếm sau này',
//               style: TextStyle(
//                 fontSize: Dimensions.font16,
//                 color: Color(0xFF718096),
//                 height: 1.5,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//
//           SizedBox(height: Dimensions.height40),
//
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFFFF8A65), Color(0xFFFF7043)],
//               ),
//               borderRadius: BorderRadius.circular(Dimensions.radius25),
//               boxShadow: [
//                 BoxShadow(
//                   color: Color(0xFFFF8A65).withOpacity(0.4),
//                   blurRadius: Dimensions.radius15,
//                   offset: Offset(0, Dimensions.height8),
//                 ),
//               ],
//             ),
//             child: ElevatedButton.icon(
//               onPressed: onExplorePressed,
//               icon: Icon(
//                 Icons.explore,
//                 color: Colors.white,
//                 size: Dimensions.iconSize20,
//               ),
//               label: Text(
//                 'Khám phá sản phẩm',
//                 style: TextStyle(
//                   fontSize: Dimensions.font16,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.white,
//                 ),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.transparent,
//                 shadowColor: Colors.transparent,
//                 padding: EdgeInsets.symmetric(
//                   horizontal: Dimensions.width30 + 2,
//                   vertical: Dimensions.height15 + 1,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(Dimensions.radius25),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }