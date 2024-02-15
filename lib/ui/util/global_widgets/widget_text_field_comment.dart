import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../global_colors.dart';

class WidgetTextFieldComment extends StatelessWidget {
  const WidgetTextFieldComment(
      {super.key,
      required this.identifier,
      required this.limitCharacter,
      required this.type,
      required this.hintText,
      required this.icon});

  final TextEditingController identifier;
  final int limitCharacter;
  final TextInputType type;
  final String hintText;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: identifier,
      autocorrect: true,
      autofocus: false,
      minLines: 1,
      maxLines: 8,
      textCapitalization: TextCapitalization.sentences,
      inputFormatters: [
        LengthLimitingTextInputFormatter(limitCharacter),
      ],
      keyboardType: type,
      style:
          TextStyle(color: GlobalColors.colorLetterTitle.withOpacity(.8)),
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.only(top: 10.0),
        prefixIcon: Icon(icon),
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
    );
  }
}
