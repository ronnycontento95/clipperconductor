import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_retrieve_password.dart';
import '../provider/provider_service/provider_service_rest.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_button.dart';
import '../util/global_widgets/widget_message_page.dart';
import '../util/global_widgets/widget_scaffold.dart';
import '../util/global_widgets/widget_text_field_edit.dart';

class PageRetrievePassword extends StatelessWidget {
  const PageRetrievePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidgetScaffold(
        onPressed: () => Navigator.pop(context),
        widget: const Column(
          children: [
            WidgetMessagePage(
                title: GlobalLabel.textTitleRetrievePassword,
                message: GlobalLabel.textDescriptionRetrievePassword),
            FormRetrievePassword(),
            ButtonSendRetrievePassword()
          ],
        ));
  }
}

class FormRetrievePassword extends StatelessWidget {
  const FormRetrievePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prRetrievePasswordRead = context.read<ProviderRetrievePassword>();
    return Container(
      margin: const EdgeInsets.only(top: 40, left: 30, right: 30),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: WidgetTextFieldEdit(
              identifier: prRetrievePasswordRead.editPhone,
              limitCharacter: 45,
              typeKeyBoard: TextInputType.phone,
              icon: Icons.credit_card,
              hintText: GlobalLabel.textDni,
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonSendRetrievePassword extends StatelessWidget {
  const ButtonSendRetrievePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prServiceRestRead = context.read<ProviderServiceRest>();
    return Container(
      alignment: Alignment.bottomCenter,
      margin: const EdgeInsets.only(left: 30, right: 30),
      child: WidgetButton(
          text: GlobalLabel.buttonRetrieve,
          type: 1,
          onPressed: () {
            prServiceRestRead.sendRetrievePassword(context);
          }),
    );
  }
}
