import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../provider/provider_payment.dart';
import '../provider/provider_principal.dart';
import '../provider/provider_taximeter.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_container.dart';
import '../util/global_widgets/widget_divider.dart';
import '../util/global_widgets/widget_icon.dart';
import '../util/global_widgets/widget_message_page.dart';
import '../util/global_widgets/widget_text_field_personalized.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';
import '../util/global_widgets/widget_text_field_title.dart';

class PageDetailPaymentService extends StatefulWidget {
  const PageDetailPaymentService({super.key});

  @override
  State<PageDetailPaymentService> createState() =>
      _PageDetailPaymentServiceState();
}

class _PageDetailPaymentServiceState extends State<PageDetailPaymentService> {
  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
          statusBarColor: GlobalColors.colorBackground,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: GlobalColors.colorBackground,
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        GlobalFunction().closeView();
                      },
                      child: Container(
                          color: Colors.transparent,
                          margin: const EdgeInsets.only(
                              top: 15, right: 30, left: 30),
                          child: const WidgetIcon(
                              icon: Icons.arrow_back_ios,
                              size: 20,
                              colors: GlobalColors.colorIcon)),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const WidgetMessagePage(
                          title: GlobalLabel.textDetailPayment,
                          message: GlobalLabel.textDescriptionDetailPayment),
                    ),
                    const TypePay(),
                    const DetailRequest(),
                    const DetailStreet(),
                    const DetailTravel(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TypePay extends StatelessWidget {
  const TypePay({super.key});

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prPaymentWatch = context.watch<ProviderPayment>();
    final prTaximeterRead = context.watch<ProviderTaximeter>();
    return Container(
      margin: const EdgeInsets.only(top: 40, right: 30, left: 30),
      child: WidgetContainer(
        color: GlobalColors.colorBackgroundBlue,
        widget: Align(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WidgetTextFieldPersonalized(
                  type: 1,
                  title: prPrincipalRead.modelRequestActive!.requestData != null
                      ? prPrincipalRead.modelRequestActive!.requestData!
                                  .paymentType ==
                              9
                          ? !prTaximeterRead.connectedTaximeterExternal
                              ? prPaymentWatch.subTotal
                              : double.parse(prTaximeterRead.priceTotalStreet)
                                  .toStringAsFixed(2)
                          : prTaximeterRead.connectedTaximeterExternal
                              ? double.parse(prTaximeterRead.priceTotalStreet)
                                  .toStringAsFixed(2)
                              : (double.parse(prTaximeterRead.priceTotal))
                                  .toStringAsFixed(2)
                      : !prTaximeterRead.connectedTaximeterExternal
                          ? double.parse(prTaximeterRead.priceTotalStreet)
                              .toStringAsFixed(2)
                          : prTaximeterRead.connectedTaximeterExternal
                              ? double.parse(prTaximeterRead.priceTotal)
                                  .toStringAsFixed(2)
                              : '0.00',
                  align: TextAlign.left,
                  size: 50,
                  color: GlobalColors.colorWhite,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: WidgetTextFieldPersonalized(
                      type: 1,
                      title: prPrincipalRead.nameMoney,
                      align: TextAlign.center,
                      size: 16,
                      color: GlobalColors.colorWhite),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DetailRequest extends StatelessWidget {
  const DetailRequest({super.key});

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    return Container(
      margin: const EdgeInsets.only(top: 20, right: 30, left: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WidgetTextFieldTitle(
              title: GlobalLabel.textDataUser, align: TextAlign.left),
          const SizedBox(height: 10),
          WidgetContainer(
            color: GlobalColors.colorWhite,
            widget: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: WidgetTextFieldSubTitle(
                          title: GlobalLabel.textDate, align: TextAlign.left),
                    ),
                    Expanded(
                      flex: 0,
                      child: WidgetTextFieldTitle(
                          title:
                              '${GlobalFunction().formatDate()} ${GlobalFunction().formatHour()}',
                          align: TextAlign.left),
                    )
                  ],
                ),
                const WidgetDivider(),
                Row(
                  children: [
                    const Expanded(
                        child: WidgetTextFieldSubTitle(
                            title: GlobalLabel.textNumberService,
                            align: TextAlign.left)),
                    Expanded(
                        flex: 0,
                        child: WidgetTextFieldTitle(
                            title: '${prPrincipalRead.getRequestId()}',
                            align: TextAlign.left))
                  ],
                ),
                const WidgetDivider(),
                Row(
                  children: [
                    const Expanded(
                        child: WidgetTextFieldSubTitle(
                            title: GlobalLabel.textUser,
                            align: TextAlign.left)),
                    Expanded(
                        flex: 0,
                        child: WidgetTextFieldTitle(
                            title: prPrincipalRead
                                        .modelRequestActive!.requestType !=
                                    3
                                ? prPrincipalRead.modelRequestActive!
                                    .requestData!.user!.names!
                                : prPrincipalRead
                                            .modelRequestActive!.requestData !=
                                        null
                                    ? prPrincipalRead.modelRequestActive!
                                        .requestData!.user!.names!
                                    : GlobalLabel.textServiceStreet,
                            align: TextAlign.left))
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailStreet extends StatelessWidget {
  const DetailStreet({super.key});

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WidgetTextFieldTitle(
              title: GlobalLabel.textDataService, align: TextAlign.left),
          const SizedBox(height: 10),
          WidgetContainer(
            color: GlobalColors.colorWhite,
            widget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidgetTextFieldTitle(
                    title: prPrincipalRead.modelRequestActive!.requestType! ==
                                1 ||
                            prPrincipalRead.modelRequestActive!.requestType! ==
                                3
                        ? GlobalLabel.textOrigin
                        : GlobalLabel.textShopPlace,
                    align: TextAlign.left),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Expanded(
                        flex: 0,
                        child: WidgetIcon(
                            icon: Icons.directions,
                            size: 25,
                            colors: GlobalColors.colorBlue)),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WidgetTextFieldTitle(
                            title: prPrincipalRead.neighborhoodOriginRequest(
                                prPrincipalRead.modelRequestActive!),
                            align: TextAlign.left),
                        WidgetTextFieldSubTitle(
                            title: prPrincipalRead.streetOriginRequest(
                                prPrincipalRead.modelRequestActive!),
                            align: TextAlign.left)
                      ],
                    ))
                  ],
                ),
                Visibility(
                  visible: prPrincipalRead
                      .modelRequestActive!.requestData!.destination!.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      WidgetTextFieldTitle(
                          title:
                              prPrincipalRead.modelRequestActive!.requestType ==
                                          1 ||
                                      prPrincipalRead.modelRequestActive!
                                              .requestType! ==
                                          3
                                  ? GlobalLabel.textDestiny
                                  : GlobalLabel.textDeliver,
                          align: TextAlign.left),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Expanded(
                              flex: 0,
                              child: WidgetIcon(
                                  icon: Icons.directions,
                                  size: 25,
                                  colors: GlobalColors.colorGreen)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                WidgetTextFieldTitle(
                                    title: prPrincipalRead
                                        .neighborhoodDestinyRequest(
                                            prPrincipalRead
                                                .modelRequestActive!),
                                    align: TextAlign.left),
                                WidgetTextFieldSubTitle(
                                    title: prPrincipalRead.streetDestinyRequest(
                                        prPrincipalRead.modelRequestActive!),
                                    align: TextAlign.left)
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailTravel extends StatelessWidget {
  const DetailTravel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 30, right: 30),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [DetailTaximeter(), PaymentHybrid(), Tip()],
      ),
    );
  }
}

class Tip extends StatelessWidget {
  const Tip({super.key});

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    return Visibility(
      visible: prPrincipalRead.modelRequestActive!.requestData != null
          ? prPrincipalRead.modelRequestActive!.requestData!.paymentType != 9 &&
                  prPrincipalRead.modelRequestActive!.requestData!.tip! > 0
              ? true
              : false
          : false,
      child: WidgetContainer(
          widget: Row(
            children: [
              const Expanded(
                child: WidgetTextFieldPersonalized(
                    type: 2,
                    color: GlobalColors.colorLetterTitle,
                    size: 16,
                    title: GlobalLabel.textTip,
                    align: TextAlign.left),
              ),
              Expanded(
                flex: 0,
                child: WidgetTextFieldPersonalized(
                    type: 1,
                    color: GlobalColors.colorLetterTitle,
                    size: 16,
                    title:
                        '${prPrincipalRead.modelRequestActive!.requestData!.tip!} ${prPrincipalRead.nameMoney}',
                    align: TextAlign.left),
              )
            ],
          ),
          color: GlobalColors.colorWhite),
    );
  }
}

class DetailTaximeter extends StatelessWidget {
  const DetailTaximeter({super.key});

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prTaximeterWatch = context.watch<ProviderTaximeter>();
    final prTaximeterRead = context.read<ProviderTaximeter>();
    return Visibility(
      visible: prTaximeterRead.taximeter.approximate! > 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WidgetTextFieldTitle(
              title: GlobalLabel.textFeeTaximeter, align: TextAlign.left),
          const SizedBox(height: 10),
          WidgetContainer(
            color: GlobalColors.colorWhite,
            widget: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: WidgetTextFieldSubTitle(
                          title: GlobalLabel.textHourInitial,
                          align: TextAlign.left),
                    ),
                    Expanded(
                      flex: 0,
                      child: WidgetTextFieldTitle(
                          title: prPrincipalRead
                              .modelRequestActive!.requestData!.hour!,
                          align: TextAlign.left),
                    ),
                  ],
                ),
                const WidgetDivider(),
                Row(
                  children: [
                    const Expanded(
                      child: WidgetTextFieldSubTitle(
                          title: GlobalLabel.textDistanceTraveled,
                          align: TextAlign.left),
                    ),
                    Expanded(
                      flex: 0,
                      child: WidgetTextFieldTitle(
                          title:
                              '${prTaximeterWatch.distanceTraveled.toStringAsFixed(2)} ${prTaximeterWatch.unitMeasure}',
                          align: TextAlign.left),
                    )
                  ],
                ),
                const WidgetDivider(),
                Row(
                  children: [
                    const Expanded(
                      child: WidgetTextFieldSubTitle(
                          title: GlobalLabel.textValueInitial,
                          align: TextAlign.left),
                    ),
                    Expanded(
                        flex: 0,
                        child: WidgetTextFieldTitle(
                            title: GlobalFunction().checkHourDay()
                                ? '${prTaximeterWatch.taximeter.aD!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}'
                                : '${prTaximeterRead.taximeter.aN!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                            align: TextAlign.left)),
                  ],
                ),
                const WidgetDivider(),
                Row(
                  children: [
                    const Expanded(
                      child: WidgetTextFieldSubTitle(
                          title: GlobalLabel.textMinimalCost,
                          align: TextAlign.left),
                    ),
                    Expanded(
                        flex: 0,
                        child: WidgetTextFieldTitle(
                            title: GlobalFunction().checkHourDay()
                                ? '${prTaximeterRead.taximeter.cD!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}'
                                : '${prTaximeterRead.taximeter.cN!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                            align: TextAlign.left)),
                  ],
                ),
                const WidgetDivider(),
                Row(
                  children: [
                    const Expanded(
                      child: WidgetTextFieldSubTitle(
                          title: GlobalLabel.textCostDistance,
                          align: TextAlign.left),
                    ),
                    Expanded(
                        flex: 0,
                        child: WidgetTextFieldTitle(
                            title: GlobalFunction().checkHourDay()
                                ? '${prTaximeterRead.taximeter.kmD!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}'
                                : '${prTaximeterRead.taximeter.kmN!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                            align: TextAlign.left))
                  ],
                ),
                const WidgetDivider(),
                Row(
                  children: [
                    const Expanded(
                      child: WidgetTextFieldSubTitle(
                          title: GlobalLabel.textTimeTotal,
                          align: TextAlign.left),
                    ),
                    Expanded(
                      flex: 0,
                      child: WidgetTextFieldTitle(
                          title:
                              '${GlobalFunction().differentHour(prPrincipalRead.modelRequestActive!.requestData!.hour!, GlobalFunction().hour.format(GlobalFunction().dateNow))}',
                          align: TextAlign.left),
                    )
                  ],
                ),
                const WidgetDivider(),
                Row(
                  children: [
                    const Expanded(
                      child: WidgetTextFieldSubTitle(
                          title: GlobalLabel.textTimeWait,
                          align: TextAlign.left),
                    ),
                    Expanded(
                      flex: 0,
                      child: WidgetTextFieldTitle(
                          title:
                              '${prTaximeterWatch.timeTotalWait} - ${prTaximeterWatch.costTimeWait.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                          align: TextAlign.left),
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class PaymentHybrid extends StatelessWidget {
  const PaymentHybrid({super.key});

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prPaymentRead = context.read<ProviderPayment>();
    final prPaymentWatch = context.watch<ProviderPayment>();
    final prTaximeterRead = context.watch<ProviderTaximeter>();

    return Visibility(
      visible: prPrincipalRead.modelRequestActive!.requestData != null
          ? prPrincipalRead.modelRequestActive!.requestData!.paymentType == 9
          : false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WidgetTextFieldPersonalized(
              size: 14,
              color: GlobalColors.colorLetterTitle,
              type: 1,
              title: GlobalLabel.textDetailPayment,
              align: TextAlign.center),
          const SizedBox(height: 10),
          WidgetContainer(
            color: GlobalColors.colorWhite,
            widget: Column(
              children: [
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          const Expanded(
                            child: WidgetTextFieldPersonalized(
                                type: 2,
                                color: GlobalColors.colorLetterTitle,
                                size: 16,
                                title: GlobalLabel.textFeeService,
                                align: TextAlign.left),
                          ),
                          Expanded(
                            flex: 0,
                            child: WidgetTextFieldPersonalized(
                                type: 1,
                                color: GlobalColors.colorLetterTitle,
                                size: 16,
                                title:
                                    '${double.parse(prTaximeterRead.priceTotal).toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                                align: TextAlign.left),
                          )
                        ],
                      ),
                    ),
                    const WidgetDivider()
                  ],
                ),
                Visibility(
                  visible: prPaymentRead.modelPaymentHybrid != null &&
                      prPaymentRead.modelPaymentHybrid?.discount != null,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            const Expanded(
                              child: WidgetTextFieldPersonalized(
                                  type: 2,
                                  color: GlobalColors.colorLetterTitle,
                                  size: 16,
                                  title: GlobalLabel.textDiscount,
                                  align: TextAlign.left),
                            ),
                            Expanded(
                              flex: 0,
                              child: WidgetTextFieldPersonalized(
                                  type: 1,
                                  color: GlobalColors.colorLetterTitle,
                                  size: 16,
                                  title:
                                      '${prPaymentRead.modelPaymentHybrid != null ? prPaymentRead.modelPaymentHybrid!.discount!.isNotEmpty ? prPaymentRead.modelPaymentHybrid!.discount![0].typeDiscount == 30 ? '- ${prPaymentRead.totalTravelWithPercentage}' : '- ${prPaymentRead.costDiscount}' : '0.00' : '0.00'} '
                                      '${prPaymentRead.modelPaymentHybrid != null && prPaymentRead.modelPaymentHybrid!.discount != null && prPaymentRead.modelPaymentHybrid!.discount!.isNotEmpty ? prPrincipalRead.nameMoney : prPrincipalRead.nameMoney}',
                                  align: TextAlign.left),
                            )
                          ],
                        ),
                      ),
                      const WidgetDivider()
                    ],
                  ),
                ),
                Visibility(
                  visible: prPaymentRead.modelPaymentHybrid != null &&
                      prPaymentRead.modelPaymentHybrid!.tip != null,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            const Expanded(
                              child: WidgetTextFieldPersonalized(
                                  type: 2,
                                  color: GlobalColors.colorLetterTitle,
                                  size: 16,
                                  title: GlobalLabel.textTip,
                                  align: TextAlign.left),
                            ),
                            Expanded(
                              flex: 0,
                              child: WidgetTextFieldPersonalized(
                                  type: 1,
                                  color: GlobalColors.colorLetterTitle,
                                  size: 16,
                                  title:
                                      '${prPaymentWatch.costTip} ${prPrincipalRead.nameMoney}',
                                  align: TextAlign.left),
                            )
                          ],
                        ),
                      ),
                      const WidgetDivider()
                    ],
                  ),
                ),
                Visibility(
                  visible: prPaymentRead.modelPaymentHybrid?.discount != null,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            const Expanded(
                              child: WidgetTextFieldPersonalized(
                                  type: 2,
                                  color: GlobalColors.colorLetterTitle,
                                  size: 16,
                                  title: GlobalLabel.textSubTotal,
                                  align: TextAlign.left),
                            ),
                            Expanded(
                              flex: 0,
                              child: WidgetTextFieldPersonalized(
                                  type: 1,
                                  color: GlobalColors.colorLetterTitle,
                                  size: 16,
                                  title:
                                      '${prPaymentWatch.subTotal} ${prPrincipalRead.nameMoney}',
                                  align: TextAlign.left),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const WidgetTextFieldPersonalized(
              size: 14,
              color: GlobalColors.colorLetterTitle,
              type: 1,
              title: GlobalLabel.textMethodPayment,
              align: TextAlign.left),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: WidgetContainer(
                widget: Column(
                  children: [
                    Visibility(
                      visible: prPaymentRead.modelPaymentHybrid?.wallet != null,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: WidgetTextFieldPersonalized(
                                        type: 2,
                                        color: GlobalColors.colorLetterTitle,
                                        size: 16,
                                        title:
                                            prPaymentRead.modelPaymentHybrid !=
                                                    null
                                                ? prPaymentRead
                                                            .modelPaymentHybrid!
                                                            .wallet !=
                                                        null
                                                    ? prPaymentRead
                                                        .modelPaymentHybrid!
                                                        .wallet!
                                                        .name!
                                                    : GlobalLabel.textWallet
                                                : '',
                                        align: TextAlign.left),
                                  ),
                                ),
                                Expanded(
                                  flex: 0,
                                  child: WidgetTextFieldPersonalized(
                                      type: 1,
                                      color: GlobalColors.colorLetterTitle,
                                      size: 16,
                                      title:
                                          '${prPaymentWatch.costWallet} ${prPrincipalRead.nameMoney}',
                                      align: TextAlign.left),
                                )
                              ],
                            ),
                          ),
                          const WidgetDivider(),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: prPaymentRead.modelPaymentHybrid != null &&
                          prPaymentRead.modelPaymentHybrid!.card != null,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: WidgetTextFieldPersonalized(
                                      type: 2,
                                      color: GlobalColors.colorLetterTitle,
                                      size: 16,
                                      title: prPaymentRead.modelPaymentHybrid !=
                                              null
                                          ? prPaymentRead.modelPaymentHybrid !=
                                                  null
                                              ? prPaymentRead
                                                          .modelPaymentHybrid!
                                                          .card !=
                                                      null
                                                  ? prPaymentRead
                                                      .modelPaymentHybrid!
                                                      .card!
                                                      .name!
                                                  : GlobalLabel.textCard
                                              : ''
                                          : '',
                                      align: TextAlign.left),
                                ),
                                Expanded(
                                  flex: 0,
                                  child: WidgetTextFieldPersonalized(
                                      type: 1,
                                      color: prPaymentRead.modelPaymentHybrid !=
                                              null
                                          ? prPaymentRead.modelPaymentHybrid!
                                                      .card !=
                                                  null
                                              ? prPaymentWatch.statusErrorCard
                                                  ? GlobalColors.colorRed
                                                  : GlobalColors
                                                      .colorLetterTitle
                                              : GlobalColors.colorLetterTitle
                                          : GlobalColors.colorLetterTitle,
                                      size: 16,
                                      title:
                                          '${prPaymentRead.costCard} ${prPrincipalRead.nameMoney}',
                                      align: TextAlign.left),
                                )
                              ],
                            ),
                          ),
                          const WidgetDivider()
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: WidgetTextFieldPersonalized(
                                    type: 2,
                                    color: GlobalColors.colorLetterTitle,
                                    size: 16,
                                    title:
                                        prPaymentRead.modelPaymentHybrid != null
                                            ? prPaymentRead.modelPaymentHybrid!
                                                        .cash !=
                                                    null
                                                ? prPaymentRead
                                                    .modelPaymentHybrid!
                                                    .cash!
                                                    .name!
                                                : GlobalLabel.textCash
                                            : '',
                                    align: TextAlign.left),
                              ),
                              Expanded(
                                flex: 0,
                                child: WidgetTextFieldPersonalized(
                                    type: 1,
                                    color: GlobalColors.colorLetterTitle,
                                    size: 16,
                                    title:
                                        '${prPaymentWatch.costCash} ${prPrincipalRead.nameMoney}',
                                    align: TextAlign.left),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                        visible: prPaymentRead.modelPaymentHybrid != null
                            ? prPaymentRead.modelPaymentHybrid!.card != null &&
                                prPaymentWatch.statusErrorCard
                            : false,
                        child: Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: WidgetTextFieldPersonalized(
                              color: GlobalColors.colorLetterTitle,
                              type: 1,
                              size: 14,
                              title: prPaymentRead.modelPaymentHybrid != null
                                  ? prPaymentRead.modelPaymentHybrid!.card !=
                                          null
                                      ? '${GlobalLabel.textMessageMinCard} '
                                          '${prPaymentRead.modelPaymentHybrid!.card!.min} ${prPrincipalRead.nameMoney} '
                                          '${GlobalLabel.textMessagePaymentCash} ${prPaymentRead.costCash} ${prPrincipalRead.nameMoney} ${GlobalLabel.textWithCash}'
                                      : ''
                                  : '',
                              align: TextAlign.center),
                        )),
                  ],
                ),
                color: GlobalColors.colorWhite),
          )
        ],
      ),
    );
  }
}

