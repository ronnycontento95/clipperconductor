import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../provider/provider_login.dart';
import '../global_colors.dart';
import '../global_label.dart';
import 'widget_icon.dart';
import 'widget_icon_button.dart';

class WidgetTextFieldEditPassword extends StatelessWidget {
  const WidgetTextFieldEditPassword(
      {super.key,
      required this.identifier,
      required this.limitCharacter,
      required this.typeKeyBoard,
      required this.icon,
      required this.hintText});

  final TextEditingController identifier;
  final int limitCharacter;
  final TextInputType typeKeyBoard;
  final String hintText;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final prLogInWatch = context.watch<ProviderLogin>();
    final prLogInRead = context.read<ProviderLogin>();
    return Container(
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              width: .5,
              color: GlobalColors.colorBorder,
            ),
            color: GlobalColors.colorBorder.withOpacity(.3)),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: identifier,
                autocorrect: true,
                autofocus: false,
                obscureText: prLogInWatch.stateShowEditPassword,
                keyboardType: typeKeyBoard,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(limitCharacter),
                ],
                style: TextStyle(
                    color: GlobalColors.colorLetterTitle.withOpacity(.8),
                    fontWeight: FontWeight.bold,
                    fontFamily: GlobalLabel.typeLetterSubTitle),
                decoration: InputDecoration(
                  hintText: hintText,
                  contentPadding: const EdgeInsets.only(top: 10.0),
                  prefixIcon: WidgetIcon(
                      icon: icon,
                      size: 20,
                      colors: GlobalColors.colorLetterTitle),
                  hintStyle: TextStyle(
                      color: GlobalColors.colorLetterSubTitle.withOpacity(.3)),
                  filled: true,
                  fillColor: Colors.transparent,
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    borderSide:
                        BorderSide(color: Colors.transparent, width: .5),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 0,
              child: WidgetIconButton(
                  onPressed: () {
                    prLogInRead.showPassword();
                  },
                  icon: Icons.password_outlined,
                  size: 25,
                  color: GlobalColors.colorLetterTitle),
            )
          ],
        ));
  }
}
