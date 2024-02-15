
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_history_request.dart';
import '../provider/provider_principal.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_container.dart';
import '../util/global_widgets/widget_divider.dart';
import '../util/global_widgets/widget_scaffold.dart';
import '../util/global_widgets/widget_text_field_personalized.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';
import '../util/global_widgets/widget_text_field_title.dart';

class PageHistoryDay extends StatefulWidget {
  const PageHistoryDay({Key? key}) : super(key: key);

  @override
  State<PageHistoryDay> createState() => _PageHistoryDayState();
}

class _PageHistoryDayState extends State<PageHistoryDay> {
  @override
  void initState() {
    super.initState();
    if (context.read<ProviderHistoryRequest>().typeConsult == 0) {
      context.read<ProviderHistoryRequest>().resetMonth();
      context.read<ProviderHistoryRequest>().formatMonth();
      context.read<ProviderHistoryRequest>().resetSelection();
    }
  }

  @override
  Widget build(BuildContext context) {
    final prHistoryRequestWatch = context.watch<ProviderHistoryRequest>();
    return WidgetScaffold(
        onPressed: () {
          Navigator.pop(context);
        },
        widget: Column(
          children: [
            const Expanded(flex: 0, child: DetailHistory()),
            Expanded(
                child: prHistoryRequestWatch.positionSelectedRequest == 1
                    ? const ListHistoryRequest()
                    : const ListHistoryOrder()),
          ],
        ));
  }
}

class ListHistoryOrder extends StatelessWidget {
  const ListHistoryOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prHistoryRequestRead = context.read<ProviderHistoryRequest>();
    final prHistoryRequestWatch = context.watch<ProviderHistoryRequest>();
    final prPrincipalRead = context.read<ProviderPrincipal>();

    return !prHistoryRequestWatch.contListOrder
        ? ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: prHistoryRequestRead.listHistoryOrder!.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidgetTextFieldTitle(
                        title:
                            '${prHistoryRequestRead.listHistoryOrder![index].dayRegister!} ${prHistoryRequestRead.formatDateHistory()} ${GlobalFunction().formatHourHistory(prHistoryRequestRead.listHistoryOrder![index].hour!)}',
                        align: TextAlign.left),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WidgetTextFieldTitle(
                                  title: prHistoryRequestRead
                                      .listHistoryOrder![index].neighborhood!,
                                  align: TextAlign.left),
                              WidgetTextFieldSubTitle(
                                  title: prHistoryRequestRead
                                      .listHistoryOrder![index].principalStreet!
                                      .trim(),
                                  align: TextAlign.left),
                              WidgetTextFieldSubTitle(
                                  title: prHistoryRequestRead
                                      .listHistoryOrder![index].secondaryStreet!
                                      .trim(),
                                  align: TextAlign.left)
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              WidgetTextFieldSubTitle(
                                  title: prPrincipalRead.getTypePayHistory(
                                      prHistoryRequestRead
                                          .listHistoryOrder![index].typePay!),
                                  align: TextAlign.left),
                              Row(
                                children: [
                                  WidgetTextFieldTitle(
                                      title:
                                          '${prHistoryRequestRead.listHistoryOrder![index].price!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                                      align: TextAlign.left),
                                  const SizedBox(width: 5),
                                  prHistoryRequestRead.iconStateRequest(
                                      prHistoryRequestRead
                                          .listHistoryOrder![index].state!),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const WidgetDivider()
                  ],
                ),
              );
            },
          )
        : GlobalFunction().noResult(GlobalLabel.textNoResult);
  }
}

class DetailHistory extends StatelessWidget {
  const DetailHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prHistoryRequestRead = context.read<ProviderHistoryRequest>();
    final prPrincipalRead = context.read<ProviderPrincipal>();

    return Column(
      children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 5, left: 30, right: 30),
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
                          '${prHistoryRequestRead.gainHistory()} ${prPrincipalRead.nameMoney}',
                      align: TextAlign.left,
                      size: 30,
                      color: GlobalColors.colorWhite),
                  const WidgetDivider(),
                  const DriverStats(),
                ],
              ),
            ),
            const DateMonth(),
          ],
        ),
        Container(
            margin:
                const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
            child: const WidgetTextFieldPersonalized(
                    type: 2,
                    color: GlobalColors.colorLetterTitle,
                    size: 14,
                    title: GlobalLabel.textDescriptionHistoryRequest,
                    align: TextAlign.center)
                ),
      ],
    );
  }
}

