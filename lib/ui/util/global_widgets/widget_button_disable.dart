import 'package:flutter/material.dart';

import '../global_colors.dart';
import '../global_label.dart';

class WidgetButtonDisable extends StatelessWidget {
  const WidgetButtonDisable({
    super.key,
    required this.text,
    required this.type,
    required this.onPressed,
  });

  final VoidCallback onPressed;
  final String text;
  final int type;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 45,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: type == 1
                  ? GlobalColors.colorButton
                  : GlobalColors.colorBorder,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 1,
                    color: type == 1
                        ? GlobalColors.colorButton
                        : GlobalColors.colorBorder),
                borderRadius: BorderRadius.circular(10.0),
              )),
          onPressed: type == 1 ? onPressed : null,
          child: Text(text,
              style: TextStyle(
                  fontFamily: GlobalLabel.typeLetterTitle,
                  color: type == 1
                      ? GlobalColors.colorBorder
                      : GlobalColors.colorWhite,
                  fontSize: 16),
              textAlign: TextAlign.center)),
    );
  }
}
