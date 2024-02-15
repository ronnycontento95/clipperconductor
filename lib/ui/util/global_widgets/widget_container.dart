import 'package:flutter/material.dart';

import '../global_colors.dart';

class WidgetContainer extends StatelessWidget {
  const WidgetContainer({super.key, required this.widget, required this.color});

  final Widget widget;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          color: color,
          border: Border.all(width: .1, color: GlobalColors.colorWhite),
          boxShadow: [
            BoxShadow(
              color: GlobalColors.colorBorder.withOpacity(.5),
              blurRadius: 5.0,
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: widget);
  }
}
