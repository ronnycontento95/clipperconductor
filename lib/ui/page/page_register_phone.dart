import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

import '../provider/provider_pre_register.dart';
import '../util/global_colors.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_button.dart';
import '../util/global_widgets/widget_message_page.dart';
import '../util/global_widgets/widget_scaffold.dart';

var _formKey = GlobalKey<FormState>();

class PageRegisterPhone extends StatelessWidget {
  const PageRegisterPhone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prPreRegisterRead = context.read<ProviderPreRegister>();

    return WidgetScaffold(
        onPressed: () => Navigator.pop(context),
        widget: SingleChildScrollView(
          child: Column(
            children: [
              const WidgetMessagePage(
                  title: GlobalLabel.textNumberPhone,
                  message: GlobalLabel.textDescriptionNumberPhone),
              Form(
                key: _formKey,
                child: Container(
                  margin: const EdgeInsets.only(top: 40, left: 30, right: 30),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    color: GlobalColors.colorWhite,
                  ),
                  child: Column(
                    children: [
                      InternationalPhoneNumberInput(
                        validator: (value) {
                          if(value != null){
                          return prPreRegisterRead.validatePhone(context, prPreRegisterRead.codeCountry.dialCode!, value);
                          }
                          return null;
                        },
                        autoFocus: false,
                        cursorColor: GlobalColors.colorLetterTitle,
                        inputDecoration: InputDecoration(
                          fillColor: GlobalColors.colorBorder.withOpacity(.3),
                          hintStyle: TextStyle(
                              color: GlobalColors.colorLetterSubTitle
                                  .withOpacity(.3)),
                          filled: true,
                          enabledBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(
                                color: GlobalColors.colorBorder, width: .5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(
                                color: GlobalColors.colorBorder.withOpacity(.6),
                                width: .5),
                          ),
                        ),
                        onInputChanged: (PhoneNumber number) {},
                        onInputValidated: (bool value) {},
                        selectorConfig: const SelectorConfig(
                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        ),
                        ignoreBlank: true,
                        autoValidateMode: AutovalidateMode.disabled,
                        selectorTextStyle: const TextStyle(
                          color: GlobalColors.colorBlack,
                        ),
                        textStyle: TextStyle(
                            color:
                                GlobalColors.colorLetterTitle.withOpacity(.8),
                            fontWeight: FontWeight.bold,
                            fontFamily: GlobalLabel.typeLetterSubTitle),
                        initialValue: prPreRegisterRead.codeCountry,
                        textFieldController: prPreRegisterRead.editNumber,
                        formatInput: false,
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        onSaved: (PhoneNumber number) {},
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(left: 30, right: 30, top: 10),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          color: GlobalColors.colorWhite,
                        ),
                        child: WidgetButton(
                            text: GlobalLabel.buttonNext,
                            type: 1,
                            onPressed: () {
                              if(_formKey.currentState!.validate())return;
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
