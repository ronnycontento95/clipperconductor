import 'package:flutter/material.dart';

import '../global_colors.dart';
import 'widget_text_field_personalized.dart';
import 'widget_text_field_sub_title.dart';

class WidgetMessagePage extends StatelessWidget {
  const WidgetMessagePage(
      {super.key, required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetTextFieldPersonalized(
              type: 1,
              title: title,
              align: TextAlign.left,
              size: 25,
              color: GlobalColors.colorLetterTitle),
          const SizedBox(
            height: 10,
          ),
          WidgetTextFieldSubTitle(title: message, align: TextAlign.left),
        ],
      ),
    );
  }
}
