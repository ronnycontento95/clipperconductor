import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../global_colors.dart';
import '../global_label.dart';
import 'widget_icon.dart';

class WidgetTextFieldEdit extends StatelessWidget {
  const WidgetTextFieldEdit({
    super.key,
    required this.identifier,
    required this.limitCharacter,
    required this.typeKeyBoard,
    required this.icon,
    required this.hintText,
    this.validator,
  });

  final TextEditingController identifier;
  final int limitCharacter;
  final TextInputType typeKeyBoard;
  final String hintText;
  final IconData icon;
  final String? Function(String? value)? validator;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 60.0,
        child: TextFormField(
          controller: identifier,
          autocorrect: true,
          autofocus: false,
          validator: validator,
          inputFormatters: [
            LengthLimitingTextInputFormatter(limitCharacter),
          ],
          keyboardType: typeKeyBoard,
          style: TextStyle(
              color: GlobalColors.colorLetterTitle.withOpacity(.8),
              fontWeight: FontWeight.bold,
              fontFamily: GlobalLabel.typeLetterSubTitle),
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: const EdgeInsets.only(top: 10.0),
            prefixIcon: WidgetIcon(
                icon: icon, size: 20, colors: GlobalColors.colorLetterTitle),
            hintStyle: TextStyle(
                color: GlobalColors.colorLetterSubTitle.withOpacity(.3)),
            filled: true,
            fillColor: GlobalColors.colorBorder.withOpacity(.3),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              borderSide:
                  BorderSide(color: GlobalColors.colorBorder, width: .5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              borderSide: BorderSide(
                  color: GlobalColors.colorBorder.withOpacity(.6), width: .5),
            ),
          ),
        ));
  }
}
