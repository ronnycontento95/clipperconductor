import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_configuration_app.dart';
import '../provider/provider_principal.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_container.dart';
import '../util/global_widgets/widget_divider.dart';
import '../util/global_widgets/widget_icon.dart';
import '../util/global_widgets/widget_message_page.dart';
import '../util/global_widgets/widget_scaffold.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';
import '../util/global_widgets/widget_text_field_title.dart';
import 'page_update_password.dart';

class PageConfigurationProfile extends StatelessWidget {
  const PageConfigurationProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prPrincipal = context.read<ProviderPrincipal>();
    return WidgetScaffold(
      onPressed: () => Navigator.pop(context),
      widget: SingleChildScrollView(
        child: Column(
          children: [
            WidgetMessagePage(
                title: '${GlobalLabel.textHi}${prPrincipal.modelUser.name}',
                message: GlobalLabel.textDescriptionConfigurationProfile),
            const Navigation(),
            const ConnectedDispositive(),
            const HeatMap(),
            const Speak(),
            const UpdatePassword()
          ],
        ),
      ),
    );
  }
}

class ConnectedDispositive extends StatefulWidget {
  const ConnectedDispositive({super.key});

  @override
  State<ConnectedDispositive> createState() => _ConnectedDispositiveState();
}

class _ConnectedDispositiveState extends State<ConnectedDispositive> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final prConfigurationAppWatch = context.watch<ProviderConfigurationApp>();
    final prConfigurationAppRead = context.read<ProviderConfigurationApp>();
    return Visibility(
      visible: prConfigurationAppWatch.stateTaximeterBluetooth,
      child: Container(
        margin: const EdgeInsets.only(top: 20, right: 30, left: 30),
        child: WidgetContainer(
            color: GlobalColors.colorWhite,
            widget: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          WidgetTextFieldTitle(
                              title: GlobalLabel.textExternalTaximeter,
                              align: TextAlign.left),
                          WidgetTextFieldSubTitle(
                              title:
                                  GlobalLabel.textDescriptionExternalTaximeter,
                              align: TextAlign.left)
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: Container(
                        margin: const EdgeInsets.only(right: 2),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: prConfigurationAppWatch.statusSearchDispositive
                              ? const WidgetIcon(
                                  icon: Icons.timelapse_rounded,
                                  size: 20,
                                  colors: GlobalColors.colorButton)
                              : Checkbox(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  value: prConfigurationAppWatch.modelConfigurationApp.externalTaximeter,
                                  activeColor: GlobalColors.colorButton,
                                  onChanged: (newValue) {
                                    prConfigurationAppRead
                                        .externalTaximeter(context);
                                  }),
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: prConfigurationAppRead.listDispositive.isNotEmpty,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: prConfigurationAppRead.listDispositive.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const WidgetDivider(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WidgetTextFieldSubTitle(
                                  title: prConfigurationAppRead
                                      .listDispositive[index].device.advName,
                                  align: TextAlign.left),
                              WidgetTextFieldSubTitle(
                                  title: prConfigurationAppRead
                                      .listDispositive[index].device.remoteId
                                      .toString(),
                                  align: TextAlign.left)
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

class UpdatePassword extends StatelessWidget {
  const UpdatePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GlobalFunction().nextPageViewTransition(const PageUpdatePassword());
      },
      child: Container(
        margin: const EdgeInsets.only(top: 20, right: 30, left: 30),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WidgetContainer(
                color: GlobalColors.colorWhite,
                widget: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          WidgetTextFieldTitle(
                              title: GlobalLabel.textUpdatePassword,
                              align: TextAlign.left),
                          WidgetTextFieldSubTitle(
                              title: GlobalLabel.textDescriptionUpdatePassword,
                              align: TextAlign.left)
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: GlobalColors.colorBackground,
                        child: WidgetIcon(
                            icon: Icons.navigate_next_rounded,
                            size: 25,
                            colors: GlobalColors.colorLetterTitle),
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class Navigation extends StatelessWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prConfigurationAppWatch = context.watch<ProviderConfigurationApp>();
    return Container(
      margin: const EdgeInsets.only(top: 40, left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WidgetContainer(
              color: GlobalColors.colorWhite,
              widget: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            WidgetTextFieldTitle(
                                title: GlobalLabel.textGoogleMap,
                                align: TextAlign.left),
                            WidgetTextFieldSubTitle(
                                title: GlobalLabel.textDescriptionNavigation,
                                align: TextAlign.left)
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 0,
                        child: SizedBox(
                          width: 25,
                          child: Checkbox(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              value: prConfigurationAppWatch
                                  .modelConfigurationApp.routeGoogle,
                              activeColor: GlobalColors.colorButton,
                              onChanged: (newValue) {
                                prConfigurationAppWatch.updateConfiguration(1);
                              }),
                        ),
                      ),
                    ],
                  ),
                  const WidgetDivider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            WidgetTextFieldTitle(
                                title: GlobalLabel.textWaze,
                                align: TextAlign.left),
                            WidgetTextFieldSubTitle(
                                title: GlobalLabel.textDescriptionNavigation,
                                align: TextAlign.left)
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 0,
                        child: SizedBox(
                          width: 25,
                          child: Checkbox(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              value: prConfigurationAppWatch
                                  .modelConfigurationApp.routeWaze,
                              activeColor: GlobalColors.colorButton,
                              onChanged: (newValue) {
                                prConfigurationAppWatch.updateConfiguration(2);
                              }),
                        ),
                      ),
                    ],
                  ),
                  const WidgetDivider(),
                  Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            WidgetTextFieldTitle(
                                title: GlobalLabel.textInternalMap,
                                align: TextAlign.left),
                            WidgetTextFieldSubTitle(
                                title: GlobalLabel.textDescriptionInternalMap,
                                align: TextAlign.left)
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 0,
                        child: SizedBox(
                          width: 25,
                          child: Checkbox(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              value: prConfigurationAppWatch
                                  .modelConfigurationApp.routeMap,
                              activeColor: GlobalColors.colorButton,
                              onChanged: (newValue) {
                                prConfigurationAppWatch.updateConfiguration(3);
                              }),
                        ),
                      ),
                    ],
                  )
                ],
              )),
        ],
      ),
    );
  }
}

