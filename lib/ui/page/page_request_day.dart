import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/model_history_request_day.dart';
import '../provider/provider_principal.dart';
import '../provider/provider_request_day.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_container.dart';
import '../util/global_widgets/widget_divider.dart';
import '../util/global_widgets/widget_message_page.dart';
import '../util/global_widgets/widget_scaffold.dart';
import '../util/global_widgets/widget_text_field_personalized.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';
import '../util/global_widgets/widget_text_field_title.dart';

class PageRequestDay extends StatelessWidget {
  const PageRequestDay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidgetScaffold(
      onPressed: () {
        Navigator.pop(context);
      },
      widget: const Column(
        children: [
          Expanded(
              flex: 0,
              child: Column(
                children: [
                  WidgetMessagePage(
                      title: GlobalLabel.textTitleHistoryDay,
                      message: GlobalLabel.textDescriptionHistoryDay),
                  DetailHistory(),
                ],
              )),
          Expanded(
            flex: 1,
            child: ListHistoryRequestDay(),
          ),
        ],
      ),
    );
  }
}

class DetailHistory extends StatelessWidget {
  const DetailHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prRequestDayRead = context.read<ProviderRequestDay>();
    final prRequestDayWatch = context.watch<ProviderRequestDay>();
    final prPrincipalRead = context.read<ProviderPrincipal>();
    return Visibility(
      visible: !prRequestDayRead.contList,
      child: Container(
        margin: const EdgeInsets.only(top: 40, right: 30, left: 30),
        child: Column(
          children: [
            Container(
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
                  border: Border.all(
                      width: .5, color: GlobalColors.colorBackgroundBlue),
                  color: GlobalColors.colorBackgroundBlue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const WidgetTextFieldPersonalized(
                      type: 1,
                      title: GlobalLabel.textTotalGain,
                      align: TextAlign.left,
                      size: 14,
                      color: GlobalColors.colorWhite),
                  WidgetTextFieldPersonalized(
                      type: 1,
                      title:
                          '${prRequestDayWatch.gainHistory()} ${prPrincipalRead.nameMoney}',
                      align: TextAlign.left,
                      size: 30,
                      color: GlobalColors.colorWhite),
                  const WidgetDivider(),
                  const DriverStats(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const WidgetTextFieldPersonalized(
                type: 2,
                color: GlobalColors.colorLetterTitle,
                size: 14,
                title: GlobalLabel.textDescriptionHistoryRequest,
                align: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class ListHistoryRequestDay extends StatelessWidget {
  const ListHistoryRequestDay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prRequestDayRead = context.watch<ProviderRequestDay>();
    return !prRequestDayRead.contList
        ? Container(
            margin: const EdgeInsets.only(top: 20, left: 30, right: 30),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: prRequestDayRead.typeConsult == 0
                  ? prRequestDayRead.listRequestDay!.length
                  : prRequestDayRead.listFilterRequestDay!.length,
              itemBuilder: (context, index) {
                return ItemListHistoryRequestDay(
                  modelHistoryRequestDay: prRequestDayRead.typeConsult == 0
                      ? prRequestDayRead.listRequestDay![index]
                      : prRequestDayRead.listFilterRequestDay![index],
                );
              },
            ),
          )
        : GlobalFunction().noResult(GlobalLabel.textNoResult);
  }
}

class ItemListHistoryRequestDay extends StatelessWidget {
  const ItemListHistoryRequestDay({
    Key? key,
    required this.modelHistoryRequestDay,
  }) : super(key: key);

  final ModelHistoryRequestDay modelHistoryRequestDay;

  @override
  Widget build(BuildContext context) {
    final prRequestDayRead = context.read<ProviderRequestDay>();
    final prPrincipalRead = context.read<ProviderPrincipal>();
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: WidgetContainer(
        color: GlobalColors.colorWhite,
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidgetTextFieldSubTitle(
                        title:
                        '${modelHistoryRequestDay.dayRegister!} ${prRequestDayRead.formatDateHistory()} ${GlobalFunction().formatHourHistory(modelHistoryRequestDay.hour!)}',
                        align: TextAlign.left),
                    const SizedBox(height: 10),
                    WidgetTextFieldTitle(
                        title: modelHistoryRequestDay.neighborhood!.isNotEmpty
                            ? modelHistoryRequestDay.neighborhood!.trim()
                            : GlobalLabel.textStranger,
                        align: TextAlign.left),
                    WidgetTextFieldSubTitle(
                        title: modelHistoryRequestDay.principalStreet!.trim(),
                        align: TextAlign.left),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        modelHistoryRequestDay.secondaryStreet!.isNotEmpty
                            ? const WidgetDivider()
                            : Container(),
                        WidgetTextFieldTitle(
                            title:
                                modelHistoryRequestDay.secondaryStreet!.trim(),
                            align: TextAlign.left),
                      ],
                    )
                  ],
                )),
                Expanded(
                  flex: 0,
                  child: Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: Column(
                      children: [
                        WidgetTextFieldSubTitle(
                            title: prPrincipalRead.getTypePayHistory(
                                modelHistoryRequestDay.typePay!),
                            align: TextAlign.left),
                        WidgetTextFieldTitle(
                            title:
                                '${modelHistoryRequestDay.payment!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                            align: TextAlign.left)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DriverStats extends StatelessWidget {
  const DriverStats({super.key});

  @override
  Widget build(BuildContext context) {
    final prRequestDayRead = context.watch<ProviderRequestDay>();
    return Row(
      children: [
        const Expanded(
            child: WidgetTextFieldPersonalized(
                type: 1,
                size: 16,
                color: GlobalColors.colorWhite,
                title: GlobalLabel.textRequestNow,
                align: TextAlign.left)),
        Expanded(
            flex: 0,
            child: Row(
              children: [
                WidgetTextFieldPersonalized(
                    type: 1,
                    title: prRequestDayRead.typeConsult == 0
                        ? '${prRequestDayRead.listRequestDay!.length}'
                        : '${prRequestDayRead.listFilterRequestDay!.length}',
                    align: TextAlign.center,
                    size: 16,
                    color: GlobalColors.colorWhite),
                const SizedBox(width: 10),
              ],
            ))
      ],
    );
  }
}
