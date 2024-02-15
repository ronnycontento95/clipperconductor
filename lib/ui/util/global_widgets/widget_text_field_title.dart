import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';

import '../global_colors.dart';
import '../global_label.dart';

class WidgetTextFieldTitle extends StatelessWidget {
  const WidgetTextFieldTitle(
      {super.key, required this.title, required this.align});

  final String title;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      title,
      style: const TextStyle(
        fontSize: 15,
        color: GlobalColors.colorLetterTitle,
        fontFamily: GlobalLabel.typeLetterTitle,
      ),
      textAlign: align,
    );
  }
}
