import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../provider/provider_buy_package.dart';
import '../provider/provider_principal.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_container.dart';
import '../util/global_widgets/widget_divider.dart';
import '../util/global_widgets/widget_icon.dart';
import '../util/global_widgets/widget_message_page.dart';
import '../util/global_widgets/widget_scaffold.dart';
import '../util/global_widgets/widget_text_field_personalized.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';
import '../util/global_widgets/widget_text_field_title.dart';

class PageBuyPackage extends StatefulWidget {
  const PageBuyPackage({Key? key}) : super(key: key);

  @override
  State<PageBuyPackage> createState() => _PageBuyPackageState();
}

class _PageBuyPackageState extends State<PageBuyPackage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetScaffold(
      onPressed: () => Navigator.pop(context),
      widget: const Column(
        children: [
          Expanded(
            flex: 0,
            child: WidgetMessagePage(
                title: GlobalLabel.textTitleBuyPackage,
                message: GlobalLabel.textDescriptionBuyPackage),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [PackageRequest(), PackageType()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PackageType extends StatelessWidget {
  const PackageType({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prBuyPackageRead = context.read<ProviderBuyPackage>();
    final prBuyPackageWatch = context.watch<ProviderBuyPackage>();
    return !prBuyPackageWatch.contList
        ? Container(
            margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const WidgetTextFieldTitle(
                    title: GlobalLabel.textHistoryRecharge,
                    align: TextAlign.left),
                const SizedBox(height: 20),
                WidgetContainer(
                  color: GlobalColors.colorWhite,
                  widget: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: prBuyPackageRead.listPackageRequest!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          if (prBuyPackageRead
                              .listPackageRequest![index].lP!.isEmpty) return;
                          GlobalFunction().showProgress();
                          prBuyPackageRead.addListHistoryPackage(context,
                              prBuyPackageRead.listPackageRequest![index].lP!);
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        WidgetTextFieldTitle(
                                            title: prBuyPackageRead
                                                .listPackageRequest![index]
                                                .packageType!,
                                            align: TextAlign.left),
                                        WidgetTextFieldSubTitle(
                                            title: prBuyPackageRead
                                                .listPackageRequest![index]
                                                .description!,
                                            align: TextAlign.left)
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      WidgetTextFieldTitle(
                                          title:
                                              '${prBuyPackageRead.listPackageRequest![index].lP!.length}',
                                          align: TextAlign.right),
                                      const Icon(
                                        Icons.navigate_next_rounded,
                                        color: GlobalColors.colorBackgroundView,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            index !=
                                    prBuyPackageRead
                                            .listPackageRequest!.length -
                                        1
                                ? const WidgetDivider()
                                : Container()
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        : prBuyPackageRead.listPackageRechargeRequest!.isEmpty &&
                prBuyPackageRead.listPackageRechargeOrder!.isEmpty
            ? Container(
                alignment: Alignment.center,
                child: Center(
                    child: GlobalFunction().noResult(GlobalLabel.textNoResult)))
            : Container();
  }
}

class PackageRequest extends StatelessWidget {
  const PackageRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prBuyPackageRead = context.read<ProviderBuyPackage>();
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prBuyPackageWatch = context.watch<ProviderBuyPackage>();
    return Visibility(
      visible: prBuyPackageWatch.listPackageRechargeRequest!.isNotEmpty,
      child: Container(
        margin: const EdgeInsets.only(top: 40, left: 30, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                      height: 28,
                      margin: const EdgeInsets.only(left: 5),
                      child: const WidgetTextFieldTitle(
                          title: GlobalLabel.textPackageRechargeRequest,
                          align: TextAlign.left)),
                ),
                Expanded(
                    flex: 0,
                    child: GestureDetector(
                      onTap: () {
                        // if (_providerBuyPackage!.countPackageRequest!) {
                        //   _providerBuyPackage!
                        //       .canceledPackagePending(widget.providerPrincipal);
                        // }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: Visibility(
                          // visible: prBuyPackageWatch.countPackageRequest,
                          visible: false,
                          child: Icon(
                            Icons.shopping_cart,
                            semanticLabel: "1",
                            color: prBuyPackageWatch.countPackageRequest
                                ? GlobalColors.colorRed
                                : GlobalColors.colorBackgroundView,
                          ),
                        ),
                      ),
                    ))
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 140,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: prBuyPackageWatch.listPackageRechargeRequest!.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 20),
                    width: 200,
                    child: WidgetContainer(
                      color: HexColor(GlobalFunction().colorRandom())
                          .withOpacity(.5),
                      widget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 0,
                              child: WidgetTextFieldPersonalized(
                                  color: GlobalColors.colorWhite,
                                  type: 2,
                                  size: 14,
                                  title: prBuyPackageRead
                                      .listPackageRechargeRequest![index]
                                      .description!,
                                  align: TextAlign.left)),
                          const SizedBox(height: 10),
                          Expanded(
                            flex: 1,
                            child: WidgetTextFieldPersonalized(
                                color: GlobalColors.colorWhite,
                                type: 1,
                                size: 25,
                                title:
                                    '${prBuyPackageRead.listPackageRechargeRequest![index].cost!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                                align: TextAlign.left),
                          ),
                          GestureDetector(
                            onTap: () {
                              // if (_providerBuyPackage!.listPackagePending!.isEmpty) {
                              //   _providerBuyPackage!.consultDetailPackage(
                              //       widget.providerPrincipal, packageRecharge.idPackage!);
                              // } else {
                              //   GlobalWidget().messageError(GlobalLabel.textRechargePending);
                              // }
                            },
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: const WidgetIcon(
                                  icon: Icons.navigate_next_rounded,
                                  size: 25,
                                  colors: GlobalColors.colorWhite),
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
        ),
      ),
    );
  }
}
