import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class AppIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroundcolor;
  final Color iconColor;
  final double size;
  final double iconSize;
  const AppIcon({super.key, required this.icon, this.backgroundcolor=const Color(0xFFfcf4e4),this.iconColor=const Color(0xFF756d54), this.size=35, this.iconSize=16, });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size),
        color: backgroundcolor
      ),
      child: Icon(
        icon,color: iconColor,size: iconSize,
      ),
    );
  }
}
