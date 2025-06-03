import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  final Color? color;
  final String text;
  final double size;
  final double height;

  SmallText({
    Key? key,
    this.color = const Color(0xFFccc7c5),
    this.size = 12,
    required this.text,
    this.height = 1.2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontFamily: 'Roboto',
        height: height,
      ),
      maxLines: null, // Cho phép hiển thị không giới hạn dòng
      overflow: TextOverflow.visible, // Không cắt text, hiển thị đầy đủ
    );
  }
}
