import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:provider/provider.dart';
import 'package:reviews_slider/reviews_slider.dart';

import '../provider/provider_payment.dart';
import '../provider/provider_principal.dart';
import '../provider/provider_service/provider_service_rest.dart';
import '../provider/provider_service/provider_service_socket.dart';
import '../provider/provider_taximeter.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_button.dart';
import '../util/global_widgets/widget_check.dart';
import '../util/global_widgets/widget_container.dart';
import '../util/global_widgets/widget_divider.dart';
import '../util/global_widgets/widget_icon.dart';
import '../util/global_widgets/widget_text_field_comment.dart';
import '../util/global_widgets/widget_text_field_edit.dart';
import '../util/global_widgets/widget_text_field_personalized.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';
import '../util/global_widgets/widget_text_field_title.dart';
import 'page_detail_payment_service.dart';

class PagePayment extends StatefulWidget {
  const PagePayment({super.key});

  @override
  State<PagePayment> createState() => _PagePaymentState();
}

class _PagePaymentState extends State<PagePayment> {
  @override
  void initState() {
    super.initState();
    context.read<ProviderPayment>().calculatePaymentHybrid();
    context.read<ProviderPayment>().updateStateViewPage(true);
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) {
    final prTaximeterRead = context.read<ProviderTaximeter>();
    final prPaymentRead = context.read<ProviderPayment>();
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
          statusBarColor: GlobalColors.colorGreenAqua,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent),
      child: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          if (prTaximeterRead.connectedTaximeterExternal) return;
          prPaymentRead.updateStateViewPage(false);
        },
        child: const Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DetailPayment(),
                      Tip(),
                      Toll(),
                      PaymentHybrid(),
                      QualificationUser(),
                      PinVoucher(),
                      ButtonsPayment()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonsPayment extends StatelessWidget {
  const ButtonsPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ButtonEndServiceHybrid(),
        ButtonEndService(),
        ButtonEndStreet(),
      ],
    );
  }
}

class QualificationUser extends StatelessWidget {
  const QualificationUser({super.key});

  @override
  Widget build(BuildContext context) {
    final prPaymentWatch = context.watch<ProviderPayment>();
    final prPaymentRead = context.read<ProviderPayment>();
    final prPrincipalRead = context.read<ProviderPrincipal>();

    return Visibility(
      visible: prPrincipalRead.stateTaximeterStreet &&
              prPrincipalRead.modelRequestActive!.requestData != null
          ? true
          : prPrincipalRead.stateTaximeterStreet &&
                  prPrincipalRead.modelRequestActive!.requestData == null ||
              !prPrincipalRead.stateTaximeterStreet,
      child: Container(
        margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
        child: WidgetContainer(
          color: GlobalColors.colorWhite,
          widget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const WidgetTextFieldTitle(
                  title: GlobalLabel.textExperienceUser,
                  align: TextAlign.center),
              const SizedBox(height: 10),
              const SizedBox(
                height: 20,
              ),
              ReviewSlider(
                  width: double.infinity,
                  circleDiameter: 50,
                  optionStyle: const TextStyle(
                      color: GlobalColors.colorLetterTitle,
                      fontSize: 11,
                      fontWeight: FontWeight.bold),
                  initialValue: prPaymentWatch.initialReviewSlider,
                  options: GlobalLabel.textOptionQualification,
                  onChange: (value) {
                    prPaymentRead.initialReviewSlider = value;
                  }),
              Visibility(
                visible: (prPaymentWatch.initialReviewSlider == 0 ||
                        prPaymentWatch.initialReviewSlider == 1)
                    ? true
                    : false,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: WidgetTextFieldComment(
                      identifier: prPaymentRead.editComment,
                      limitCharacter: 245,
                      type: TextInputType.text,
                      hintText: GlobalLabel.textComment,
                      icon: Icons.chat_bubble_outlined),
                ),
              ),
            ],
          ),
        ),
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
      child: Container(
        margin: const EdgeInsets.only(left: 30, right: 30, top: 30),
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
                          '${prPrincipalRead.modelRequestActive!.requestData != null ? prPrincipalRead.modelRequestActive!.requestData!.tip!.toStringAsFixed(2) : 0.0} ${prPrincipalRead.nameMoney}',
                      align: TextAlign.left),
                )
              ],
            ),
            color: GlobalColors.colorWhite),
      ),
    );
  }
}

