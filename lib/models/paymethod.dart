import 'package:flutter/cupertino.dart';

class PaymentMethod {
  final String id;
  final String name;
  final String subtitle; // Amount
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.backgroundColor,

  });
}