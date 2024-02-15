import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_balance.dart';
import '../provider/provider_principal.dart';
import '../provider/provider_service/provider_service_rest.dart';
import '../util/global_colors.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_button.dart';
import '../util/global_widgets/widget_container.dart';
import '../util/global_widgets/widget_divider.dart';
import '../util/global_widgets/widget_message_page.dart';
import '../util/global_widgets/widget_scaffold.dart';
import '../util/global_widgets/widget_text_field_personalized.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';
import '../util/global_widgets/widget_text_field_title.dart';

class PageBalance extends StatelessWidget {
  const PageBalance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidgetScaffold(
        onPressed: () => Navigator.pop(context),
        widget: const SingleChildScrollView(
          child: Column(
            children: [
              WidgetMessagePage(
                  title: GlobalLabel.textTitleBalance,
                  message: GlobalLabel.textDescriptionBalance),
              TableMont(),
              BalanceTotal(),
              PayDebts()
            ],
          ),
        ));
  }
}

class PayDebts extends StatelessWidget {
  const PayDebts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prBalanceRead = context.read<ProviderBalance>();
    final prBalanceWatch = context.watch<ProviderBalance>();
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prServiceRestRead = context.read<ProviderServiceRest>();
    return Visibility(
      visible: prBalanceWatch.listDebts!.isNotEmpty,
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WidgetContainer(
              color: GlobalColors.colorWhite,
              widget: Column(
                children: [
                  const WidgetTextFieldTitle(
                      title: GlobalLabel.textMomentPay,
                      align: TextAlign.center),
                  const WidgetDivider(),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: WidgetTextFieldSubTitle(
                            title: GlobalLabel.textMontDebts,
                            align: TextAlign.left),
                      ),
                      Expanded(
                        flex: 1,
                        child: WidgetTextFieldTitle(
                            title:
                                '${prBalanceRead.payDebtsTotal.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                            align: TextAlign.right),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: prBalanceRead.listDebts!.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    WidgetContainer(
                      color: GlobalColors.colorWhite,
                      widget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WidgetTextFieldSubTitle(
                              title:
                                  prBalanceRead.listDebts![index].description!,
                              align: TextAlign.left),
                          Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: WidgetTextFieldTitle(
                                            title:
                                                '${prBalanceRead.listDebts![index].debts!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                                            align: TextAlign.left),
                                      ),
                                      Expanded(
                                        flex: 0,
                                        child: SizedBox(
                                          width: 120,
                                          child: WidgetButton(
                                              text: GlobalLabel.buttonPayDebts,
                                              type: 1,
                                              onPressed: () {
                                                prServiceRestRead.payDebts(
                                                    context,
                                                    prBalanceRead
                                                        .listDebts![index]
                                                        .debts!,
                                                    prBalanceRead
                                                        .listDebts![index]
                                                        .idDebts!);
                                              }),
                                        ),
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10)
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonBalance extends StatelessWidget {
  const ButtonBalance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidgetButton(
        text: GlobalLabel.buttonPayDebts, type: 1, onPressed: () {});
  }
}

class BalanceTotal extends StatelessWidget {
  const BalanceTotal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prBalanceWatch = context.watch<ProviderBalance>();
    final prPrincipalRead = context.read<ProviderPrincipal>();

    return Container(
      margin: const EdgeInsets.only(top: 10, left: 30, right: 30),
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
              type: 1,
              size: 14,
              color: GlobalColors.colorWhite,
              title: GlobalLabel.textTotalBalance,
              align: TextAlign.left),
          WidgetTextFieldPersonalized(
              type: 1,
              title: prBalanceWatch.balanceTotal.toStringAsFixed(2),
              align: TextAlign.center,
              size: 50,
              color: GlobalColors.colorWhite),
          WidgetTextFieldPersonalized(
              type: 1,
              size: 16,
              color: GlobalColors.colorWhite,
              title: prPrincipalRead.nameMoney,
              align: TextAlign.center),
        ],
      ),
    );
  }
}

class TableMont extends StatelessWidget {
  const TableMont({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prBalanceWatch = context.watch<ProviderBalance>();
    final prBalanceRead = context.read<ProviderBalance>();
    final prPrincipalRead = context.read<ProviderPrincipal>();
    return Visibility(
      visible:
          prBalanceWatch.contList && prBalanceWatch.listBalance!.isNotEmpty,
      child: Container(
        margin: const EdgeInsets.all(20),
        child: WidgetContainer(
          color: GlobalColors.colorWhite,
          widget: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: prBalanceRead.listBalance!.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: WidgetTextFieldSubTitle(
                              title: prBalanceRead.listBalance![index].reason!,
                              align: TextAlign.left)),
                      Expanded(
                          flex: 0,
                          child: WidgetTextFieldTitle(
                              title:
                                  '${prBalanceRead.listBalance![index].balance!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                              align: TextAlign.left))
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
