import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_pre_register.dart';
import '../provider/provider_service/provider_service_rest.dart';
import '../util/global_colors.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_button.dart';
import '../util/global_widgets/widget_message_page.dart';
import '../util/global_widgets/widget_scaffold.dart';
import '../util/global_widgets/widget_text_field_edit.dart';

class PageRegisterName extends StatefulWidget {
  const PageRegisterName({Key? key}) : super(key: key);

  @override
  State<PageRegisterName> createState() => _PageRegisterNameState();
}

class _PageRegisterNameState extends State<PageRegisterName> {
  @override
  void initState() {
    super.initState();
    context.read<ProviderServiceRest>().consultCountry(context);
  }

  @override
  Widget build(BuildContext context) {
    return WidgetScaffold(
        onPressed: () => Navigator.pop(context),
        widget: const Column(
          children: [
            WidgetMessagePage(
                title: GlobalLabel.textNameLastName,
                message: GlobalLabel.textDescriptionNameLastName),
            Forms(),
          ],
        ));
  }
}

class Forms extends StatelessWidget {
  const Forms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prPreRegisterRead = context.read<ProviderPreRegister>();
    return Container(
      margin: const EdgeInsets.only(top: 40, right: 30, left: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: GlobalColors.colorWhite,
      ),
      child: Column(
        children: [
          WidgetTextFieldEdit(
              identifier: prPreRegisterRead.editName,
              limitCharacter: 45,
              typeKeyBoard: TextInputType.text,
              icon: Icons.person_2_rounded,
              hintText: GlobalLabel.textName),
          WidgetTextFieldEdit(
              identifier: prPreRegisterRead.editLastName,
              limitCharacter: 45,
              typeKeyBoard: TextInputType.text,
              icon: Icons.person_2_rounded,
              hintText: GlobalLabel.textLastName),
          const ButtonNext()
        ],
      ),
    );
  }
}

class ButtonNext extends StatelessWidget {
  const ButtonNext({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prPreRegisterRead = context.read<ProviderPreRegister>();
    return WidgetButton(
        text: GlobalLabel.buttonNext,
        type: 1,
        onPressed: () {
          prPreRegisterRead.validateTextFieldName(context);
        });
  }
}
