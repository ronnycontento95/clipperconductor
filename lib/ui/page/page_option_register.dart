import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_pre_register.dart';
import '../provider/provider_service/provider_service_rest.dart';
import '../util/global_colors.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_button.dart';
import '../util/global_widgets/widget_divider.dart';
import '../util/global_widgets/widget_message_page.dart';
import '../util/global_widgets/widget_scaffold.dart';
import '../util/global_widgets/widget_text_field_edit.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';

class PageOptionRegister extends StatelessWidget {
  const PageOptionRegister({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidgetScaffold(
      onPressed: () => Navigator.pop(context),
      widget: const SingleChildScrollView(
        child: Column(
          children: [
            WidgetMessagePage(
                title: GlobalLabel.textMotiveRegister,
                message: GlobalLabel.textTypeRegister),
            Form(),
          ],
        ),
      ),
    );
  }
}

class ButtonNext extends StatelessWidget {
  const ButtonNext({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prServiceRestRead = context.read<ProviderServiceRest>();
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: WidgetButton(
          text: GlobalLabel.buttonNext,
          type: 1,
          onPressed: () {
            prServiceRestRead.validateCodeReferred(context);
          }),
    );
  }
}

class Form extends StatelessWidget {
  const Form({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prPreRegisterRead = context.read<ProviderPreRegister>();
    final prPreRegisterWatch = context.watch<ProviderPreRegister>();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: GlobalColors.colorWhite,
      ),
      margin: const EdgeInsets.only(top: 40, left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetTextFieldEdit(
              identifier: prPreRegisterRead.editCommentary,
              limitCharacter: 100,
              typeKeyBoard: TextInputType.multiline,
              icon: Icons.edit,
              hintText: GlobalLabel.textReason),
          const SizedBox(
            height: 10,
          ),
          const WidgetTextFieldSubTitle(
              title: GlobalLabel.textCodeReferred, align: TextAlign.left),
          const SizedBox(
            height: 10,
          ),
          WidgetTextFieldEdit(
              identifier: prPreRegisterRead.editReferred,
              limitCharacter: 10,
              typeKeyBoard: TextInputType.text,
              icon: Icons.code,
              hintText: GlobalLabel.textCodeReferred),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                flex: 0,
                child: SizedBox(
                  width: 20,
                  child: Checkbox(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      value: prPreRegisterRead.optionRegisterOne,
                      activeColor: GlobalColors.colorButton,
                      onChanged: (state) {
                        prPreRegisterRead.addMotive(state!, 1);
                      }),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: const WidgetTextFieldSubTitle(
                        title: GlobalLabel.textMotiveOne,
                        align: TextAlign.left),
                  )),
            ],
          ),
          const WidgetDivider(),
          Row(
            children: [
              Expanded(
                flex: 0,
                child: SizedBox(
                  width: 20,
                  height: 50,
                  child: Checkbox(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      value: prPreRegisterWatch.optionRegisterTwo,
                      activeColor: GlobalColors.colorButton,
                      onChanged: (state) {
                        prPreRegisterWatch.addMotive(state!, 2);
                      }),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: const WidgetTextFieldSubTitle(
                        title: GlobalLabel.textMotiveTwo,
                        align: TextAlign.left),
                  )),
            ],
          ),
          const ButtonNext()
        ],
      ),
    );
  }
}
