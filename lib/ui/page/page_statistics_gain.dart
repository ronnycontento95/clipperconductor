import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
import 'page_request_day.dart';

class PageStatisticsGain extends StatefulWidget {
  const PageStatisticsGain({Key? key}) : super(key: key);

  @override
  State<PageStatisticsGain> createState() => _PageStatisticsGainState();
}

class _PageStatisticsGainState extends State<PageStatisticsGain> {
  @override
  Widget build(BuildContext context) {
    return WidgetScaffold(
        onPressed: () => Navigator.pop(context),
        widget: const SingleChildScrollView(
          child: Column(
            children: [
              WidgetMessagePage(
                  title: GlobalLabel.textTitleGainNow,
                  message: GlobalLabel.textDescriptionGainNow),
              DetailGain(),
              ItemGain()
            ],
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
  }
}

class DetailGain extends StatelessWidget {
  const DetailGain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prRequestDayWatch = context.watch<ProviderRequestDay>();
    final prPrincipalRead = context.read<ProviderPrincipal>();
    return Container(
        margin: const EdgeInsets.only(left: 30, right: 30, top: 40),
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
                          '${prRequestDayWatch.gainRequest.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                      align: TextAlign.left,
                      size: 30,
                      color: GlobalColors.colorWhite),
                  const WidgetDivider(),
                  const DriverStats(),
                ],
              ),
            ),
            const Calendar(),
          ],
        ));
  }
}

class DriverStats extends StatelessWidget {
  const DriverStats({super.key});