class Toll extends StatelessWidget {
  const Toll({super.key});

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prPaymentWatch = context.watch<ProviderPayment>();
    final prPaymentRead = context.read<ProviderPayment>();

    return Visibility(
      visible: prPrincipalRead.modelRequestActive!.requestData != null &&
          prPrincipalRead.modelRequestActive!.requestData!.toll! > 0,
      child: GestureDetector(
        onTap: () {
          if (prPaymentRead.showDetailToll) {
            prPaymentRead.showDetailToll = false;
          } else {
            prPaymentRead.showDetailToll = true;
          }
        },
        child: Container(
          margin: EdgeInsets.only(
              left: 30,
              right: 30,
              top: prPrincipalRead.modelRequestActive!.requestData != null
                  ? prPrincipalRead.modelRequestActive!.requestData!.tip! > 0
                      ? 10
                      : 30
                  : 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: GlobalColors.colorWhite,
                  border:
                      Border.all(width: .8, color: GlobalColors.colorBorder),
                  boxShadow: [
                    BoxShadow(
                      color: GlobalColors.colorBorder.withOpacity(.5),
                      blurRadius: 5.0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const WidgetTextFieldSubTitle(
                              title: GlobalLabel.textToll,
                              align: TextAlign.left),
                          const SizedBox(height: 5),
                          WidgetTextFieldTitle(
                              title:
                                  '${prPrincipalRead.modelRequestActive!.requestData != null ? prPrincipalRead.modelRequestActive!.requestData!.toll! : '0.00'} ${prPrincipalRead.nameMoney}',
                              align: TextAlign.left),
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 0,
                        child: WidgetIcon(
                            icon: !prPaymentWatch.showDetailToll
                                ? Icons.keyboard_arrow_down_rounded
                                : Icons.keyboard_arrow_up_rounded,
                            size: 30,
                            colors: GlobalColors.colorIcon))
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const DetailToll()
            ],
          ),
        ),
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

    return Visibility(
      visible: prPrincipalRead.modelRequestActive!.requestData != null
          ? prPrincipalRead.modelRequestActive!.requestData!.paymentType == 9
          : false,
      child: GestureDetector(
        onTap: () {
          if (prPaymentRead.showDetailHybrid) {
            prPaymentRead.showDetailHybrid = false;
          } else {
            prPaymentRead.showDetailHybrid = true;
          }
        },
        child: Container(
          margin: const EdgeInsets.only(left: 30, right: 30, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: EdgeInsets.only(
                        top: prPaymentRead.modelPaymentHybrid?.discount !=
                                    null &&
                                prPaymentRead
                                    .modelPaymentHybrid!.discount!.isNotEmpty
                            ? 35
                            : 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(10.0),
                          bottomLeft: const Radius.circular(10.0),
                          bottomRight: const Radius.circular(10.0),
                          topRight:
                              prPaymentRead.modelPaymentHybrid?.discount !=
                                          null &&
                                      prPaymentRead.modelPaymentHybrid!
                                          .discount!.isNotEmpty
                                  ? const Radius.circular(0.0)
                                  : const Radius.circular(10.0)),
                      color: GlobalColors.colorWhite,
                      border:
                          Border.all(width: .8, color: GlobalColors.colorWhite),
                      boxShadow: [
                        BoxShadow(
                          color: GlobalColors.colorBorder.withOpacity(.5),
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const WidgetTextFieldSubTitle(
                                  title: GlobalLabel.textTypePay,
                                  align: TextAlign.left),
                              const SizedBox(height: 5),
                              WidgetTextFieldTitle(
                                  title:
                                      prPaymentRead.modelPaymentHybrid != null
                                          ? prPrincipalRead.modelRequestActive!
                                                      .requestData !=
                                                  null
                                              ? prPrincipalRead
                                                  .modelRequestActive!
                                                  .requestData!
                                                  .nameHybrid!
                                              : ''
                                          : '',
                                  align: TextAlign.left),
                            ],
                          ),
                        ),
                        Expanded(
                            flex: 0,
                            child: WidgetIcon(
                                icon: !prPaymentWatch.showDetailHybrid
                                    ? Icons.keyboard_arrow_down_rounded
                                    : Icons.keyboard_arrow_up_rounded,
                                size: 30,
                                colors: GlobalColors.colorIcon))
                      ],
                    ),
                  ),
                  Visibility(
                    visible: prPaymentRead.modelPaymentHybrid?.discount !=
                            null &&
                        prPaymentRead.modelPaymentHybrid!.discount!.isNotEmpty,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10.0),
                                topLeft: Radius.circular(10.0)),
                            color: GlobalColors.colorBackgroundBlue,
                            border: Border.all(
                                width: .8,
                                color: GlobalColors.colorBackgroundBlue),
                            boxShadow: [
                              BoxShadow(
                                color: GlobalColors.colorBorder.withOpacity(.5),
                                blurRadius: 1.0,
                              ),
                            ],
                          ),
                          child: WidgetTextFieldPersonalized(
                              type: 1,
                              color: GlobalColors.colorWhite,
                              size: 16,
                              title:
                                  '${GlobalLabel.textDiscount} ${prPaymentRead.costDiscount} '
                                  '${prPaymentRead.modelPaymentHybrid != null ? prPaymentRead.modelPaymentHybrid!.discount != null && prPaymentRead.modelPaymentHybrid!.discount!.isNotEmpty ? prPaymentRead.modelPaymentHybrid!.discount![0].typeDiscount == 30 ? '%' : prPrincipalRead.nameMoney : prPrincipalRead.nameMoney : prPrincipalRead.nameMoney}',
                              align: TextAlign.right)),
                    ),
                  ),
                ],
              ),
              const DetailPaymentHybrid()
            ],
          ),
        ),
      ),
    );
  }
}

