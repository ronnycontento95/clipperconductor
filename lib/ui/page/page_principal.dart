import 'package:clipp_conductor/ui/util/global_widgets/widget_image_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:siri_wave/siri_wave.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../domain/entities/model_request.dart';
import '../provider/provider_chat_request.dart';
import '../provider/provider_contact.dart';
import '../provider/provider_map.dart';
import '../provider/provider_principal.dart';
import '../provider/provider_report_anomaly.dart';
import '../provider/provider_search_destination.dart';
import '../provider/provider_service/provider_service_rest.dart';
import '../provider/provider_service/provider_service_socket.dart';
import '../provider/provider_transaction.dart';
import '../provider/provider_walkies_talkie.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_button.dart';
import '../util/global_widgets/widget_button_cancel.dart';
import '../util/global_widgets/widget_container.dart';
import '../util/global_widgets/widget_divider.dart';
import '../util/global_widgets/widget_divider_vertical.dart';
import '../util/global_widgets/widget_icon.dart';
import '../util/global_widgets/widget_state_connection.dart';
import '../util/global_widgets/widget_text_field_personalized.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';
import '../util/global_widgets/widget_text_field_title.dart';
import 'page_active_request.dart';
import 'page_chat_request.dart';
import 'page_contact.dart';
import 'page_direction_destiny.dart';
import 'page_direction_origin.dart';
import 'page_gain_day.dart';
import 'page_map.dart';
import 'page_profile.dart';
import 'page_report_anomaly.dart';
import 'page_search_destination.dart';
import 'page_story_view.dart';
import 'package:badges/badges.dart' as badges;

import 'page_taximeter_street.dart';

class PagePrincipal extends StatefulWidget {
  const PagePrincipal({super.key});

  @override
  State<PagePrincipal> createState() => _PagePrincipalState();
}

