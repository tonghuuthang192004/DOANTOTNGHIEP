// import 'package:flutter/material.dart';
// import '../../utils/dimensions.dart';
//
// class SocialLogin extends StatelessWidget {
//   const SocialLogin({super.key});
//
//   void _onSocialTap(BuildContext context, String provider) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Đăng nhập bằng $provider (demo)'),
//         backgroundColor: Colors.grey[800],
//         behavior: SnackBarBehavior.floating,
//         margin: EdgeInsets.all(Dimensions.width15),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(Dimensions.radius10),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(
//           'Hoặc đăng nhập với',
//           style: TextStyle(
//             fontSize: Dimensions.font14,
//             color: const Color(0xFFFF5722),
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         SizedBox(height: Dimensions.height20),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _buildGoogleButton(() => _onSocialTap(context, 'Google')),
//             // Sau này có thể thêm Facebook, Apple...
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildGoogleButton(VoidCallback onPressed) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         padding: EdgeInsets.symmetric(
//           horizontal: Dimensions.width20,
//           vertical: Dimensions.height10,
//         ),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(Dimensions.radius10),
//           border: Border.all(color: Colors.grey[300]!),
//         ),
//         child: Row(
//           children: [
//             Image.asset(
//               'images/gmail.png',
//               width: Dimensions.iconSize20,
//               height: Dimensions.iconSize20,
//             ),
//             SizedBox(width: Dimensions.width10),
//             Text(
//               'Google',
//               style: TextStyle(
//                 fontSize: Dimensions.font14,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.black87,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
