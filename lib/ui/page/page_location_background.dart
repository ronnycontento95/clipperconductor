import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_button.dart';
import '../util/global_widgets/widget_icon_informative.dart';
import '../util/global_widgets/widget_image_background.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';
import '../util/global_widgets/widget_text_field_title.dart';
import 'package:permission_handler/permission_handler.dart' as permit;
import 'page_principal.dart';
import 'page_term_condition.dart';

class PageLocationBackground extends StatefulWidget {
  const PageLocationBackground({super.key});

  @override
  State<PageLocationBackground> createState() => _PageLocationBackgroundState();
}

class _PageLocationBackgroundState extends State<PageLocationBackground>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      final statusBackground = await permit.Permission.locationAlways.status;
      final statusIos = await permit.Permission.locationWhenInUse.status;
      if (Platform.isAndroid) {
        if (statusBackground == permit.PermissionStatus.granted) {
          GlobalFunction().nextPageUntilView(const PagePrincipal());
        }
      } else if (Platform.isIOS) {
        if (statusIos.isGranted) {
          GlobalFunction().nextPageUntilView(const PagePrincipal());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: GlobalFunction().colorBarView(),
        child: const Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                WidgetImageBackground(name: 'imageBackground.png'),
                SingleChildScrollView(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WidgetIconInformative(icon: Icons.info_outline_rounded),
                    MessagePage(),
                    MessagePermissionPage(),
                  ],
                )),
              ],
            ),
          ),
        ));
  }
}

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetTextFieldTitle(
              title: GlobalLabel.textTitleLocationBackground,
              align: TextAlign.center),
          SizedBox(
            height: 10,
          ),
          WidgetTextFieldSubTitle(
              title: GlobalLabel.textDescriptionPermission,
              align: TextAlign.left),
          SizedBox(
            height: 30,
          ),
          Center(
            child: WidgetTextFieldTitle(
                title: GlobalLabel.textTitleDataCollected,
                align: TextAlign.center),
          ),
          SizedBox(
            height: 10,
          ),
          WidgetTextFieldSubTitle(
              title: GlobalLabel.textDescriptionCollectedData,
              align: TextAlign.left),
          SizedBox(
            height: 10,
          ),
          WidgetTextFieldTitle(
              title: GlobalLabel.textTitleImageDriver, align: TextAlign.left),
          SizedBox(
            height: 10,
          ),
          WidgetTextFieldSubTitle(
              title: GlobalLabel.textDescriptionImageDriver,
              align: TextAlign.left),
          SizedBox(
            height: 10,
          ),
          WidgetTextFieldTitle(
              title: GlobalLabel.textTitlePhoneDriver, align: TextAlign.left),
          SizedBox(
            height: 10,
          ),
          WidgetTextFieldSubTitle(
              title: GlobalLabel.textDescriptionPhoneDriver,
              align: TextAlign.left),
          SizedBox(
            height: 10,
          ),
          WidgetTextFieldTitle(
              title: GlobalLabel.textTitleEmailDriver, align: TextAlign.left),
          SizedBox(
            height: 10,
          ),
          WidgetTextFieldSubTitle(
              title: GlobalLabel.textDescriptionEmailDriver,
              align: TextAlign.left),
          SizedBox(
            height: 10,
          ),
          WidgetTextFieldTitle(
              title: GlobalLabel.textTitleLocationDriver,
              align: TextAlign.left),
          SizedBox(
            height: 10,
          ),
          WidgetTextFieldSubTitle(
              title: GlobalLabel.textDescriptionLocationDriver,
              align: TextAlign.left),
        ],
      ),
    );
  }
}

class MessagePermissionPage extends StatelessWidget {
  const MessagePermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: WidgetTextFieldTitle(
                title: GlobalLabel.textTitlePermissionRequired,
                align: TextAlign.center),
          ),
          const SizedBox(
            height: 10,
          ),
          const WidgetTextFieldSubTitle(
              title: GlobalLabel.textDescriptionPermissionRequired,
              align: TextAlign.left),
          const SizedBox(
            height: 10,
          ),
          const WidgetTextFieldTitle(
              title: GlobalLabel.textTitleLocationPermission,
              align: TextAlign.center),
          const SizedBox(
            height: 10,
          ),
          const WidgetTextFieldSubTitle(
              title: GlobalLabel.textDescriptionLocationBackground,
              align: TextAlign.left),
          const SizedBox(
            height: 10,
          ),
          const WidgetTextFieldTitle(
              title: GlobalLabel.textDirectionConfiguration,
              align: TextAlign.center),
          const SizedBox(
            height: 20,
          ),
          // const WidgetTextFieldTitle(
          //     title: GlobalLabel.textTitleInternalStorage,
          //     align: TextAlign.center),
          // const SizedBox(
          //   height: 10,
          // ),
          // const WidgetTextFieldSubTitle(
          //     title: GlobalLabel.textDescriptionInternalStorage,
          //     align: TextAlign.left),
          // const SizedBox(
          //   height: 10,
          // ),
          // const WidgetTextFieldTitle(
          //     title: GlobalLabel.textTitleMicrophone, align: TextAlign.center),
          // const SizedBox(
          //   height: 10,
          // ),
          // const WidgetTextFieldSubTitle(
          //     title: GlobalLabel.textDescriptionMicrophonePermission,
          //     align: TextAlign.left),
          // const SizedBox(
          //   height: 10,
          // ),
          // const WidgetTextFieldTitle(
          //     title: GlobalLabel.textTitleCamera, align: TextAlign.center),
          // const SizedBox(
          //   height: 10,
          // ),
          // const WidgetTextFieldSubTitle(
          //     title: GlobalLabel.textDescriptionCameraPermission,
          //     align: TextAlign.left),
          // const SizedBox(
          //   height: 30,
          // ),
          const WidgetTextFieldSubTitle(
              title: GlobalLabel.textDescriptionCollectedPermission,
              align: TextAlign.left),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                GlobalFunction()
                    .nextPageViewTransition(const PageTermCondition());
              },
              child: const WidgetTextFieldTitle(
                  title: GlobalLabel.textCondition, align: TextAlign.center),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.only(left: 30, right: 30),
            child: WidgetButton(
                text: GlobalLabel.buttonActivePermission,
                type: 1,
                onPressed: () {
                  openAppSettings();
                }),
          )
        ],
      ),
    );
  }
}
