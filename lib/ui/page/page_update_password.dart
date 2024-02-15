
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_service/provider_service_rest.dart';
import '../provider/provider_update_password.dart';
import '../util/global_colors.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_button.dart';
import '../util/global_widgets/widget_container.dart';
import '../util/global_widgets/widget_message_page.dart';
import '../util/global_widgets/widget_scaffold.dart';
import '../util/global_widgets/widget_text_field_edit_password.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';

class PageUpdatePassword extends StatelessWidget {
  const PageUpdatePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidgetScaffold(
      onPressed: () => Navigator.pop(context),
      widget: const SingleChildScrollView(
        child: Column(
          children: [
            WidgetMessagePage(
                title: GlobalLabel.textTitleUpdatePassword,
                message: GlobalLabel.textDescriptionPassword),
            FormResetPassword(),
            ButtonSavePassword()
          ],
        ),
      ),
    );
  }
}

class FormResetPassword extends StatelessWidget {
  const FormResetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prProviderUpdatePasswordRead = context.read<ProviderUpdatePassword>();
    return Container(
        margin: const EdgeInsets.only(top: 40, right: 30, left: 30),
        child: WidgetContainer(
          color: GlobalColors.colorWhite,
          widget: Column(
            children: [
              WidgetTextFieldEditPassword(
                  identifier: prProviderUpdatePasswordRead.editFormerPassword,
                  limitCharacter: 10,
                  typeKeyBoard: TextInputType.text,
                  icon: Icons.key,
                  hintText: GlobalLabel.textFormerPassword),
              const SizedBox(height: 10),
              WidgetTextFieldEditPassword(
                  identifier: prProviderUpdatePasswordRead.editNewPassword,
                  limitCharacter: 10,
                  typeKeyBoard: TextInputType.text,
                  icon: Icons.key,
                  hintText: GlobalLabel.textNewPassword),
              const SizedBox(
                height: 20,
              ),
              const WidgetTextFieldSubTitle(
                  title: GlobalLabel.textExit, align: TextAlign.center)
            ],
          ),
        ));
  }
}

class ButtonSavePassword extends StatelessWidget {
  const ButtonSavePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prServiceRestRead = context.read<ProviderServiceRest>();

    return Container(
      margin: const EdgeInsets.only(top: 10, right: 30, left: 30),
      child: WidgetButton(
        text: GlobalLabel.buttonUpdatePassword,
        type: 1,
        onPressed: () {
          prServiceRestRead.sendUpdatePassword(context);
        },
      ),
    );
  }
}