class DetailPayment extends StatelessWidget {
  const DetailPayment({super.key});

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prTaximeterRead = context.read<ProviderTaximeter>();
    final prPaymentWatch = context.watch<ProviderPayment>();
    final prTaximeterWatch = context.watch<ProviderTaximeter>();
    return Container(
      height: 320,
      padding: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: GlobalColors.colorGreenAqua,
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0)),
        border: Border.all(
          width: .2,
          color: GlobalColors.colorGreenAqua,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.only(left: 25, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 20),
              child: GestureDetector(
                  onTap: () {
                    if (!prTaximeterWatch.connectedTaximeterExternal) {
                      Navigator.pop(context);
                      prTaximeterRead.setPaymentRequest(context);
                      context
                          .read<ProviderPayment>()
                          .updateStateViewPage(false);
                    }
                  },
                  child: const WidgetIcon(
                      icon: Icons.arrow_back_ios,
                      size: 20,
                      colors: GlobalColors.colorWhite)),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                child: WidgetTextFieldPersonalized(
                    title: '${prPrincipalRead.modelUser.name?.toUpperCase()}',
                    align: TextAlign.center,
                    size: 20,
                    color: GlobalColors.colorWhite,
                    type: 1),
              ),
            ),
            const Center(
              child: WidgetTextFieldPersonalized(
                  title: GlobalLabel.textPaymentCountOf,
                  align: TextAlign.center,
                  size: 16,
                  color: GlobalColors.colorWhite,
                  type: 2),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: WidgetTextFieldPersonalized(
                          title: prPrincipalRead
                                      .modelRequestActive!.requestData !=
                                  null
                              ? prPrincipalRead.modelRequestActive!.requestData!
                                          .paymentType ==
                                      9
                                  ? !prTaximeterRead.connectedTaximeterExternal
                                      ? prPaymentWatch.subTotal
                                      : double.parse(
                                              prTaximeterRead.priceTotalStreet)
                                          .toStringAsFixed(2)
                                  : prTaximeterRead.connectedTaximeterExternal
                                      ? double.parse(
                                              prTaximeterRead.priceTotalStreet)
                                          .toStringAsFixed(2)
                                      : (double.parse(prTaximeterRead.priceTotal))
                                          .toStringAsFixed(2)
                              : !prTaximeterRead.connectedTaximeterExternal
                                  ? double.parse(
                                          prTaximeterRead.priceTotalStreet)
                                      .toStringAsFixed(2)
                                  : prTaximeterRead.connectedTaximeterExternal
                                      ? double.parse(prTaximeterRead.priceTotal)
                                          .toStringAsFixed(2)
                                      : '0.00',
                          align: TextAlign.center,
                          size: 50,
                          color: GlobalColors.colorWhite,
                          type: 1)),
                  Center(
                    child: WidgetTextFieldPersonalized(
                        type: 1,
                        color: GlobalColors.colorWhite,
                        size: 14,
                        title: prPrincipalRead.nameMoney,
                        align: TextAlign.center),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: !prTaximeterWatch.connectedTaximeterExternal,
              child: GestureDetector(
                onTap: () {
                  if (prTaximeterWatch.priceUpdate) {
                    prTaximeterRead.setPaymentRequest(context);
                  } else {
                    if (prTaximeterRead.taximeter.approximate == null ||
                        prTaximeterRead.taximeter.approximate! > 0) {
                      sheetEditPayment(context);
                    } else {
                      GlobalFunction().messageAlert(
                          context, GlobalLabel.textMessageEditPayment);
                    }
                  }
                },
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(5),
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      color: GlobalColors.colorWhite,
                      border: Border.all(
                          width: .8, color: GlobalColors.colorBorder),
                      boxShadow: [
                        BoxShadow(
                          color: GlobalColors.colorBorder.withOpacity(.5),
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: WidgetTextFieldPersonalized(
                      type: 1,
                      title: prTaximeterWatch.priceUpdate
                          ? GlobalLabel.textResetPrice
                          : GlobalLabel.textEditPayment,
                      align: TextAlign.center,
                      size: 16,
                      color: GlobalColors.colorLetterTitle,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                GlobalFunction()
                    .nextPageViewTransition(const PageDetailPaymentService());
              },
              child: Visibility(
                visible:
                    prPrincipalRead.modelRequestActive!.requestData != null,
                child: Container(
                  alignment: Alignment.bottomRight,
                  margin: const EdgeInsets.only(top: 20),
                  child: const WidgetTextFieldPersonalized(
                      type: 2,
                      size: 16,
                      color: GlobalColors.colorWhite,
                      title: GlobalLabel.textWatchDetailPayment,
                      align: TextAlign.right),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPaymentHybrid extends StatelessWidget {
  const DetailPaymentHybrid({super.key});

  @override
  Widget build(BuildContext context) {
    final prTaximeterRead = context.read<ProviderTaximeter>();
    final prPaymentRead = context.read<ProviderPayment>();
    final prPaymentWatch = context.watch<ProviderPayment>();
    final prPrincipalRead = context.read<ProviderPrincipal>();

    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Visibility(
        visible: prPaymentWatch.showDetailHybrid,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    visible: prPaymentRead.modelPaymentHybrid?.discount !=
                            null &&
                        prPaymentRead.modelPaymentHybrid!.discount!.isNotEmpty,
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
                                        '${prPaymentRead.modelPaymentHybrid!.discount!.isNotEmpty ? prPaymentRead.modelPaymentHybrid!.discount![0].typeDiscount == 30 ? '- ${prPaymentRead.totalTravelWithPercentage}' : '- ${prPaymentRead.costDiscount}' : '0.00'} '
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
                                        '${prPaymentRead.costTip} ${prPrincipalRead.nameMoney}',
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
                                        '${prPaymentRead.subTotal} ${prPrincipalRead.nameMoney}',
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
            const SizedBox(height: 10),
            const WidgetTextFieldPersonalized(
                size: 14,
                color: GlobalColors.colorLetterTitle,
                type: 1,
                title: GlobalLabel.textDetailPayment,
                align: TextAlign.left),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              child: WidgetContainer(
                  widget: Column(
                    children: [
                      Visibility(
                        visible:
                            prPaymentRead.modelPaymentHybrid?.wallet != null,
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
                                          title: prPaymentRead
                                                      .modelPaymentHybrid !=
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
                                            '${prPaymentRead.costWallet} ${prPrincipalRead.nameMoney}',
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
                                        title: prPaymentRead
                                                    .modelPaymentHybrid !=
                                                null
                                            ? prPaymentRead
                                                        .modelPaymentHybrid !=
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
                                        color: prPaymentRead
                                                    .modelPaymentHybrid!.card !=
                                                null
                                            ? prPaymentWatch.statusErrorCard
                                                ? GlobalColors.colorRed
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
                            const WidgetDivider(),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: WidgetTextFieldPersonalized(
                                      type: 2,
                                      color: GlobalColors.colorLetterTitle,
                                      size: 16,
                                      title: prPaymentRead.modelPaymentHybrid !=
                                              null
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
                                          '${prPaymentRead.costCash} ${prPrincipalRead.nameMoney}',
                                      align: TextAlign.left),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                          visible:
                              prPaymentRead.modelPaymentHybrid!.card != null &&
                                  prPaymentWatch.statusErrorCard,
                          child: Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: WidgetTextFieldPersonalized(
                                color: GlobalColors.colorLetterTitle,
                                type: 1,
                                size: 14,
                                title: prPaymentRead.modelPaymentHybrid!.card !=
                                        null
                                    ? '${GlobalLabel.textMessageMinCard} '
                                        '${prPaymentRead.modelPaymentHybrid!.card!.min} ${prPrincipalRead.nameMoney} '
                                        '${GlobalLabel.textMessagePaymentCash} ${prPaymentRead.costCash} ${prPrincipalRead.nameMoney} ${GlobalLabel.textWithCash}'
                                    : '',
                                align: TextAlign.center),
                          )),
                    ],
                  ),
                  color: GlobalColors.colorWhite),
            )
          ],
        ),
      ),
    );
  }
}

sheetEditPayment(BuildContext context) {
  final prPaymentRead = context.read<ProviderPayment>();
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => Container(
      height: 420,
      margin: const EdgeInsets.only(top: 10.0),
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) =>
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0)),
                      color: Colors.white,
                      border: Border.all(
                        width: 0.5,
                        color: Colors.black12,
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(
                          top: 10.0, left: 15.0, right: 15.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            WidgetTextFieldPersonalized(
                                type: 1,
                                title: prPaymentRead.paymentPrevious,
                                align: TextAlign.center,
                                size: 50,
                                color: GlobalColors.colorLetterTitle),
                            NumericKeyboard(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                onKeyboardTap: (value) {
                                  setState(() {
                                    if (prPaymentRead.paymentPrevious
                                            .trim()
                                            .length <=
                                        7) {
                                      prPaymentRead.paymentPrevious =
                                          GlobalFunction().formatPrice(
                                              prPaymentRead.paymentPrevious,
                                              value);
                                    }
                                  });
                                },
                                textColor: GlobalColors.colorLetterTitle,
                                rightButtonFn: () {
                                  setState(() {
                                    prPaymentRead.resetPaymentPrevious();
                                  });
                                },
                                rightIcon:
                                    const Icon(Icons.backspace, size: 25),
                                leftButtonFn: () {
                                  GlobalFunction().closeView();
                                  prPaymentRead.updatePayment(context);
                                },
                                leftIcon: const Icon(Icons.check, size: 25)),
                          ],
                        ),
                      ),
                    ),
                  )),
        ),
      ),
    ),
  );
}

