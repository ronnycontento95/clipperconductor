import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../global_colors.dart';
import '../global_label.dart';

class WidgetTextButton extends StatelessWidget {
  const WidgetTextButton({super.key, required this.title, required this.type});

  final String title;
  final int type;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(title,
        style: TextStyle(
            fontFamily: GlobalLabel.typeLetterTitle,
            color:
                type == 1 ? GlobalColors.colorWhite : GlobalColors.colorBlack,
            fontSize: 14),
        textAlign: TextAlign.center);
  }
}
