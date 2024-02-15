
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_notification.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_scaffold.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';
import '../util/global_widgets/widget_text_field_title.dart';
import 'page_detail_notification.dart';

class PageNotifications extends StatelessWidget {
  const PageNotifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prNotificationsWatch = context.watch<ProviderNotification>();
    return WidgetScaffold(
      onPressed: () => Navigator.pop(context),
      widget: prNotificationsWatch.listNotification!.isEmpty &&
              !prNotificationsWatch.contList
          ? const Center(child: CircularProgressIndicator())
          : const Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [ListNotification()],
                ),
              ),
            ),
    );
  }
}

class ListNotification extends StatelessWidget {
  const ListNotification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prNotificationsRead = context.read<ProviderNotification>();

    return !prNotificationsRead.contList
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WidgetTextFieldTitle(
                  title: GlobalLabel.textNew, align: TextAlign.left),
              SizedBox(
                height: MediaQuery.of(GlobalFunction.context.currentContext!).size.height,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: prNotificationsRead.listNotification!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        prNotificationsRead.detailNotification(index);
                        GlobalFunction().nextPageViewTransition(const PageDetailNotification());
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: GlobalColors.colorWhite,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 0,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: GlobalFunction().getImageNotification(
                                    prNotificationsRead
                                        .listNotification![index].imageBulletin!,
                                    55.0,
                                    50.0),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(right: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Visibility(
                                        visible: prNotificationsRead
                                            .listNotification![index].lP!.isNotEmpty,
                                        child: const WidgetTextFieldTitle(
                                            title: GlobalLabel.textSurveyInvitation,
                                            align: TextAlign.left)),
                                    WidgetTextFieldTitle(
                                        title: prNotificationsRead
                                            .listNotification![index].bulletin!,
                                        align: TextAlign.left),
                                    WidgetTextFieldSubTitle(
                                        title: prNotificationsRead.listNotification![index].bond ?? "",
                                        align: TextAlign.left)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          )
        : GlobalFunction().noResult(GlobalLabel.textNoResult);
  }
}