class ButtonEndServiceHybrid extends StatelessWidget {
  const ButtonEndServiceHybrid({super.key});

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prPrincipalWatch = context.watch<ProviderPrincipal>();
    final prServiceRestRead = context.read<ProviderServiceRest>();
    return Visibility(
      visible: prPrincipalWatch.stateShowButtonPaymentHybrid,
      child: Container(
        margin: const EdgeInsets.only(left: 30, right: 30, top: 10),
        child: WidgetButton(
            text:
                prPrincipalRead.nameTypePay(prPrincipalRead.modelRequestActive),
            type: 1,
            onPressed: () {
              GlobalFunction().hideQuery();
              prServiceRestRead.sendPaymentHybrid(context);
            }),
      ),
    );
  }
}

class ButtonEndStreet extends StatelessWidget {
  const ButtonEndStreet({super.key});

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prTaximeterRead = context.read<ProviderTaximeter>();

    return Visibility(
      visible: prPrincipalRead.stateShowButtonPaymentStreet &&
          !prPrincipalRead.stateShowButtonPaymentHybrid &&
          !prPrincipalRead.stateShowButtonPayment,
      child: Container(
        margin: const EdgeInsets.only(left: 30, right: 30, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            WidgetButton(
                text: GlobalLabel.buttonPaymentService,
                type: 1,
                onPressed: () async {
                  GlobalFunction().nextPageViewTransition(
                      const WidgetCheck(message: GlobalLabel.textEndStreet));
                  prTaximeterRead.updateStateActiveTaximeter(false);
                  prPrincipalRead.finalizeRequest(1);
                }),
          ],
        ),
      ),
    );
  }
}

