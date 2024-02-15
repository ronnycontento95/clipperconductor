import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_notification.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_button.dart';
import '../util/global_widgets/widget_scaffold.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';
import '../util/global_widgets/widget_text_field_title.dart';

class PageDetailNotification extends StatelessWidget {
  const PageDetailNotification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidgetScaffold(
        onPressed: () => Navigator.pop(context),
        widget: const SingleChildScrollView(
          child: Column(
            children: [Notification(), ButtonSendReply()],
          ),
        ));
  }
}

class Notification extends StatelessWidget {
  const Notification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prNotificationRead = context.read<ProviderNotification>();
    final prNotificationWatch = context.watch<ProviderNotification>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WidgetTextFieldTitle(
            title: prNotificationRead.notificationBusiness!.bulletin!,
            align: TextAlign.left),
        WidgetTextFieldSubTitle(
            title: prNotificationRead.notificationBusiness?.bond ?? "",
            align: TextAlign.left),
        Visibility(
          visible:  prNotificationWatch.notificationBusiness!.url == null ? false : true,
          child: GestureDetector(
            onTap: () {
              GlobalFunction()
                  .openLink(prNotificationRead.notificationBusiness!.url!);
            },
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: WidgetTextFieldSubTitle(
                  title: prNotificationRead.notificationBusiness?.url ?? "",
                  align: TextAlign.left),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        GlobalFunction().getImageURL(prNotificationRead.notificationBusiness!.imageBulletin!),
        Visibility(
          visible: prNotificationWatch.notificationBusiness!.lP!.isNotEmpty,
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            color: GlobalColors.colorRed,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: prNotificationRead.notificationBusiness!.lP!.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Expanded(
                      flex: 0,
                      child: SizedBox(
                        width: 40,
                        height: 80,
                        child: Checkbox(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            value: prNotificationWatch
                                .notificationBusiness!.lP![index].check,
                            activeColor: GlobalColors.colorButton,
                            onChanged: (state) {
                              prNotificationWatch.updateCheckQuestion(
                                  prNotificationRead.notificationBusiness!
                                      .lP![index].idQuestion!);
                            }),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: WidgetTextFieldSubTitle(
                            title:
                                '${prNotificationRead.notificationBusiness!.lP![index].question}',
                            align: TextAlign.left)),
                  ],
                );
              },
            ),
          ),
        ),
        Visibility(
          visible:
              prNotificationRead.notificationBusiness!.type == 3 ? true : false,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              color: GlobalColors.colorWhite,
              border: Border.all(
                width: 1.0,
                color: GlobalColors.colorBorder,
              ),
            ),
            child: TextField(
              controller: prNotificationRead.editReply,
              style: const TextStyle(
                  fontFamily: GlobalLabel.typeLetterTitle,
                  color: GlobalColors.colorLetterTitle),
              decoration: const InputDecoration.collapsed(
                  hintText: GlobalLabel.textWriteReply,
                  hintStyle: TextStyle(
                      fontFamily: GlobalLabel.typeLetterSubTitle,
                      color: GlobalColors.colorLetterSubTitle)),
            ),
          ),
        ),
      ],
    );
  }
}

class ButtonSendReply extends StatelessWidget {
  const ButtonSendReply({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prNotificationRead = context.read<ProviderNotification>();
    return Visibility(
      visible:
          prNotificationRead.notificationBusiness!.type == 1 ? false : true,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: WidgetButton(
            text: GlobalLabel.buttonSendReply,
            type: 1,
            onPressed: () => prNotificationRead.sendReplyNotification(context)),
      ),
    );
  }
}
