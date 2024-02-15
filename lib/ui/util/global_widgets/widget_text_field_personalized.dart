import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../global_label.dart';

class WidgetTextFieldPersonalized extends StatelessWidget {
  const WidgetTextFieldPersonalized(
      {super.key,
      required this.title,
      required this.align,
      required this.size,
      required this.color,
      required this.type});

  final String title;
  final TextAlign align;
  final double size;
  final Color color;
  final int type;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(title,
        maxFontSize: size,
        style: TextStyle(
          color: color,
          fontFamily: type == 1
              ? GlobalLabel.typeLetterTitle
              : GlobalLabel.typeLetterSubTitle,
          fontSize: size,
        ),
        textAlign: align);
  }
}
