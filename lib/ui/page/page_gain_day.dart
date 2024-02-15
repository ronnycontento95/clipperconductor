import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/provider_principal.dart';
import '../provider/provider_service/provider_service_rest.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_button.dart';
import '../util/global_widgets/widget_container.dart';
import '../util/global_widgets/widget_divider.dart';
import '../util/global_widgets/widget_message_page.dart';
import '../util/global_widgets/widget_scaffold.dart';
import '../util/global_widgets/widget_text_field_personalized.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';
import '../util/global_widgets/widget_text_field_title.dart';

class PageGainDay extends StatefulWidget {
  const PageGainDay({Key? key}) : super(key: key);

  @override
  State<PageGainDay> createState() => _PageGainDayState();
}

class _PageGainDayState extends State<PageGainDay> {
  @override
  Widget build(BuildContext context) {
    final prServiceRestRead = context.read<ProviderServiceRest>();
    final prPrincipalRead = context.read<ProviderPrincipal>();
    return WidgetScaffold(
      onPressed: () {
        Navigator.pop(context);
      },
      widget: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WidgetMessagePage(
                title: GlobalLabel.textTitleGainDay,
                message: GlobalLabel.textDescriptionGainDay),
            const GainDay(),
            Visibility(
              visible: prPrincipalRead.gainDay > 0.00,
              child: Container(
                margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
                child: WidgetButton(
                    text: GlobalLabel.buttonWeeklyStatistics,
                    type: 1,
                    onPressed: () {
                      prServiceRestRead.consultRequestDay(context);
                    }),
              ),
            ),
            const DetailGain()
          ],
        ),
      ),
    );
  }
}

class GainDay extends StatelessWidget {
  const GainDay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    return Container(
        margin: const EdgeInsets.only(top: 40, left: 30, right: 30),
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
            WidgetTextFieldPersonalized(
                type: 1,
                size: 14,
                color: GlobalColors.colorWhite,
                title: GlobalFunction()
                    .formatDateGainDay(prPrincipalRead.dateServer),
                align: TextAlign.left),
            WidgetTextFieldPersonalized(
                type: 1,
                title: prPrincipalRead.gainDay.toStringAsFixed(2),
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
        ));
  }
}

class DetailGain extends StatelessWidget {
  const DetailGain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    return Container(
      margin: const EdgeInsets.only(top: 40, left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WidgetTextFieldTitle(
              title: 'Tus estadísticas de conductor', align: TextAlign.left),
          const SizedBox(height: 20),
          WidgetContainer(
              color: GlobalColors.colorWhite,
              widget: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WidgetTextFieldTitle(
                              title: GlobalLabel.textTimeConnection,
                              align: TextAlign.left),
                          WidgetTextFieldSubTitle(
                              title: GlobalLabel.textHourTotalWork,
                              align: TextAlign.left),
                        ],
                      )),
                      Expanded(
                          child: WidgetTextFieldTitle(
                        title: prPrincipalRead.timeConnection,
                        align: TextAlign.right,
                      ))
                    ],
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      child: const WidgetDivider()),
                  Row(
                    children: [
                      const Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WidgetTextFieldTitle(
                              title: GlobalLabel.textServicePerformed,
                              align: TextAlign.left),
                          WidgetTextFieldSubTitle(
                              title: GlobalLabel.textServicePerformedNow,
                              align: TextAlign.left),
                        ],
                      )),
                      Expanded(
                          child: WidgetTextFieldTitle(
                        title: "${prPrincipalRead.numberRequest}",
                        align: TextAlign.right,
                      ))
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