class DateMonth extends StatelessWidget {
  const DateMonth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prHistoryRequestRead = context.read<ProviderHistoryRequest>();
    final prHistoryRequestWatch = context.watch<ProviderHistoryRequest>();

    return GestureDetector(
      onTap: () {
        prHistoryRequestRead.selectMonth(
            context, prHistoryRequestRead.positionSelectedRequest);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: GlobalColors.colorButton,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WidgetTextFieldPersonalized(
                type: 1,
                title: prHistoryRequestWatch.month,
                align: TextAlign.center,
                size: 20,
                color: GlobalColors.colorWhite),
            const SizedBox(width: 5),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: GlobalColors.colorWhite,
              size: 20,
            )
          ],
        ),
      ),
    );
  }
}

class ListHistoryRequest extends StatelessWidget {
  const ListHistoryRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prHistoryRequestRead = context.read<ProviderHistoryRequest>();
    final prPrincipalRead = context.read<ProviderPrincipal>();

    return !prHistoryRequestRead.contListRequest
        ? Container(
            margin: const EdgeInsets.only(left: 30, right: 30),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: prHistoryRequestRead.listHistoryRequest!.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: WidgetContainer(
                    color: GlobalColors.colorWhite,
                    widget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Container(
                              margin: const EdgeInsets.only(right: 20),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      WidgetTextFieldSubTitle(
                                          title:
                                              '${prHistoryRequestRead.listHistoryRequest![index].dayRegister!} ${prHistoryRequestRead.formatDateHistory()} ${GlobalFunction().formatHourHistory(prHistoryRequestRead.listHistoryRequest![index].hour!)}',
                                          align: TextAlign.left),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            WidgetTextFieldTitle(
                                                title: prHistoryRequestRead
                                                        .listHistoryRequest![
                                                            index]
                                                        .neighborhood!
                                                        .isNotEmpty
                                                    ? prHistoryRequestRead
                                                        .listHistoryRequest![
                                                            index]
                                                        .neighborhood!
                                                        .trim()
                                                    : GlobalLabel.textStranger,
                                                align: TextAlign.left),
                                            WidgetTextFieldSubTitle(
                                                title: prHistoryRequestRead
                                                    .listHistoryRequest![index]
                                                    .principalStreet!
                                                    .trim(),
                                                align: TextAlign.left),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                prHistoryRequestRead
                                                        .listHistoryRequest![
                                                            index]
                                                        .secondaryStreet!
                                                        .isNotEmpty
                                                    ? const WidgetDivider()
                                                    : Container(),
                                                WidgetTextFieldTitle(
                                                    title: prHistoryRequestRead
                                                        .listHistoryRequest![
                                                            index]
                                                        .secondaryStreet!
                                                        .trim(),
                                                    align: TextAlign.left),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                            Expanded(
                              flex: 0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  WidgetTextFieldSubTitle(
                                      title: prPrincipalRead.getTypePayHistory(
                                          prHistoryRequestRead
                                              .listHistoryRequest![index]
                                              .typePay!),
                                      align: TextAlign.left),
                                  WidgetTextFieldTitle(
                                      title:
                                          '${prHistoryRequestRead.listHistoryRequest![index].payment!.toStringAsFixed(2)}  ${prPrincipalRead.nameMoney}',
                                      align: TextAlign.right),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        : GlobalFunction().noResult(GlobalLabel.textNoResult);
  }
}

class DriverStats extends StatelessWidget {
  const DriverStats({super.key});

  @override
  Widget build(BuildContext context) {
    final prHistoryRequestWatch = context.watch<ProviderHistoryRequest>();
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
                    title: prHistoryRequestWatch.positionSelectedRequest == 1
                        ? '${prHistoryRequestWatch.listHistoryRequest!.length}'
                        : '${prHistoryRequestWatch.listHistoryOrder!.length}',
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