class _PagePrincipalState extends State<PagePrincipal>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    WidgetsBinding.instance.addObserver(this);
    context.read<ProviderMap>().getPosition(context);
    context.read<ProviderWalkiesTalkie>().initialiseControllers();
    context.read<ProviderWalkiesTalkie>().initialChatAudio();
    context.read<ProviderMap>().listeningStatusGPS(context);
    context.read<ProviderServiceRest>().consultGainQualificationUser(context);
    context.read<ProviderServiceRest>().consultNotification(context);
    context.read<ProviderServiceRest>().consultHeatMap(context);
    context.read<ProviderServiceRest>().consultBalance(context);
    context.read<ProviderServiceRest>().consultBuyPackage(context);
    context.read<ProviderTransaction>().resetMonth(context);
    context.read<ProviderServiceRest>().consultMessageReferred(context);
    context.read<ProviderServiceRest>().getServiceActive(context);
    context.read<ProviderMap>().initLocalNotification();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      GlobalFunction().stopBubble();
    } else if (state == AppLifecycleState.paused) {
      GlobalFunction().startBubble(context);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (prPrincipalRead.listModelRequest!.isNotEmpty) {
          prPrincipalRead.updateShowListRequest(false);
        } else {
          if (!prPrincipalRead.showProfile) {
            GlobalFunction()
                .messageConfirmation(GlobalLabel.textMessageMinimizeApp, () {
              FlutterForegroundTask.minimizeApp();
            });
          }
        }
      },
      child: AnnotatedRegion(
        value: GlobalFunction().colorBarView(),
        child: Scaffold(
          drawer: const Drawer(child: PageProfile()),
          onDrawerChanged: (state) {
            prPrincipalRead.updateStateShowProfile(state);
          },
          body: const SafeArea(
            child: Stack(
              children: [
                MapGoogle(),
                HeaderPage(),
                ButtonNavigator(),
                SwitchService(),
                ListNewRequest(),
                PageActiveRequest(),
                WidgetStateConnection(),
                PageTaximeterStreet()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonNavigator extends StatelessWidget {
  const ButtonNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    final prMapRead = context.read<ProviderMap>();
    final prMapWatch = context.watch<ProviderMap>();
    final prPrincipalWatch = context.watch<ProviderPrincipal>();
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prWalkiesTalkieRead = context.read<ProviderWalkiesTalkie>();
    final prWalkiesTalkieWatch = context.watch<ProviderWalkiesTalkie>();
    return Visibility(
      visible: prMapRead.positionLatitude != 0.0 &&
          prMapRead.positionLongitude != 0.0,
      child: Container(
        alignment: Alignment.bottomRight,
        margin: const EdgeInsets.only(bottom: 250, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Visibility(
              visible: prMapWatch.countAccuracy == 10,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                    color: GlobalColors.colorWhite,
                    border: Border.all(width: .8, color: GlobalColors.colorRed),
                    boxShadow: [
                      BoxShadow(
                        color: GlobalColors.colorRed.withOpacity(.5),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.only(bottom: 20),
                  child: const CircleAvatar(
                      radius: 25,
                      backgroundColor: GlobalColors.colorRed,
                      child: WidgetIcon(
                          icon: Icons.running_with_errors_rounded,
                          size: 25,
                          colors: GlobalColors.colorWhite)),
                ),
              ),
            ),
            Visibility(
              visible: prPrincipalWatch.showNavigatorRoute,
              child: GestureDetector(
                onTap: () {
                  prMapRead.tracingRouteMap(context);
                },
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(50.0)),
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
                    child: const CircleAvatar(
                      backgroundColor: GlobalColors.colorWhite,
                      radius: 25,
                      child: WidgetIcon(
                          icon: Icons.route,
                          size: 30,
                          colors: GlobalColors.colorLetterTitle),
                    )),
              ),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: true,
              child: GestureDetector(
                onTap: () {
                  // GlobalFunction()
                  //     .nextPageViewTransition(const PageWalkiesTalkie());
                },
                onLongPress: () {
                  prWalkiesTalkieWatch.startOrStopRecording(context, 1, 1);
                },
                onLongPressUp: () {
                  prWalkiesTalkieWatch.startOrStopRecording(context, 1, 1);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                    color: GlobalColors.colorWhite,
                    border:
                        Border.all(width: .8, color: GlobalColors.colorBorder),
                    boxShadow: [
                      BoxShadow(
                        color: GlobalColors.colorBorder.withOpacity(.5),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: prWalkiesTalkieRead.isRecording
                        ? GlobalColors.colorOrange
                        : GlobalColors.colorWhite,
                    radius: 25,
                    child: const WidgetIcon(
                        icon: Icons.mic_rounded,
                        size: 30,
                        colors: GlobalColors.colorLetterTitle),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Visibility(
              visible: prPrincipalWatch.listModelRequest!.isNotEmpty,
              child: GestureDetector(
                onTap: () {
                  prPrincipalRead.updateShowListRequest(true);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                    color: GlobalColors.colorWhite,
                    border: Border.all(
                        width: .8, color: GlobalColors.colorGreenAqua),
                    boxShadow: [
                      BoxShadow(
                        color: GlobalColors.colorBorder.withOpacity(.5),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.only(bottom: 20),
                  child: const CircleAvatar(
                      radius: 25,
                      backgroundColor: GlobalColors.colorGreenAqua,
                      child: WidgetIcon(
                          icon: Icons.hail_rounded,
                          size: 25,
                          colors: GlobalColors.colorWhite)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: false,
              child: GestureDetector(
                onTap: () {
                  safety(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: GlobalColors.colorBackgroundView.withOpacity(.5),
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                      radius: 18,
                      backgroundColor: GlobalColors.colorWhite,
                      child: WidgetIcon(
                          icon: Icons.security_outlined,
                          size: 25,
                          colors: GlobalColors.colorLetterTitle)),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                if (prMapWatch.statusGPS) {
                  prMapRead.updateTrackingDriver(context);
                } else {
                  Geolocator.openLocationSettings();
                  GlobalFunction().speakMessage(GlobalLabel.textPetitionGPS);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  color: GlobalColors.colorWhite,
                  border:
                      Border.all(width: .8, color: GlobalColors.colorBorder),
                  boxShadow: [
                    BoxShadow(
                      color: GlobalColors.colorBorder.withOpacity(.5),
                    ),
                  ],
                ),
                child: CircleAvatar(
                    backgroundColor: GlobalColors.colorWhite,
                    radius: 25,
                    child: Icon(
                        prMapWatch.statusGPS
                            ? prPrincipalWatch.stateTracking
                                ? Icons.explore_rounded
                                : Icons.near_me_rounded
                            : Icons.location_disabled_outlined,
                        size: 30,
                        color: GlobalColors.colorLetterTitle)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  safety(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prContactRead = context.read<ProviderContact>();
    final prReportAnomalyRead = context.read<ProviderReportAnomaly>();

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: Material(
          color: Colors.transparent,
          child: SafeArea(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) =>
                  Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: GlobalColors.colorWhite,
                  border: Border.all(
                    width: .2,
                    color: GlobalColors.colorBorder,
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(
                      top: 10.0, left: 15.0, right: 15.0, bottom: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const WidgetTextFieldTitle(
                            title: GlobalLabel.textSafetyTravel,
                            align: TextAlign.center),
                        const WidgetDivider(),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Expanded(
                                flex: 0,
                                child: Icon(Icons.shield_outlined, size: 25)),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    WidgetTextFieldTitle(
                                        title: GlobalLabel.textSharedTravel,
                                        align: TextAlign.left),
                                    WidgetTextFieldSubTitle(
                                        title: GlobalLabel.textContactRouter,
                                        align: TextAlign.left),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 0,
                              child: Checkbox(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  value: prPrincipalRead.sharedTravel,
                                  activeColor: GlobalColors.colorButton,
                                  onChanged: (newValue) {
                                    setState(() {
                                      prPrincipalRead.saveSharedTravel();
                                    });
                                  }),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            const Expanded(
                                flex: 0,
                                child: Icon(Icons.person_outline_outlined,
                                    size: 25)),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  prContactRead.clearAllEdit();

                                  Navigator.pop(
                                      GlobalFunction.context.currentContext!);
                                  GlobalFunction().nextPageViewTransition(
                                      const PageContact());
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  color: Colors.transparent,
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      WidgetTextFieldTitle(
                                          title: GlobalLabel.textMyContact,
                                          align: TextAlign.left),
                                      WidgetTextFieldSubTitle(
                                          title: GlobalLabel.textSelectContact,
                                          align: TextAlign.left)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            const Expanded(
                              flex: 0,
                              child: Icon(Icons.crisis_alert_rounded, size: 25),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  prReportAnomalyRead.cleanTextAll();
                                  Navigator.pop(
                                      GlobalFunction.context.currentContext!);
                                  GlobalFunction().nextPageViewTransition(
                                      const PageReportAnomaly());
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  color: Colors.transparent,
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      WidgetTextFieldTitle(
                                          title: GlobalLabel.textReportAnomaly,
                                          align: TextAlign.left),
                                      WidgetTextFieldSubTitle(
                                          title: GlobalLabel.textAlertAnomaly,
                                          align: TextAlign.left)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            const Expanded(
                                flex: 0,
                                child:
                                    Icon(Icons.emergency_outlined, size: 25)),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(
                                      GlobalFunction.context.currentContext!);
                                  emergency(context);
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  color: Colors.transparent,
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      WidgetTextFieldTitle(
                                          title: GlobalLabel.textAlertPanic,
                                          align: TextAlign.left),
                                      WidgetTextFieldSubTitle(
                                          title: GlobalLabel
                                              .textContactNumberEmergency,
                                          align: TextAlign.left)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  emergency(BuildContext context) {
    final prServiceRead = context.read<ProviderServiceSocket>();
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: GlobalFunction.context.currentContext!,
      builder: (context) => Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: Material(
          color: Colors.transparent,
          child: SafeArea(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) =>
                  Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: GlobalColors.colorWhite,
                  border: Border.all(
                    width: .2,
                    color: GlobalColors.colorBorder,
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(
                      top: 10.0, left: 15.0, right: 15.0, bottom: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const WidgetTextFieldTitle(
                            title: GlobalLabel.textEmergency,
                            align: TextAlign.center),
                        const WidgetDivider(),
                        Column(
                          children: [
                            const WidgetTextFieldSubTitle(
                                title: GlobalLabel.textSendLocation,
                                align: TextAlign.center),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: double.infinity,
                              height: 45,
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: WidgetButton(
                                  text: GlobalLabel.buttonSendLocation,
                                  type: 1,
                                  onPressed: () {
                                    prServiceRead.alertPanic(context, 1);
                                  }),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const WidgetTextFieldSubTitle(
                                title: GlobalLabel.textNumberEmergency,
                                align: TextAlign.center),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 45,
                              width: double.infinity,
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: WidgetButton(
                                text: GlobalLabel.buttonCallEmergency,
                                type: 1,
                                onPressed: () {
                                  Navigator.pop(
                                      GlobalFunction.context.currentContext!);
                                  GlobalFunction().dialCall('911');
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    return null;
  }
}

class SwitchService extends StatelessWidget {
  const SwitchService({super.key});

  @override
  Widget build(BuildContext context) {
    final prMapWatch = context.watch<ProviderMap>();
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prPrincipalWatch = context.watch<ProviderPrincipal>();
    return Visibility(
      visible: prMapWatch.positionLatitude != 0.0 &&
          prMapWatch.positionLongitude != 0.0 &&
          prPrincipalWatch.stateInternet,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Stack(
                children: [
                  Container(
                    margin:
                        const EdgeInsets.only(bottom: 3, left: 20, right: 20),
                    child: ConfirmationSlider(
                      height: 50,
                      width: 300,
                      sliderButtonContent: const WidgetIcon(
                          icon: Icons.keyboard_double_arrow_right_rounded,
                          size: 25,
                          colors: GlobalColors.colorWhite),
                      foregroundColor: prPrincipalWatch.stateService
                          ? GlobalColors.colorBackgroundBlue
                          : GlobalColors.colorSecondary,
                      text: prPrincipalWatch.stateService
                          ? GlobalLabel.buttonDisableRequest
                          : GlobalLabel.buttonActiveService,
                      textStyle: const TextStyle(
                          color: GlobalColors.colorWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      backgroundColor: prPrincipalWatch.stateService
                          ? GlobalColors.colorPrincipal.withOpacity(.8)
                          : GlobalColors.colorLetterTitle.withOpacity(.8),
                      onConfirmation: () {
                        prPrincipalRead.listeningService(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderPage extends StatelessWidget {
  const HeaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final prMapWatch = context.watch<ProviderMap>();
    final prPrincipalWatch = context.watch<ProviderPrincipal>();
    return Visibility(
      visible: prMapWatch.positionLatitude != 0.0 &&
          prMapWatch.positionLongitude != 0.0,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 0,
                child: Visibility(
                  visible:
                      prPrincipalWatch.modelRequestActive!.requestData == null,
                  child: Builder(builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () {
                        if (prPrincipalWatch.countNotification > 0) {
                          GlobalFunction()
                              .nextPageViewTransition(const PageStoriesView());
                        } else {
                          Scaffold.of(context).openDrawer();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: .8, color: GlobalColors.colorBorder),
                            boxShadow: [
                              BoxShadow(
                                color: GlobalColors.colorBackgroundBlue
                                    .withOpacity(.2),
                                blurRadius: 2.0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(50.0),
                            color: GlobalColors.colorBackground),
                        margin:
                            const EdgeInsets.only(left: 10, top: 15, right: 10),
                        child: badges.Badge(
                          showBadge: prPrincipalWatch.countNotification > 0
                              ? true
                              : false,
                          badgeStyle: const badges.BadgeStyle(
                              badgeColor: GlobalColors.colorRed),
                          badgeContent: Text(
                            '${prPrincipalWatch.countNotification}',
                            style: const TextStyle(
                                fontFamily: GlobalLabel.typeLetterTitle,
                                color: GlobalColors.colorWhite,
                                fontWeight: FontWeight.bold),
                          ),
                          child: const CircleAvatar(
                            radius: 25,
                            backgroundColor: GlobalColors.colorBackground,
                            child: WidgetIcon(
                                icon: Icons.menu_open_rounded,
                                size: 30,
                                colors: GlobalColors.colorLetterTitle),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SearchDestine(),
                    GainDay(),
                    // notification(_serviceSocket!),
                  ],
                ),
              ),
            ],
          ),
          const PageDirectionOrigin(),
          const PageDirectionDestiny(),
          const MessageChat(),
          const ChatAudio(),
        ],
      ),
    );
  }
}

class ChatAudio extends StatelessWidget {
  const ChatAudio({super.key});

  @override
  Widget build(BuildContext context) {
    final prWalkiesTalkieWatch = context.watch<ProviderWalkiesTalkie>();
    return Visibility(
      visible: prWalkiesTalkieWatch.showChatAudio,
      child: Container(
          width: double.infinity,
          height: 65,
          margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: GlobalFunction().checkHourDay()
                    ? GlobalColors.colorBackgroundView.withOpacity(.3)
                    : GlobalColors.colorWhite.withOpacity(.3),
                blurRadius: 5.0,
              ),
            ],
            color: GlobalFunction().checkHourDay()
                ? GlobalColors.colorBackgroundView.withOpacity(.8)
                : GlobalColors.colorWhite.withOpacity(.8),
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: GlobalFunction().checkHourDay()
                  ? GlobalColors.colorBackgroundView.withOpacity(.8)
                  : GlobalColors.colorWhite.withOpacity(.8),
              width: .5,
            ),
          ),
          child: Row(
            children: [
              const Expanded(
                flex: 0,
                child: Icon(
                  Icons.mic_none_outlined,
                  color: GlobalColors.colorWhite,
                  size: 30,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  // GlobalWidget().nextPageViewTransition(PageWalkiesTalkie(
                  //     providerPrincipal: _providerPrincipal!,
                  //     serviceSocket: _serviceSocket!));
                  // _providerChatRequest!.deleteBadgeChat();
                },
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WidgetTextFieldPersonalized(
                          title: prWalkiesTalkieWatch.dataEmitChat != null
                              ? '${GlobalLabel.textNameOwnerAudio} '
                                  '${prWalkiesTalkieWatch.dataEmitChat!.n!.toUpperCase()}'
                              : '',
                          align: TextAlign.left,
                          size: 14,
                          color: GlobalFunction().checkHourDay()
                              ? GlobalColors.colorWhite
                              : GlobalColors.colorLetterTitle,
                          type: 1),
                      SizedBox(
                        height: 30,
                        child: SiriWave(
                          controller: SiriWaveController(),
                          options: const SiriWaveOptions(
                            height: 300,
                            showSupportBar: true,
                            width: 600,
                          ),
                          style: SiriWaveStyle.ios_7,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ],
          )),
    );
  }
}

class MessageChat extends StatelessWidget {
  const MessageChat({super.key});

  @override
  Widget build(BuildContext context) {
    final prChatRequestWatch = context.watch<ProviderChatRequest>();
    final prChatRequestRead = context.read<ProviderChatRequest>();
    return Visibility(
      visible: prChatRequestWatch.countChat > 0 ? true : false,
      child: Container(
        margin: const EdgeInsets.only(top: 5, right: 20, left: 20),
        child: WidgetContainer(
            color: GlobalColors.colorMyChat,
            widget: Row(
              children: [
                const Expanded(
                    flex: 0,
                    child: WidgetIcon(
                        icon: Icons.wechat_outlined,
                        size: 30,
                        colors: GlobalColors.colorBackgroundView)),
                const SizedBox(width: 5),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    GlobalFunction()
                        .nextPageViewTransition(const PageChatRequest());
                    prChatRequestWatch.deleteBadgeChat();
                  },
                  child: Container(
                      color: Colors.transparent,
                      child: WidgetTextFieldTitle(
                          title: prChatRequestRead.messageChatUser,
                          align: TextAlign.left)),
                )),
                Expanded(
                  flex: 0,
                  child: GestureDetector(
                      onTap: () {
                        prChatRequestWatch.deleteBadgeChat();
                        prChatRequestRead.updateViewChat();
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: const WidgetIcon(
                            icon: Icons.close_rounded,
                            size: 20,
                            colors: GlobalColors.colorBlack),
                      )),
                )
              ],
            )),
      ),
    );
  }
}

class SearchDestine extends StatelessWidget {
  const SearchDestine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prSearchDestination = context.read<ProviderSearchDestination>();
    final prPrincipalWatch = context.watch<ProviderPrincipal>();
    return Visibility(
      visible: !prPrincipalWatch.stateService &&
          prPrincipalWatch.modelRequestActive!.requestData == null,
      child: GestureDetector(
        onTap: () {
          prSearchDestination.cleanTextFieldSearch();
          GlobalFunction()
              .nextPageViewTransition(const PageSearchDestination());
        },
        child: Container(
          margin: const EdgeInsets.only(right: 10, top: 10),
          height: 50,
          width: 205,
          child: WidgetContainer(
            color: GlobalColors.colorWhite,
            widget: Row(
              children: [
                const WidgetIcon(
                    icon: Icons.search,
                    size: 20,
                    colors: GlobalColors.colorIcon),
                Container(
                  width: 150,
                  margin: const EdgeInsets.only(left: 10),
                  child: const WidgetTextFieldTitle(
                      title: GlobalLabel.textHowGo, align: TextAlign.left),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GainDay extends StatelessWidget {
  const GainDay({super.key});

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prPrincipalWatch = context.watch<ProviderPrincipal>();
    return Visibility(
      visible: prPrincipalWatch.stateService &&
              prPrincipalWatch.modelRequestActive!.requestData == null ||
          (prPrincipalWatch.stateService &&
              prPrincipalWatch.modelRequestActive!.statusDriver != 3 &&
              prPrincipalWatch.modelRequestActive!.requestData != null &&
              prPrincipalWatch
                  .modelRequestActive!.requestData!.destination!.isEmpty),
      child: Container(
        alignment: Alignment.center,
        height: 50,
        margin: const EdgeInsets.only(right: 10.0, top: 15.0),
        padding:
            const EdgeInsets.only(top: 3.0, right: 5.0, left: 5.0, bottom: 3),
        decoration: BoxDecoration(
          border: Border.all(width: .8, color: GlobalColors.colorBorder),
          boxShadow: [
            BoxShadow(
              color: GlobalColors.colorBackgroundBlue.withOpacity(.2),
              blurRadius: 2.0,
            ),
          ],
          color: GlobalColors.colorWhite,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          children: [
            GestureDetector(
                onTap: () {
                  prPrincipalRead.updateStateShowGainDay();
                },
                child: Container(
                    padding: const EdgeInsets.only(left: 5, bottom: 5),
                    child:
                        const WidgetImageAssets(name: 'logo.png', size: 60))),
            WidgetIcon(
                icon: prPrincipalRead.showGainDay
                    ? Icons.navigate_next_rounded
                    : Icons.navigate_before_rounded,
                size: 25,
                colors: GlobalColors.colorLetterTitle),
            Visibility(
              visible: prPrincipalWatch.showGainDay,
              child: GestureDetector(
                onTap: () {
                  GlobalFunction().nextPageViewTransition(const PageGainDay());
                },
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: prPrincipalWatch.gainDay.toStringAsFixed(2),
                    style: const TextStyle(
                        fontSize: 25,
                        color: GlobalColors.colorLetterTitle,
                        fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' ${prPrincipalRead.nameMoney}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListNewRequest extends StatelessWidget {
  const ListNewRequest({super.key});

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prPrincipalWatch = context.watch<ProviderPrincipal>();
    return Visibility(
      visible: prPrincipalWatch.showListRequest,
      child: Container(
        alignment: Alignment.bottomCenter,
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: GlobalFunction().checkHourDay()
                      ? GlobalColors.colorWhite.withOpacity(.8)
                      : GlobalColors.colorBackgroundView.withOpacity(.8))
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: prPrincipalRead.listModelRequest!.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            height: 30,
                            width: double.infinity,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: GlobalColors.colorBackgroundBlue,
                              boxShadow: [
                                BoxShadow(
                                  color: GlobalColors.colorBackgroundBlue
                                      .withOpacity(.5),
                                  blurRadius: 5.0,
                                ),
                              ],
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0)),
                            ),
                            child: Center(
                                child: WidgetTextFieldPersonalized(
                                    type: 1,
                                    color: GlobalColors.colorWhite,
                                    size: 14,
                                    title:
                                        ' ${GlobalLabel.textNewTravel.toUpperCase()} · ${GlobalLabel.txtPayment.toUpperCase()} '
                                        '${prPrincipalRead.nameTypePay(prPrincipalRead.listModelRequest![index])}',
                                    align: TextAlign.center)),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: GlobalColors.colorWhite,
                              boxShadow: [
                                BoxShadow(
                                  color: GlobalColors.colorBackgroundBlue
                                      .withOpacity(.5),
                                  blurRadius: 5.0,
                                ),
                              ],
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20, bottom: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const WidgetIcon(
                                          icon: Icons.person_pin,
                                          size: 60,
                                          colors:
                                              GlobalColors.colorBackgroundBlue),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const WidgetIcon(
                                              icon: Icons.star,
                                              size: 15,
                                              colors: GlobalColors
                                                  .colorLetterTitle),
                                          const SizedBox(width: 5),
                                          WidgetTextFieldPersonalized(
                                              color:
                                                  GlobalColors.colorLetterTitle,
                                              type: 1,
                                              size: 14,
                                              title: prPrincipalRead
                                                  .listModelRequest![index]
                                                  .requestData!
                                                  .user!
                                                  .rating!
                                                  .toStringAsFixed(1),
                                              align: TextAlign.left),
                                          const SizedBox(width: 5),
                                          const WidgetIcon(
                                              icon: Icons.lens_rounded,
                                              size: 5,
                                              colors: GlobalColors
                                                  .colorLetterTitle),
                                          const SizedBox(width: 5),
                                          WidgetTextFieldPersonalized(
                                              color:
                                                  GlobalColors.colorLetterTitle,
                                              type: 1,
                                              size: 14,
                                              title: GlobalFunction()
                                                  .totalTravel(int.parse(
                                                      prPrincipalRead
                                                          .listModelRequest![
                                                              index]
                                                          .requestData!
                                                          .user!
                                                          .totalRequest!
                                                          .toStringAsFixed(0))),
                                              align: TextAlign.left),
                                          const SizedBox(width: 5),
                                          WidgetTextFieldPersonalized(
                                              type: 1,
                                              size: 14,
                                              color:
                                                  GlobalColors.colorLetterTitle,
                                              title: GlobalLabel.textTravel
                                                  .toUpperCase(),
                                              align: TextAlign.left),
                                        ],
                                      ),
                                      const WidgetDivider(),
                                      prPrincipalRead.listModelRequest![index]
                                              .requestData!.destination!.isEmpty
                                          ? StyleRequestNormal(
                                              modelRequest: prPrincipalRead
                                                  .listModelRequest![index])
                                          : StyleRequestDestiny(
                                              modelRequest: prPrincipalRead
                                                  .listModelRequest![index]),
                                      ButtonPostulation(
                                          modelRequest: prPrincipalRead
                                              .listModelRequest![index])
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                  flex: 0,
                  child: GestureDetector(
                    onTap: () {
                      prPrincipalRead.updateShowListRequest(false);
                    },
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: CircleAvatar(
                          radius: 20,
                          backgroundColor: GlobalFunction().checkHourDay()
                              ? GlobalColors.colorBackgroundView
                              : GlobalColors.colorWhite,
                          child: WidgetIcon(
                              icon: Icons.clear,
                              size: 30,
                              colors: GlobalFunction().checkHourDay()
                                  ? GlobalColors.colorWhite
                                  : GlobalColors.colorLetterTitle)),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class StyleRequestNormal extends StatelessWidget {
  const StyleRequestNormal({super.key, required this.modelRequest});

  final ModelRequest modelRequest;

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: modelRequest.requestData!.tip! > 0 ||
              modelRequest.requestData!.toll! > 0,
          child: Column(
            children: [
              Row(
                children: [
                  Visibility(
                    visible: modelRequest.requestData!.tip! > 0,
                    child: Expanded(
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            color: GlobalColors.colorBackgroundGrey
                                .withOpacity(.5),
                            border: Border.all(
                                width: .1, color: GlobalColors.colorBorder),
                            boxShadow: [
                              BoxShadow(
                                color: GlobalColors.colorBackgroundGrey
                                    .withOpacity(.5),
                                blurRadius: 5.0,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const WidgetIcon(
                                  icon: Icons.payments_rounded,
                                  size: 20,
                                  colors: GlobalColors.colorLetterTitle),
                              const SizedBox(width: 10),
                              WidgetTextFieldPersonalized(
                                  size: 16,
                                  type: 1,
                                  color: GlobalColors.colorLetterTitle,
                                  title:
                                      '${modelRequest.requestData!.tip!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                                  align: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Visibility(
                    visible: modelRequest.requestData!.toll! > 0,
                    child: Expanded(
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            color: GlobalColors.colorBackgroundGrey
                                .withOpacity(.5),
                            border: Border.all(
                                width: .1,
                                color: GlobalColors.colorBackgroundGrey),
                            boxShadow: [
                              BoxShadow(
                                color: GlobalColors.colorBackgroundGrey
                                    .withOpacity(.5),
                                blurRadius: 5.0,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const WidgetIcon(
                                  icon: Icons.toll,
                                  size: 20,
                                  colors: GlobalColors.colorLetterTitle),
                              const SizedBox(width: 10),
                              WidgetTextFieldPersonalized(
                                  size: 16,
                                  type: 1,
                                  color: GlobalColors.colorLetterTitle,
                                  title:
                                      '${modelRequest.requestData!.toll!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                                  align: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const WidgetDivider()
            ],
          ),
        ),
        Row(
          children: [
            WidgetTextFieldTitle(
                title: prPrincipalRead
                    .distanceTravelClient(modelRequest.requestData!),
                align: TextAlign.center),
            const SizedBox(width: 3),
            const WidgetIcon(
                icon: Icons.lens_rounded,
                size: 5,
                colors: GlobalColors.colorIcon),
            const SizedBox(width: 3),
            WidgetTextFieldTitle(
                title: '${modelRequest.requestData!.times} min',
                align: TextAlign.center),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WidgetTextFieldPersonalized(
                color: GlobalColors.colorLetterTitle,
                type: 1,
                size: 20,
                title: prPrincipalRead.neighborhoodOriginRequest(modelRequest),
                align: TextAlign.left),
            const SizedBox(height: 5),
            WidgetTextFieldPersonalized(
                type: 2,
                color: GlobalColors.colorLetterSubTitle,
                size: 16,
                title: prPrincipalRead.streetOriginRequest(modelRequest),
                align: TextAlign.left),
          ],
        ),
      ],
    );
  }
}

class StyleRequestDestiny extends StatelessWidget {
  const StyleRequestDestiny({super.key, required this.modelRequest});

  final ModelRequest modelRequest;

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: WidgetTextFieldSubTitle(
              title: GlobalLabel.textValueApproximate, align: TextAlign.center),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: WidgetTextFieldPersonalized(
              type: 1,
              title:
                  '${modelRequest.requestData!.destination![0].isBid == 1 ? modelRequest.requestData!.destination![0].cost!.toStringAsFixed(2) : modelRequest.requestData!.destination![0].desC!.toStringAsFixed(2)} '
                  '${prPrincipalRead.nameMoney}',
              align: TextAlign.center,
              size: 30,
              color: GlobalColors.colorLetterTitle,
            )),
            Visibility(
              visible: modelRequest.requestData!.tip! > 0 ||
                  modelRequest.requestData!.toll! > 0,
              child: Row(
                children: [
                  Visibility(
                    visible: modelRequest.requestData!.tip! > 0,
                    child: Expanded(
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            color: GlobalColors.colorBackgroundGrey
                                .withOpacity(.5),
                            border: Border.all(
                                width: .1, color: GlobalColors.colorBorder),
                            boxShadow: [
                              BoxShadow(
                                color: GlobalColors.colorBackgroundGrey
                                    .withOpacity(.5),
                                blurRadius: 5.0,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const WidgetIcon(
                                  icon: Icons.payments_rounded,
                                  size: 20,
                                  colors: GlobalColors.colorLetterTitle),
                              const SizedBox(width: 10),
                              WidgetTextFieldPersonalized(
                                  size: 16,
                                  type: 1,
                                  color: GlobalColors.colorLetterTitle,
                                  title:
                                      '${modelRequest.requestData!.tip!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                                  align: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Visibility(
                    visible: modelRequest.requestData!.toll! > 0,
                    child: Expanded(
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            color: GlobalColors.colorBackgroundGrey
                                .withOpacity(.5),
                            border: Border.all(
                                width: .1,
                                color: GlobalColors.colorBackgroundGrey),
                            boxShadow: [
                              BoxShadow(
                                color: GlobalColors.colorBackgroundGrey
                                    .withOpacity(.5),
                                blurRadius: 5.0,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const WidgetIcon(
                                  icon: Icons.toll,
                                  size: 20,
                                  colors: GlobalColors.colorLetterTitle),
                              const SizedBox(width: 10),
                              WidgetTextFieldPersonalized(
                                  size: 16,
                                  type: 1,
                                  color: GlobalColors.colorLetterTitle,
                                  title:
                                      '${modelRequest.requestData!.toll!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                                  align: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const WidgetDivider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    WidgetTextFieldTitle(
                        title: prPrincipalRead
                            .distanceTravelClient(modelRequest.requestData!),
                        align: TextAlign.center),
                    const SizedBox(width: 3),
                    const WidgetIcon(
                        icon: Icons.lens_rounded,
                        size: 5,
                        colors: GlobalColors.colorIcon),
                    const SizedBox(width: 3),
                    WidgetTextFieldTitle(
                        title: '${modelRequest.requestData!.times} min',
                        align: TextAlign.center),
                  ],
                ),
                WidgetTextFieldPersonalized(
                    color: GlobalColors.colorLetterTitle,
                    type: 1,
                    size: 20,
                    title:
                        prPrincipalRead.neighborhoodOriginRequest(modelRequest),
                    align: TextAlign.left),
                WidgetTextFieldSubTitle(
                    title: prPrincipalRead.streetOriginRequest(modelRequest),
                    align: TextAlign.left),
              ],
            )),
          ],
        ),
        const SizedBox(height: 30, child: WidgetDividerVertical()),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    WidgetTextFieldTitle(
                        title: prPrincipalRead.distanceTravelOriginDestiny(
                            modelRequest.requestData!),
                        align: TextAlign.center),
                    const SizedBox(width: 3),
                    const WidgetIcon(
                        icon: Icons.lens_rounded,
                        size: 5,
                        colors: GlobalColors.colorIcon),
                    const SizedBox(width: 3),
                    WidgetTextFieldTitle(
                        title:
                            '${prPrincipalRead.formatTimeDestiny(modelRequest.requestData!.destination![0].desT!)} min',
                        align: TextAlign.center),
                  ],
                ),
                WidgetTextFieldPersonalized(
                    color: GlobalColors.colorLetterTitle,
                    type: 1,
                    size: 20,
                    title: prPrincipalRead
                        .neighborhoodDestinyRequest(modelRequest),
                    align: TextAlign.left),
                WidgetTextFieldSubTitle(
                    title: prPrincipalRead.streetDestinyRequest(modelRequest),
                    align: TextAlign.left),
              ],
            )),
          ],
        ),
      ],
    );
  }
}

// class InfoRequestActive extends StatelessWidget {
//   const InfoRequestActive({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final prPrincipalRead = context.read<ProviderPrincipal>();
//     final prPrincipalWatch = context.watch<ProviderPrincipal>();
//     return Visibility(
//       visible: prPrincipalWatch.modelRequestActive!.requestData != null,
//       child: Container(
//           decoration: BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                 color: GlobalColors.colorBackgroundView.withOpacity(.2),
//                 blurRadius: 10.0,
//               ),
//             ],
//             color: GlobalColors.colorWhite,
//             borderRadius: BorderRadius.circular(10.0),
//             border: Border.all(
//               color: GlobalColors.colorBorder,
//               width: .5,
//             ),
//           ),
//           margin: const EdgeInsets.only(left: 10, right: 10, top: 15),
//           padding: const EdgeInsets.only(top: 5),
//           height: 55,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () {},
//                   child: Column(
//                     children: [
//                       Icon(
//                         Icons.location_city,
//                         size: 20,
//                         color: GlobalColors.colorLetterTitle.withOpacity(.8),
//                       ),
//                       WidgetTextFieldPersonalized(
//                           type: 1,
//                           title:
//                               '${prPrincipalRead.modelUser.city!.substring(0, 3)} - ${prPrincipalRead.modelDispositive.version}',
//                           align: TextAlign.left,
//                           size: 14,
//                           color: GlobalColors.colorLetterTitle)
//                     ],
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: Column(
//                   children: [
//                     Icon(
//                       Icons.local_taxi,
//                       size: 20,
//                       color: GlobalColors.colorLetterTitle.withOpacity(.8),
//                     ),
//                     WidgetTextFieldPersonalized(
//                         type: 1,
//                         title: prPrincipalRead.modelUser.vehiclePlate ??=
//                             GlobalLabel.textStranger,
//                         align: TextAlign.center,
//                         size: 14,
//                         color: GlobalColors.colorLetterTitle)
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: Container(
//                   color: Colors.transparent,
//                   child: Column(
//                     children: [
//                       Icon(
//                         Icons.hail_rounded,
//                         color: GlobalColors.colorLetterTitle.withOpacity(.8),
//                         size: 20,
//                       ),
//                       WidgetTextFieldPersonalized(
//                           type: 1,
//                           title: '${prPrincipalRead.getRequestId()}',
//                           align: TextAlign.center,
//                           size: 14,
//                           color: GlobalColors.colorLetterTitle)
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           )),
//     );
//   }
// }

class ButtonPostulation extends StatelessWidget {
  const ButtonPostulation({super.key, required this.modelRequest});

  final ModelRequest modelRequest;

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prServiceRestRead = context.read<ProviderServiceRest>();
    return modelRequest.requestData!.prices!.isEmpty
        ? Container(
            margin: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Expanded(
                  child: WidgetButtonCancel(
                      text: GlobalLabel.buttonDecline,
                      type: 2,
                      onPressed: () {
                        prPrincipalRead.declineRequest(
                            context, modelRequest.requestData!.requestId!);
                      }),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: WidgetButton(
                      text: GlobalLabel.buttonPostulate,
                      type: 1,
                      onPressed: () {
                        prServiceRestRead.sendPostulation(
                            context, modelRequest, 0);
                      }),
                ),
              ],
            ),
          )
        : Container(
            margin: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: WidgetButtonCancel(
                          text: GlobalLabel.buttonDecline,
                          type: 2,
                          onPressed: () {
                            prPrincipalRead.declineRequest(
                                context, modelRequest.requestData!.requestId!);
                          }),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: WidgetButton(
                          text: GlobalLabel.buttonPostulate,
                          type: 1,
                          onPressed: () {
                            prServiceRestRead.sendPostulation(
                                context,
                                modelRequest,
                                modelRequest
                                    .requestData!.destination![0].cost!);
                          }),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const WidgetTextFieldTitle(
                    title: GlobalLabel.textNegotiatePrice,
                    align: TextAlign.center),
                WidgetTextFieldPersonalized(
                    title:
                        '${GlobalLabel.textAddFraction} ${modelRequest.requestData!.destination![0].fraction!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                    align: TextAlign.center,
                    size: 14,
                    color: GlobalColors.colorLetterTitle,
                    type: 2),
                SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 0,
                        child: SizedBox(
                          width: 50,
                          child: GestureDetector(
                            onTap: () {
                              prPrincipalRead.addPrice(modelRequest);
                            },
                            child: const WidgetContainer(
                                widget: WidgetIcon(
                                    icon: Icons.add,
                                    size: 25,
                                    colors: GlobalColors.colorBlack),
                                color: GlobalColors.colorWhite),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 45,
                          width: double.infinity,
                          margin: const EdgeInsets.only(left: 10),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: modelRequest
                                .requestData!.prices!.reversed.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  prServiceRestRead.sendPostulation(
                                      context,
                                      modelRequest,
                                      modelRequest.requestData!.prices![index]);
                                },
                                child: Container(
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0)),
                                    color: GlobalColors.colorBlue,
                                    border: Border.all(
                                        width: .8,
                                        color: GlobalColors.colorBorder),
                                    boxShadow: [
                                      BoxShadow(
                                        color: GlobalColors.colorBorder
                                            .withOpacity(.5),
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: WidgetTextFieldPersonalized(
                                        type: 1,
                                        color: GlobalColors.colorWhite,
                                        size: 16,
                                        title: modelRequest
                                            .requestData!.prices![index]
                                            .toStringAsFixed(2),
                                        align: TextAlign.center),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
