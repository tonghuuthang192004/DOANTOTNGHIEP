import 'package:flutter/material.dart';
import '../../utils/dimensions.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'ĐĂNG KÝ TÀI KHOẢN',
          style: TextStyle(
            fontSize: Dimensions.font26,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFF5722), // Màu cam nổi bật
          ),
        ),
        SizedBox(height: Dimensions.height12),
      ],
    );
  }
}
