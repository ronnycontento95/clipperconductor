
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_canceled_user.dart';
import '../util/global_colors.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_button.dart';
import '../util/global_widgets/widget_container.dart';
import '../util/global_widgets/widget_message_page.dart';
import '../util/global_widgets/widget_scaffold.dart';
import '../util/global_widgets/widget_text_field_comment.dart';
import '../util/global_widgets/widget_text_field_personalized.dart';

class PageCanceledUser extends StatelessWidget {
  const PageCanceledUser({super.key, required this.requestId});

  final int requestId;

  @override
  Widget build(BuildContext context) {
    return WidgetScaffold(
        onPressed: () {
          Navigator.pop(context);
        },
        widget: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const WidgetMessagePage(
                      title: GlobalLabel.textTitleCanceledService,
                      message: GlobalLabel.textDescriptionCanceledService),
                  ContentComment(requestId: requestId)
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.only(left: 30, right: 30),
                height: 60,
                color: GlobalColors.colorBackground,
                alignment: Alignment.center,
                child: const WidgetTextFieldPersonalized(
                    color: GlobalColors.colorLetterTitle,
                    type: 2,
                    size: 14,
                    title: GlobalLabel.textDescriptionSanction,
                    align: TextAlign.center),
              ),
            ),
          ],
        ));
  }
}

class ContentComment extends StatelessWidget {
  const ContentComment({super.key, required this.requestId});

  final int requestId;

  @override
  Widget build(BuildContext context) {
    final prCanceledUserRead = context.read<ProviderCanceledUser>();
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30, top: 40),
      child: WidgetContainer(
        color: GlobalColors.colorWhite,
        widget: Column(
          children: [
            WidgetTextFieldComment(
                identifier: prCanceledUserRead.editComment,
                limitCharacter: 245,
                type: TextInputType.text,
                hintText: GlobalLabel.textCanceledComment,
                icon: Icons.sms),
            const SizedBox(height: 20),
            WidgetButton(
                text: GlobalLabel.buttonSendReport,
                type: 1,
                onPressed: () {
                  prCanceledUserRead.qualificationUser(context, requestId);
                })
          ],
        ),
      ),
    );
  }
}