class HeatMap extends StatelessWidget {
  const HeatMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prConfigurationAppWatch = context.watch<ProviderConfigurationApp>();

    return Container(
      margin: const EdgeInsets.only(top: 20, right: 30, left: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetContainer(
              color: GlobalColors.colorWhite,
              widget: Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        WidgetTextFieldTitle(
                            title: GlobalLabel.textHeatMap,
                            align: TextAlign.left),
                        WidgetTextFieldSubTitle(
                            title: GlobalLabel.textDescriptionHeatMap,
                            align: TextAlign.left)
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: SizedBox(
                      width: 25,
                      child: Checkbox(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          value: prConfigurationAppWatch
                              .modelConfigurationApp.heatMap,
                          activeColor: GlobalColors.colorButton,
                          onChanged: (newValue) {
                            prConfigurationAppWatch.stateHeatMap(context);
                          }),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class Speak extends StatelessWidget {
  const Speak({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prConfigurationAppWatch = context.watch<ProviderConfigurationApp>();

    return Container(
      margin: const EdgeInsets.only(top: 20, right: 30, left: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetContainer(
              color: GlobalColors.colorWhite,
              widget: Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        WidgetTextFieldTitle(
                            title: GlobalLabel.textReadChat,
                            align: TextAlign.left),
                        WidgetTextFieldSubTitle(
                            title: GlobalLabel.textDescriptionReadChat,
                            align: TextAlign.left)
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: SizedBox(
                      width: 25,
                      child: Checkbox(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          value: prConfigurationAppWatch
                              .modelConfigurationApp.speakChat,
                          activeColor: GlobalColors.colorButton,
                          onChanged: (newValue) {
                            prConfigurationAppWatch.stateSpeakChat();
                          }),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
