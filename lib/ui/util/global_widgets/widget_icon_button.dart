import 'package:flutter/material.dart';

import '../global_colors.dart';
import 'widget_icon.dart';

class WidgetIconButton extends StatelessWidget {
  const WidgetIconButton(
      {super.key,
      required this.onPressed,
      required this.icon,
      required this.size,
      required this.color});

  final IconData icon;
  final double size;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        color: GlobalColors.colorWhite,
        padding: EdgeInsets.zero,
        icon: WidgetIcon(icon: icon, size: size, colors: color),
        onPressed: onPressed);
  }
}
