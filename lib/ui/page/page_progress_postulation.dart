import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_principal.dart';
import '../provider/provider_service/provider_service_rest.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_button_disable.dart';
import '../util/global_widgets/widget_image_background.dart';
import '../util/global_widgets/widget_text_field_personalized.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';
import '../util/global_widgets/widget_text_field_title.dart';

class PageProgressPostulation extends StatefulWidget {
  const PageProgressPostulation({super.key});

  @override
  State<PageProgressPostulation> createState() =>
      _PageProgressPostulationState();
}

class _PageProgressPostulationState extends State<PageProgressPostulation> {
  @override
  Widget build(BuildContext context) {
    final prPrincipalWatch = context.watch<ProviderPrincipal>();
    final prPrincipalRead = context.watch<ProviderPrincipal>();
    final prServiceRead = context.read<ProviderServiceRest>();
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: SafeArea(
          child: Container(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              color: GlobalColors.colorWhite,
              duration: const Duration(milliseconds: 100),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                ),
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    const WidgetImageBackground(name: 'imageBackground.png'),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Direction(),
                              const SizedBox(height: 20),
                              WidgetTextFieldPersonalized(
                                  type: 1,
                                  title:
                                      prPrincipalWatch.timeCurrentPostulation,
                                  align: TextAlign.center,
                                  size: 180,
                                  color: GlobalColors.colorLetterTitle),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 0,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              margin:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                children: [
                                  SizedBox(
                                      height: 100,
                                      child: WidgetTextFieldTitle(
                                          title: !prPrincipalWatch
                                                  .sendPostulation
                                              ? GlobalLabel.textSendPostulation
                                              : GlobalLabel.textPostulationSend,
                                          align: TextAlign.center)),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: const WidgetTextFieldSubTitle(
                                        title: GlobalLabel
                                            .textDescriptionPostulation,
                                        align: TextAlign.center),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 10,
                                        bottom: 20),
                                    width: double.infinity,
                                    height: 50,
                                    child: WidgetButtonDisable(
                                      text:
                                          GlobalLabel.buttonCancelledPostulate,
                                      type: !prPrincipalRead.sendPostulation
                                          ? 2
                                          : 1,
                                      onPressed: () {
                                        if (prPrincipalWatch.sendPostulation) {
                                          prServiceRead
                                              .cancelRequestBeforePostulation(
                                                  GlobalFunction
                                                      .context.currentContext!,
                                                  prPrincipalRead
                                                      .modelRequestPostulation!,
                                                  7,
                                                  11);
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Direction extends StatelessWidget {
  const Direction({super.key});

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          WidgetTextFieldPersonalized(
              color: GlobalColors.colorLetterTitle,
              type: 1,
              size: 24,
              title: prPrincipalRead.neighborhoodOriginRequest(
                  prPrincipalRead.modelRequestPostulation!),
              align: TextAlign.center),
          const SizedBox(height: 5),
          WidgetTextFieldSubTitle(
              title: prPrincipalRead.streetOriginRequest(
                  prPrincipalRead.modelRequestPostulation!),
              align: TextAlign.center),
        ],
      ),
    );
  }
}