  @override
  Widget build(BuildContext context) {
    final prRequestDayWatch = context.watch<ProviderRequestDay>();
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
                    title: '${prRequestDayWatch.numRequest}',
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

class Calendar extends StatelessWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prRequestDayWatch = context.watch<ProviderRequestDay>();

    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: GestureDetector(
        onTap: () {
          prRequestDayWatch.selectDate(context);
        },
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 10),
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
                title: prRequestDayWatch.dayHistory,
                align: TextAlign.center,
                color: GlobalColors.colorWhite,
                size: 20,
              ),
              const SizedBox(width: 5),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: GlobalColors.colorWhite,
                size: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ItemGain extends StatelessWidget {
  const ItemGain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prRequestDayWatch = context.watch<ProviderRequestDay>();
    final prRequestDayRead = context.read<ProviderRequestDay>();
    final prPrincipalRead = context.watch<ProviderPrincipal>();
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 5, top: 10),
            child: const WidgetTextFieldTitle(
                title: GlobalLabel.textGainTotalForService,
                align: TextAlign.left),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                    onTap: () {
                      if (prRequestDayRead.countRequest == 0) return;
                      prRequestDayRead.typeConsult = 1;
                      prRequestDayRead.filterRequestDay();
                      GlobalFunction()
                          .nextPageViewTransition(const PageRequestDay());
                    },
                    child: SizedBox(
                      height: 150,
                      child: WidgetContainer(
                          color: GlobalColors.colorWhite,
                          widget: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const WidgetTextFieldSubTitle(
                                        title:
                                            GlobalLabel.textRequestApplicative,
                                        align: TextAlign.left),
                                    const SizedBox(height: 10),
                                    const WidgetTextFieldTitle(
                                        title: GlobalLabel.textGainTravel,
                                        align: TextAlign.left),
                                    Container(
                                      alignment: Alignment.bottomCenter,
                                      child: Row(
                                        children: [
                                          WidgetTextFieldPersonalized(
                                            type: 1,
                                            title: prRequestDayWatch
                                                .paymentRequest
                                                .toStringAsFixed(2),
                                            align: TextAlign.left,
                                            size: 14,
                                            color: GlobalColors.colorGreenAqua,
                                          ),
                                          const SizedBox(width: 5),
                                          WidgetTextFieldPersonalized(
                                              type: 1,
                                              title: prPrincipalRead.nameMoney,
                                              align: TextAlign.center,
                                              size: 14,
                                              color:
                                                  GlobalColors.colorGreenAqua)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 0,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: WidgetTextFieldSubTitle(
                                      title:
                                          '${prRequestDayWatch.countRequest}',
                                      align: TextAlign.center),
                                ),
                              ),
                            ],
                          )),
                    )),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.only(left: 5),
            child: const WidgetTextFieldTitle(
                title: GlobalLabel.textGainTypePay, align: TextAlign.left),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (prRequestDayWatch.countPaymentCash == 0) return;
                    prRequestDayWatch.typeConsult = 3;
                    prRequestDayWatch.filterRequestDay();
                    GlobalFunction()
                        .nextPageViewTransition(const PageRequestDay());
                  },
                  child: SizedBox(
                    height: 150,
                    child: WidgetContainer(
                      color: GlobalColors.colorWhite,
                      widget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const WidgetTextFieldSubTitle(
                                    title: GlobalLabel.textPaymentCash,
                                    align: TextAlign.left),
                                const SizedBox(height: 10),
                                const WidgetTextFieldTitle(
                                    title: GlobalLabel.textItemPaymentCash,
                                    align: TextAlign.left),
                                Row(
                                  children: [
                                    WidgetTextFieldPersonalized(
                                        type: 1,
                                        title:
                                            '${prRequestDayWatch.paymentCash.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                                        align: TextAlign.right,
                                        size: 14,
                                        color: GlobalColors.colorGreenAqua),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: WidgetTextFieldSubTitle(
                                  title:
                                      '${prRequestDayWatch.countPaymentCash}',
                                  align: TextAlign.center),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (prRequestDayWatch.countPaymentElectronic == 0) {
                      return;
                    }
                    prRequestDayWatch.typeConsult = 4;
                    prRequestDayWatch.filterRequestDay();
                    GlobalFunction()
                        .nextPageViewTransition(const PageRequestDay());
                  },
                  child: SizedBox(
                    height: 150,
                    child: WidgetContainer(
                      color: GlobalColors.colorWhite,
                      widget: Column(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const WidgetTextFieldSubTitle(
                                    title: GlobalLabel.textPaymentElectronic,
                                    align: TextAlign.left),
                                const SizedBox(height: 10),
                                const WidgetTextFieldTitle(
                                    title:
                                        GlobalLabel.textItemPaymentElectronic,
                                    align: TextAlign.left),
                                Row(
                                  children: [
                                    WidgetTextFieldPersonalized(
                                        type: 1,
                                        title:
                                            '${prRequestDayWatch.paymentElectronic.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                                        align: TextAlign.right,
                                        size: 14,
                                        color: GlobalColors.colorGreenAqua),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 0,
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: WidgetTextFieldSubTitle(
                                    title:
                                        '${prRequestDayWatch.countPaymentElectronic}',
                                    align: TextAlign.center),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.only(left: 5),
            child: const WidgetTextFieldTitle(
                title: GlobalLabel.textGainAdditional, align: TextAlign.left),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: SizedBox(
                    height: 150,
                    child: WidgetContainer(
                      color: GlobalColors.colorWhite,
                      widget: Column(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const WidgetTextFieldSubTitle(
                                    title: GlobalLabel.textTipForRequest,
                                    align: TextAlign.left),
                                const SizedBox(height: 10),
                                const WidgetTextFieldTitle(
                                    title: GlobalLabel.textItemGoodService,
                                    align: TextAlign.left),
                                Row(
                                  children: [
                                    WidgetTextFieldPersonalized(
                                        type: 1,
                                        title:
                                            '0.00 ${prPrincipalRead.nameMoney}',
                                        align: TextAlign.right,
                                        size: 14,
                                        color: GlobalColors.colorGreenAqua),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 0,
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: const WidgetTextFieldSubTitle(
                                    title: '0', align: TextAlign.center),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: SizedBox(
                    height: 150,
                    child: WidgetContainer(
                      color: GlobalColors.colorWhite,
                      widget: Column(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const WidgetTextFieldSubTitle(
                                    title: GlobalLabel.textPaymentWaitTime,
                                    align: TextAlign.left),
                                const SizedBox(height: 10),
                                const WidgetTextFieldTitle(
                                    title: GlobalLabel.textItemTimeWait,
                                    align: TextAlign.left),
                                Row(
                                  children: [
                                    WidgetTextFieldPersonalized(
                                        type: 1,
                                        title:
                                            '0.00 ${prPrincipalRead.nameMoney}',
                                        align: TextAlign.right,
                                        size: 16,
                                        color: GlobalColors.colorGreenAqua),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 0,
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: WidgetTextFieldSubTitle(
                                    title: '${prRequestDayWatch.countWait}',
                                    align: TextAlign.center),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: SizedBox(
                    height: 150,
                    child: WidgetContainer(
                      color: GlobalColors.colorWhite,
                      widget: Column(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const WidgetTextFieldSubTitle(
                                    title: GlobalLabel.textChallenge,
                                    align: TextAlign.left),
                                const SizedBox(height: 10),
                                const WidgetTextFieldTitle(
                                    title: GlobalLabel.textItemChallenge,
                                    align: TextAlign.left),
                                Row(
                                  children: [
                                    WidgetTextFieldPersonalized(
                                        type: 1,
                                        title:
                                            '0.00 ${prPrincipalRead.nameMoney}',
                                        align: TextAlign.right,
                                        size: 16,
                                        color: GlobalColors.colorGreenAqua),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 0,
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: WidgetTextFieldSubTitle(
                                    title:
                                        '${prRequestDayWatch.countChallenge}',
                                    align: TextAlign.center),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: SizedBox(
                    height: 150,
                    child: WidgetContainer(
                      color: GlobalColors.colorWhite,
                      widget: Column(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const WidgetTextFieldSubTitle(
                                    title: GlobalLabel.textPaymentExtra,
                                    align: TextAlign.left),
                                const SizedBox(height: 10),
                                const WidgetTextFieldTitle(
                                    title: GlobalLabel.textItemGainService,
                                    align: TextAlign.left),
                                Row(
                                  children: [
                                    WidgetTextFieldPersonalized(
                                        type: 1,
                                        title:
                                            '0.00 ${prPrincipalRead.nameMoney}',
                                        align: TextAlign.right,
                                        size: 16,
                                        color: GlobalColors.colorGreenAqua),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 0,
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: WidgetTextFieldSubTitle(
                                    title:
                                        '${prRequestDayWatch.countPaymentExtra}',
                                    align: TextAlign.center),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.only(left: 5),
            child: const WidgetTextFieldTitle(
                title: GlobalLabel.textBalancePending, align: TextAlign.left),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {},
            child: SizedBox(
              height: 130,
              child: WidgetContainer(
                color: GlobalColors.colorWhite,
                widget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const WidgetTextFieldSubTitle(
                        title: GlobalLabel.textPaymentService,
                        align: TextAlign.left),
                    const SizedBox(height: 10),
                    const WidgetTextFieldTitle(
                        title: GlobalLabel.textItemDebt, align: TextAlign.left),
                    Row(
                      children: [
                        WidgetTextFieldPersonalized(
                            type: 1,
                            title: '0.00 ${prPrincipalRead.nameMoney}',
                            align: TextAlign.right,
                            size: 16,
                            color: GlobalColors.colorRed),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
