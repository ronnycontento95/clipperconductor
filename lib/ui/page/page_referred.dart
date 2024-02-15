import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_principal.dart';
import '../provider/provider_referred.dart';
import '../util/global_colors.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_button.dart';
import '../util/global_widgets/widget_container.dart';
import '../util/global_widgets/widget_message_page.dart';
import '../util/global_widgets/widget_scaffold.dart';
import '../util/global_widgets/widget_text_field_personalized.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';
import '../util/global_widgets/widget_text_field_title.dart';

class PageReferred extends StatelessWidget {
  const PageReferred({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetScaffold(
        onPressed: () => Navigator.pop(context),
        widget: const SingleChildScrollView(
          child: Column(
            children: [
              WidgetMessagePage(
                  title: GlobalLabel.textInviteFriend,
                  message: GlobalLabel.textDescriptionReferred),
              CodeReferred(),
              ListMessageReferred()
            ],
          ),
        ));
  }
}

class ListMessageReferred extends StatelessWidget {
  const ListMessageReferred({super.key});

  @override
  Widget build(BuildContext context) {
    final prReferredRead = context.read<ProviderReferred>();
    return Visibility(
      visible: prReferredRead.listMessageReferred!.isNotEmpty,
      child: Container(
        margin: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: prReferredRead.listMessageReferred!.length,
              itemBuilder: (context, index) {
                return WidgetContainer(
                    widget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const WidgetTextFieldTitle(
                            title: GlobalLabel.textReferredWinner,
                            align: TextAlign.left),
                        const SizedBox(height: 10),
                        WidgetTextFieldSubTitle(
                            title: prReferredRead
                                .listMessageReferred![index].message!,
                            align: TextAlign.left),
                      ],
                    ),
                    color: GlobalColors.colorWhite);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SendReferred extends StatelessWidget {
  const SendReferred({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(30),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          color: GlobalColors.colorBackground,
        ),
        child: const Row(
          children: [
            Expanded(
                child: WidgetTextFieldSubTitle(
                    title: GlobalLabel.textCodeSend, align: TextAlign.left)),
            Expanded(
                flex: 0,
                child: WidgetTextFieldTitle(title: '0', align: TextAlign.right))
          ],
        ),
      ),
    );
  }
}

class CodeReferred extends StatelessWidget {
  const CodeReferred({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prReferredRead = context.read<ProviderReferred>();
    return Container(
        margin: const EdgeInsets.only(top: 40, left: 30, right: 30),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: GlobalColors.colorBorder.withOpacity(.5),
                blurRadius: 5.0,
              ),
            ],
            borderRadius: BorderRadius.circular(20.0),
            border:
                Border.all(width: .5, color: GlobalColors.colorBackgroundBlue),
            color: GlobalColors.colorBackgroundBlue),
        child: Column(
          children: [
            const WidgetTextFieldPersonalized(
                color: GlobalColors.colorWhite,
                type: 2,
                size: 14,
                title: GlobalLabel.textCodeInvitation,
                align: TextAlign.left),
            const SizedBox(height: 10),
            WidgetTextFieldPersonalized(
                type: 1,
                title: prPrincipalRead.modelUser.vehiclePlate!,
                align: TextAlign.center,
                size: 50,
                color: GlobalColors.colorWhite),
            WidgetButton(
                text: GlobalLabel.textShared,
                type: 1,
                onPressed: () {
                  prReferredRead
                      .sharedCode(prPrincipalRead.modelUser.vehiclePlate!);
                })
          ],
        ));
  }
}
