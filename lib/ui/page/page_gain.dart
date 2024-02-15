import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_gain.dart';
import '../provider/provider_history_request.dart';
import '../provider/provider_principal.dart';
import '../provider/provider_service/provider_service_rest.dart';
import '../util/global_colors.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_container.dart';
import '../util/global_widgets/widget_divider.dart';
import '../util/global_widgets/widget_message_page.dart';
import '../util/global_widgets/widget_scaffold.dart';
import '../util/global_widgets/widget_text_field_personalized.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';
import '../util/global_widgets/widget_text_field_title.dart';

class PageGain extends StatefulWidget {
  const PageGain({Key? key}) : super(key: key);

  @override
  State<PageGain> createState() => _PageGainState();
}

class _PageGainState extends State<PageGain> {
  @override
  Widget build(BuildContext context) {
    return WidgetScaffold(
        onPressed: () => Navigator.pop(context),
        widget: const SingleChildScrollView(
          child: Column(
            children: [
              WidgetMessagePage(
                  title: GlobalLabel.textTitleGain,
                  message: GlobalLabel.textDescriptionGain),
              DetailGain(),
              ItemGain()
            ],
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    context.read<ProviderGain>().formatMonth();
  }
}

class ItemGain extends StatelessWidget {
  const ItemGain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prGainRead = context.read<ProviderGain>();
    final prGainWatch = context.watch<ProviderGain>();
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prHistoryRequestRead = context.read<ProviderHistoryRequest>();
    final prServiceRestRead = context.read<ProviderServiceRest>();

    return Container(
      margin: const EdgeInsets.only(top: 10, left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: const EdgeInsets.only(top: 10),
              child: const WidgetTextFieldTitle(
                  title: GlobalLabel.textGainTotalForService,
                  align: TextAlign.left)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: GestureDetector(
                      onTap: () {
                        if (prGainRead.paymentRequest == 0) return;
                        prHistoryRequestRead.selected = prGainRead.selected;
                        prHistoryRequestRead.month = prGainRead.month;
                        prHistoryRequestRead.typeConsult = 1;
                        prHistoryRequestRead.positionSelectedRequest = 1;
                        prServiceRestRead.consultNumberHistoryRequest(context);
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const WidgetTextFieldSubTitle(
                                        title:
                                            GlobalLabel.textRequestApplicative,
                                        align: TextAlign.left),
                                    const SizedBox(height: 10),
                                    const WidgetTextFieldTitle(
                                        title: GlobalLabel.textGainTravel,
                                        align: TextAlign.left),
                                    WidgetTextFieldPersonalized(
                                      type: 1,
                                      title:
                                          '${prGainWatch.paymentRequest.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                                      align: TextAlign.left,
                                      size: 14,
                                      color: GlobalColors.colorGreenAqua,
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 0,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: WidgetTextFieldSubTitle(
                                      title: '${prGainWatch.countRequest}',
                                      align: TextAlign.center),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))),
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
                  onTap: () {},
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
                                WidgetTextFieldPersonalized(
                                    type: 1,
                                    title:
                                        '${prGainRead.paymentCash.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                                    align: TextAlign.left,
                                    size: 14,
                                    color: GlobalColors.colorGreenAqua)
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: WidgetTextFieldSubTitle(
                                  title: '${prGainRead.countPaymentCash}',
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
                                            '${prGainRead.paymentElectronic.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                                        align: TextAlign.left,
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
                                        '${prGainRead.countPaymentElectronic}',
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
                  title: GlobalLabel.textGainAdditional,
                  align: TextAlign.left)),
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
                                WidgetTextFieldPersonalized(
                                    type: 1,
                                    title: '0.00 ${prPrincipalRead.nameMoney}',
                                    align: TextAlign.left,
                                    size: 14,
                                    color: GlobalColors.colorGreenAqua)
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 0,
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: WidgetTextFieldSubTitle(
                                    title: '${prGainRead.countTip}',
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
                                    title: GlobalLabel.textPaymentWaitTime,
                                    align: TextAlign.left),
                                const SizedBox(height: 10),
                                const WidgetTextFieldTitle(
                                    title: GlobalLabel.textItemTimeWait,
                                    align: TextAlign.left),
                                WidgetTextFieldPersonalized(
                                    type: 1,
                                    title: '0.00 ${prPrincipalRead.nameMoney}',
                                    align: TextAlign.left,
                                    size: 14,
                                    color: GlobalColors.colorGreenAqua)
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 0,
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: WidgetTextFieldSubTitle(
                                    title: '${prGainRead.countWait}',
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
                                WidgetTextFieldPersonalized(
                                    type: 1,
                                    title: '0.00 ${prPrincipalRead.nameMoney}',
                                    align: TextAlign.left,
                                    size: 14,
                                    color: GlobalColors.colorGreenAqua)
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 0,
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: WidgetTextFieldSubTitle(
                                    title: '${prGainRead.countChallenge}',
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
                                WidgetTextFieldPersonalized(
                                    type: 1,
                                    title: '0.00 ${prPrincipalRead.nameMoney}',
                                    align: TextAlign.left,
                                    size: 14,
                                    color: GlobalColors.colorGreenAqua)
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 0,
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: WidgetTextFieldSubTitle(
                                    title: '${prGainRead.countPaymentExtra}',
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
                  title: GlobalLabel.textBalancePending,
                  align: TextAlign.left)),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {},
            child: SizedBox(
              height: 150,
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
                            align: TextAlign.left,
                            size: 14,
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

class DriverStats extends StatelessWidget {
  const DriverStats({super.key});

  @override
  Widget build(BuildContext context) {
    final prGainWatch = context.watch<ProviderGain>();
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
                    title: '${prGainWatch.totalRequest}',
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

class DetailGain extends StatelessWidget {
  const DetailGain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prGainWatch = context.watch<ProviderGain>();
    final prPrincipalRead = context.read<ProviderPrincipal>();

    return Container(
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
                          '${prGainWatch.gainTotal.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
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
        ));
  }
}

class DateMonth extends StatelessWidget {
  const DateMonth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prGainRead = context.read<ProviderGain>();
    final prGainWatch = context.watch<ProviderGain>();
    return GestureDetector(
      onTap: () {
        prGainRead.selectMonth(context);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 20),
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
                title: prGainWatch.month,
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
