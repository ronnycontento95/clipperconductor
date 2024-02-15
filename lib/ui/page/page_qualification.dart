import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_principal.dart';
import '../provider/provider_total_qualification.dart';
import '../util/global_colors.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_container.dart';
import '../util/global_widgets/widget_message_page.dart';
import '../util/global_widgets/widget_scaffold.dart';
import '../util/global_widgets/widget_text_field_personalized.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';
import '../util/global_widgets/widget_text_field_title.dart';

class PageQualification extends StatelessWidget {
  const PageQualification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidgetScaffold(
      onPressed: () => Navigator.pop(context),
      widget: const SingleChildScrollView(
        child: Column(
          children: [
            WidgetMessagePage(
                title: GlobalLabel.textAverageQualification,
                message: GlobalLabel.textDescriptionAverageQualification),
            Qualification(),
            DetailQualification(),
            InfoQualification()
          ],
        ),
      ),
    );
  }
}

class InfoQualification extends StatelessWidget {
  const InfoQualification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WidgetTextFieldTitle(
              title: GlobalLabel.textHowEnhanceQualification,
              align: TextAlign.left),
          Container(
              margin: const EdgeInsets.only(top: 20),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WidgetTextFieldSubTitle(
                      title: GlobalLabel.textDescriptionHowEnhanceQualification,
                      align: TextAlign.left),
                  SizedBox(
                    height: 20,
                  ),
                  WidgetContainer(
                    color: GlobalColors.colorWhite,
                    widget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WidgetTextFieldTitle(
                            title: GlobalLabel.textCleanUnite,
                            align: TextAlign.left),
                        WidgetTextFieldSubTitle(
                            title: GlobalLabel.textDescriptionCleanUnite,
                            align: TextAlign.left),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  WidgetContainer(
                    color: GlobalColors.colorWhite,
                    widget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WidgetTextFieldTitle(
                            title: GlobalLabel.textOnTime,
                            align: TextAlign.left),
                        WidgetTextFieldSubTitle(
                            title: GlobalLabel.textDescriptionOnTime,
                            align: TextAlign.left),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  WidgetContainer(
                    color: GlobalColors.colorWhite,
                    widget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WidgetTextFieldTitle(
                            title: GlobalLabel.textRespect,
                            align: TextAlign.left),
                        WidgetTextFieldSubTitle(
                            title: GlobalLabel.textDescriptionRespect,
                            align: TextAlign.left),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  WidgetContainer(
                    color: GlobalColors.colorWhite,
                    widget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WidgetTextFieldTitle(
                            title: GlobalLabel.textPlaceExactly,
                            align: TextAlign.left),
                        WidgetTextFieldSubTitle(
                            title: GlobalLabel.textDescriptionPlaceExactly,
                            align: TextAlign.left),
                      ],
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class Qualification extends StatelessWidget {
  const Qualification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30, top: 40),
      child: WidgetContainer(
        color: prPrincipalRead.qualificationDriver > 4
            ? GlobalColors.colorBackgroundBlue
            : prPrincipalRead.qualificationDriver > 3 &&
                    prPrincipalRead.qualificationDriver < 4
                ? GlobalColors.colorOrange
                : GlobalColors.colorRed,
        widget: Column(
          children: [
            WidgetTextFieldPersonalized(
              type: 1,
              title: prPrincipalRead.qualificationDriver.toStringAsFixed(1),
              align: TextAlign.center,
              size: 80,
              color: GlobalColors.colorWhite,
            ),
            WidgetTextFieldPersonalized(
                type: 1,
                color: GlobalColors.colorWhite,
                size: 16,
                title: prPrincipalRead.qualificationDriver > 4
                    ? GlobalLabel.textExcellentWork
                    : prPrincipalRead.qualificationDriver > 3 &&
                            prPrincipalRead.qualificationDriver < 4
                        ? GlobalLabel.textImprove
                        : GlobalLabel.textSomethingIsNotRight,
                align: TextAlign.center)
          ],
        ),
      ),
    );
  }
}

class DetailQualification extends StatelessWidget {
  const DetailQualification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prTotalQualificationRest = context.read<ProviderTotalQualification>();
    return Container(
      margin: const EdgeInsets.only(top: 40, left: 30, right: 30),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        color: GlobalColors.colorBackgroundGrey.withOpacity(.2),
        border: Border.all(width: .1, color: GlobalColors.colorBorder),
        boxShadow: [
          BoxShadow(
            color: GlobalColors.colorBackgroundGrey.withOpacity(.2),
            blurRadius: 1.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WidgetTextFieldTitle(
              title: GlobalLabel.textDetailQualification,
              align: TextAlign.left),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.orange.withOpacity(.8),
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.orange.withOpacity(.8),
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.orange.withOpacity(.8),
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.orange.withOpacity(.8),
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.orange.withOpacity(.8),
                    ),
                  ],
                ),
              ),
              Expanded(
                  flex: 0,
                  child: WidgetTextFieldTitle(
                      title:
                          '${prTotalQualificationRest.listTotalQualification![4].quantity}',
                      align: TextAlign.left))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.orange.withOpacity(.8),
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.orange.withOpacity(.8),
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.orange.withOpacity(.8),
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.orange.withOpacity(.8),
                    ),
                  ],
                ),
              ),
              Expanded(
                  flex: 0,
                  child: WidgetTextFieldTitle(
                      title:
                          '${prTotalQualificationRest.listTotalQualification![3].quantity}',
                      align: TextAlign.left)),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.orange.withOpacity(.8),
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.orange.withOpacity(.8),
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.orange.withOpacity(.8),
                    ),
                  ],
                ),
              ),
              Expanded(
                  flex: 0,
                  child: WidgetTextFieldTitle(
                      title:
                          '${prTotalQualificationRest.listTotalQualification![2].quantity}',
                      align: TextAlign.left))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.orange.withOpacity(.8),
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.orange.withOpacity(.8),
                    ),
                  ],
                ),
              ),
              Expanded(
                  flex: 0,
                  child: WidgetTextFieldTitle(
                      title:
                          '${prTotalQualificationRest.listTotalQualification![1].quantity}',
                      align: TextAlign.left))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.orange.withOpacity(.8),
                    ),
                  ],
                ),
              ),
              Expanded(
                  flex: 0,
                  child: WidgetTextFieldTitle(
                      title:
                          '${prTotalQualificationRest.listTotalQualification![0].quantity}',
                      align: TextAlign.left))
            ],
          ),
        ],
      ),
    );
  }
}
