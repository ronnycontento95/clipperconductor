import 'package:flutter/material.dart';

import '../global_colors.dart';
import 'widget_text_button.dart';

class WidgetButtonCancel extends StatelessWidget {
  const WidgetButtonCancel({
    super.key,
    required this.text,
    required this.onPressed,
    required this.type,
  });

  final VoidCallback onPressed;
  final String text;
  final int type;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        height: 45,
        width: double.infinity,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 0.0,
                backgroundColor: GlobalColors.colorWhite,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 1,
                      color: GlobalColors.colorButton.withOpacity(.5)),
                  borderRadius: BorderRadius.circular(10.0),
                )),
            onPressed: onPressed,
            child: WidgetTextButton(title: text.toUpperCase(), type: type)),
      ),
    );
  }
}