class ButtonEndService extends StatelessWidget {
  const ButtonEndService({super.key});

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prPrincipalWatch = context.watch<ProviderPrincipal>();
    final prServiceSocketRead = context.read<ProviderServiceSocket>();
    final prServiceRestRead = context.read<ProviderServiceRest>();
    final prTaximeterRead = context.read<ProviderTaximeter>();

    return Visibility(
      visible: prPrincipalWatch.stateShowButtonPayment,
      child: Container(
        margin: const EdgeInsets.only(left: 30, right: 30, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            WidgetButton(
                text:
                    '${GlobalLabel.txtPayment} ${prPrincipalRead.modelRequestActive!.requestData != null ? prPrincipalRead.modelRequestActive!.requestData!.paymentType! != 9 ? prPrincipalRead.nameTypePay(prPrincipalRead.modelRequestActive) : GlobalLabel.textCash : GlobalLabel.textCash}',
                type: 1,
                onPressed: () {
                  switch (prPrincipalRead.modelRequestActive!.requestType) {
                    case 1:
                      GlobalFunction().hideQuery();
                      prServiceSocketRead.sendPaymentService(context);
                      break;
                    case 3:
                      prServiceRestRead.sendFinalizeStreetRequest(
                          context,
                          double.parse(prTaximeterRead.priceTotal.trim()),
                          0,
                          prPrincipalRead.modelRequestActive!.requestData!
                              .destination![0].desC!,
                          prPrincipalRead
                              .modelRequestActive!.requestData!.toll!,
                          prPrincipalRead
                              .modelRequestActive!.requestData!.requestId!);
                      break;
                    case 4:
                      prServiceRestRead.sendFinalizeRequestCallCenter(
                          context,
                          double.parse(prTaximeterRead.priceTotal.trim()),
                          0,
                          0,
                          0,
                          prPrincipalRead
                              .modelRequestActive!.requestData!.requestId!);
                      break;
                  }
                }),
          ],
        ),
      ),
    );
  }
}