class ListPayment extends StatelessWidget {
  const ListPayment({super.key});

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    return Visibility(
      visible: prPrincipalRead
          .modelRequestActive!.requestData!.paymentList!.isNotEmpty,
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: GlobalColors.colorBackground.withOpacity(.5),
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: GlobalColors.colorBackground.withOpacity(.5),
            width: .5,
          ),
        ),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: prPrincipalRead
              .modelRequestActive!.requestData!.paymentList!.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Center(
                  child: WidgetTextFieldTitle(
                      title: prPrincipalRead.modelRequestActive!.requestData!
                          .paymentList![index].namePay!,
                      align: TextAlign.left),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: prPrincipalRead.modelRequestActive!.requestData!
                      .paymentList![index].itemsList!.length,
                  itemBuilder: (context, indexR) {
                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Row(
                            children: [
                              Expanded(
                                  child: WidgetTextFieldSubTitle(
                                      title: prPrincipalRead
                                          .modelRequestActive!
                                          .requestData!
                                          .paymentList![index]
                                          .itemsList![index]
                                          .name!,
                                      align: TextAlign.left)),
                              Expanded(
                                  flex: 0,
                                  child: WidgetTextFieldTitle(
                                      title:
                                          '${prPrincipalRead.modelRequestActive!.requestData!.paymentList![index].itemsList![index].type == 1 ? '+' : '-'}${prPrincipalRead.modelRequestActive!.requestData!.paymentList![index].itemsList![index].mount!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                                      align: TextAlign.left)),
                            ],
                          ),
                        ),
                        const WidgetDivider(),
                      ],
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
