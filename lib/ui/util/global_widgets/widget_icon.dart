import 'package:flutter/material.dart';


class WidgetIcon extends StatelessWidget {
  const WidgetIcon(
      {super.key,
      required this.icon,
      required this.size,
      required this.colors});

  final IconData icon;
  final double size;
  final Color colors;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: colors, size: size);
  }
}
