import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_principal.dart';
import '../provider/provider_transaction.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_circular_progress_page.dart';
import '../util/global_widgets/widget_container.dart';
import '../util/global_widgets/widget_divider.dart';
import '../util/global_widgets/widget_message_page.dart';
import '../util/global_widgets/widget_scaffold.dart';
import '../util/global_widgets/widget_text_field_personalized.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';
import '../util/global_widgets/widget_text_field_title.dart';

class PageTransaction extends StatefulWidget {
  const PageTransaction({Key? key}) : super(key: key);

  @override
  State<PageTransaction> createState() => _PageTransactionState();
}

class _PageTransactionState extends State<PageTransaction> {
  @override
  void initState() {
    super.initState();
    context.read<ProviderTransaction>().formatMonth();
  }

  @override
  Widget build(BuildContext context) {
    final prTransactionWatch = context.watch<ProviderTransaction>();
    return WidgetScaffold(
        onPressed: () => Navigator.pop(context),
        widget: Column(
          children: [
            const WidgetMessagePage(
                title: GlobalLabel.textTitleTransaction,
                message: GlobalLabel.textDescriptionTransaction),
            const DateMoth(),
            Expanded(
              child: prTransactionWatch.listTransaction!.isEmpty &&
                      !prTransactionWatch.contList
                  ? const Center(
                      child: WidgetCircularProgressPage(),
                    )
                  : const ListTransaction(),
            ),
          ],
        ));
  }
}

class DateMoth extends StatelessWidget {
  const DateMoth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prTransactionWatch = context.watch<ProviderTransaction>();
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            prTransactionWatch.selectMonth(context);
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 30, top: 40, right: 30),
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
                    title: prTransactionWatch.month,
                    align: TextAlign.center,
                    size: 18,
                    color: GlobalColors.colorWhite),
                const SizedBox(width: 5),
                Container(
                  margin: const EdgeInsets.only(bottom: 3),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: GlobalColors.colorWhite,
                    size: 20,
                  ),
                )
              ],
            ),
          ),
        ),
        // totalTransaction()
      ],
    );
  }
}

class TotalTransaction extends StatelessWidget {
  const TotalTransaction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prTransactionWatch = context.watch<ProviderTransaction>();
    final prTransactionRead = context.read<ProviderTransaction>();
    final prPrincipalRead = context.read<ProviderPrincipal>();

    return Visibility(
      visible: prTransactionWatch.listTransaction!.isNotEmpty,
      child: Column(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                color: GlobalColors.colorBackground.withOpacity(.5),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        const WidgetTextFieldSubTitle(
                            title: GlobalLabel.textIncome,
                            align: TextAlign.center),
                        WidgetTextFieldTitle(
                            title:
                                '+ ${prTransactionRead.income.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                            align: TextAlign.center)
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        const WidgetTextFieldSubTitle(
                            title: GlobalLabel.textExpenses,
                            align: TextAlign.center),
                        WidgetTextFieldTitle(
                            title:
                                '+ ${prTransactionRead.discharge.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                            align: TextAlign.center)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          const WidgetDivider()
        ],
      ),
    );
  }
}

class ListTransaction extends StatelessWidget {
  const ListTransaction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prTransactionRead = context.read<ProviderTransaction>();
    final prTransactionWatch = context.watch<ProviderTransaction>();
    final prPrincipalRead = context.read<ProviderPrincipal>();

    return !prTransactionWatch.contList
        ? Container(
            margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: prTransactionRead.listTransaction!.length,
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  WidgetTextFieldSubTitle(
                                      title: GlobalFunction().formatDateServe(
                                          prTransactionRead
                                              .listTransaction![index]
                                              .dateRegister!),
                                      align: TextAlign.left),
                                  const SizedBox(height: 5),
                                  WidgetTextFieldTitle(
                                      title: prTransactionRead
                                          .listTransaction![index].reason!
                                          .replaceAll('-', ' '),
                                      align: TextAlign.left)
                                ],
                              ),
                            ),
                            Expanded(
                              child: WidgetTextFieldTitle(
                                  title:
                                      '${prTransactionRead.listTransaction![index].iT == 2 ? '-' : '+'} ${prTransactionRead.listTransaction![index].balance!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                                  align: TextAlign.right),
                            )
                          ],
                        ),
                        WidgetTextFieldSubTitle(
                            title:
                                '${GlobalLabel.textState} - ${prTransactionRead.listTransaction![index].state}',
                            align: TextAlign.left),
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
