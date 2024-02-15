import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

import '../global_colors.dart';

class WidgetDividerVertical extends StatelessWidget {
  const WidgetDividerVertical({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      child: DottedLine(
        direction: Axis.vertical,
        lineLength: double.infinity,
        lineThickness: 1.5,
        dashLength: 4.0,
        dashColor: GlobalColors.colorBackgroundView.withOpacity(.5),
        dashRadius: 0.0,
        dashGapLength: 4.0,
        dashGapColor: Colors.transparent,
        dashGapRadius: 0.0,
      ),
    );
  }
}