class PinVoucher extends StatelessWidget {
  const PinVoucher({super.key});

  @override
  Widget build(BuildContext context) {
    final prPaymentRead = context.read<ProviderPayment>();
    final prPrincipalRead = context.read<ProviderPrincipal>();

    return Visibility(
      visible: prPrincipalRead.modelRequestActive!.requestData != null
          ? prPrincipalRead.modelRequestActive!.requestData!.paymentType == 1
              ? true
              : prPaymentRead.modelPaymentHybrid != null &&
                      prPaymentRead.modelPaymentHybrid!.wallet != null
                  ? prPaymentRead.modelPaymentHybrid!.wallet!.typeWallet == 10
                  : false
          : false,
      child: Container(
        margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
        child: Column(children: [
          WidgetTextFieldTitle(
              title:
                  '${GlobalLabel.textInsertPinVoucher} ${prPrincipalRead.modelRequestActive!.requestData != null ? prPrincipalRead.modelRequestActive!.requestData!.user!.names!.contains(' ') ? prPrincipalRead.modelRequestActive!.requestData!.user!.names!.split(' ')[0].toUpperCase() : prPrincipalRead.modelRequestActive!.requestData!.user!.names!.toUpperCase() : ''}',
              align: TextAlign.center),
          const SizedBox(height: 10),
          WidgetTextFieldEdit(
              identifier: prPaymentRead.editPin,
              limitCharacter: 4,
              typeKeyBoard: TextInputType.number,
              icon: Icons.dialpad_rounded,
              hintText: GlobalLabel.textPinVoucher),
        ]),
      ),
    );
  }
}

class DetailToll extends StatelessWidget {
  const DetailToll({super.key});

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prPaymentWatch = context.watch<ProviderPayment>();
    return Visibility(
      visible: prPaymentWatch.showDetailToll,
      child: WidgetContainer(
        color: GlobalColors.colorWhite,
        widget: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: prPrincipalRead
              .modelRequestActive!.requestData!.pointsToll!.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: WidgetTextFieldSubTitle(
                          title: prPrincipalRead.modelRequestActive!
                              .requestData!.pointsToll![index].name!,
                          align: TextAlign.left),
                    ),
                    Expanded(
                        flex: 0,
                        child: WidgetTextFieldTitle(
                            title:
                                '${prPrincipalRead.modelRequestActive!.requestData!.pointsToll![index].price!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                            align: TextAlign.right))
                  ],
                ),
                index !=
                        prPrincipalRead.modelRequestActive!.requestData!
                                .pointsToll!.length -
                            1
                    ? const WidgetDivider()
                    : Container()
              ],
            );
          },
        ),
      ),
    );
  }
}
