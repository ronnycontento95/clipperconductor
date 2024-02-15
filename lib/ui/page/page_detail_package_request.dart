
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_buy_package.dart';
import '../provider/provider_principal.dart';
import '../util/global_colors.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_container.dart';
import '../util/global_widgets/widget_message_page.dart';
import '../util/global_widgets/widget_scaffold.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';
import '../util/global_widgets/widget_text_field_title.dart';

class PageDetailPackageRequest extends StatelessWidget {
  const PageDetailPackageRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidgetScaffold(
        onPressed: () => Navigator.pop(context),
        widget: const SingleChildScrollView(
          child: Column(
            children: [
              WidgetMessagePage(
                  title: GlobalLabel.textTitleHistoryRecharge,
                  message: GlobalLabel.textDescriptionHistoryRecharge),
              ListPackageHistory()
            ],
          ),
        ));
  }
}

class ListPackageHistory extends StatelessWidget {
  const ListPackageHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prBuyPackageRead = context.read<ProviderBuyPackage>();
    final prPrincipalRead = context.read<ProviderPrincipal>();
    return Container(
      margin: const EdgeInsets.only(top: 40),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: prBuyPackageRead.listPackageHistory!.length,
        itemBuilder: (context, index) {
          return Container(
              margin: const EdgeInsets.only(left: 30, right: 30, top: 10),
              child: WidgetContainer(
                color: GlobalColors.colorWhite,
                widget: Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: WidgetTextFieldSubTitle(
                              title: GlobalLabel.textCredit,
                              align: TextAlign.left),
                        ),
                        Expanded(
                          flex: 0,
                          child: WidgetTextFieldTitle(
                              title:
                                  '${prBuyPackageRead.listPackageHistory![index].credit!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                              align: TextAlign.right),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Expanded(
                          child: WidgetTextFieldSubTitle(
                              title: GlobalLabel.textPromotion,
                              align: TextAlign.left),
                        ),
                        Expanded(
                          flex: 0,
                          child: WidgetTextFieldTitle(
                              title:
                                  '${prBuyPackageRead.listPackageHistory![index].promotional!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                              align: TextAlign.right),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Expanded(
                          child: WidgetTextFieldSubTitle(
                              title: GlobalLabel.textTotal,
                              align: TextAlign.left),
                        ),
                        Expanded(
                          flex: 0,
                          child: WidgetTextFieldTitle(
                              title:
                                  '${prBuyPackageRead.listPackageHistory![index].total!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                              align: TextAlign.right),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Expanded(
                          child: WidgetTextFieldSubTitle(
                              title: GlobalLabel.textCostRequest,
                              align: TextAlign.left),
                        ),
                        Expanded(
                          flex: 0,
                          child: WidgetTextFieldTitle(
                              title:
                                  '${prBuyPackageRead.listPackageHistory![index].priceTravel!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                              align: TextAlign.right),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Expanded(
                          child: WidgetTextFieldSubTitle(
                              title: GlobalLabel.textPromotionExpiration,
                              align: TextAlign.left),
                        ),
                        Expanded(
                          flex: 0,
                          child: WidgetTextFieldTitle(
                              title: prBuyPackageRead.listPackageHistory![index]
                                  .expirationPromotion!,
                              align: TextAlign.right),
                        ),
                      ],
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }
}
