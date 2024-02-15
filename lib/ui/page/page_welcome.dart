import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../provider/provider_pre_register.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_image_background.dart';

import '../util/global_widgets/widget_text_field_personalized.dart';
import '../util/global_widgets/widget_text_field_title.dart';
import 'page_splash.dart';

class PageWelcome extends StatefulWidget {
  const PageWelcome({Key? key}) : super(key: key);

  @override
  State<PageWelcome> createState() => _PageWelcomeState();
}

class _PageWelcomeState extends State<PageWelcome> {
  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const AnnotatedRegion(
      value: SystemUiOverlayStyle(
          statusBarColor: GlobalColors.colorSkiBlue,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: GlobalColors.colorSkiBlue),
      child: Scaffold(
        body: Stack(
          children: [Background()],
        ),
      ),
    );
  }
}

class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DelayedDisplay(
      delay: const Duration(milliseconds: 100),
      child: SizedBox(
        width: MediaQuery.of(GlobalFunction.context.currentContext!).size.width,
        height:
            MediaQuery.of(GlobalFunction.context.currentContext!).size.height,
        child: Stack(
          children: [
            const WidgetImageBackground(name: 'welcome.png'),
            Container(
              margin: const EdgeInsets.only(top: 100, left: 30, right: 30),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[MessageWelcome(), ButtonInitial()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonInitial extends StatelessWidget {
  const ButtonInitial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const DelayedDisplay(
            delay: Duration(seconds: 1),
            child: WidgetTextFieldPersonalized(
                type: 2,
                size: 16,
                color: GlobalColors.colorLetterTitle,
                title: GlobalLabel.textMessageWelcome,
                align: TextAlign.center)),
        const SizedBox(
          height: 30,
        ),
        DelayedDisplay(
          delay: const Duration(seconds: 1),
          child: GestureDetector(
            onTap: () {
              GlobalFunction().nextPageViewTransition(const PageSplash());
            },
            child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: const WidgetTextFieldTitle(
                    title: GlobalLabel.textBackInitial,
                    align: TextAlign.center)),
          ),
        ),
      ],
    );
  }
}

class MessageWelcome extends StatelessWidget {
  const MessageWelcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prPreRegisterRead = context.read<ProviderPreRegister>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 60),
          child: const DelayedDisplay(
              delay: Duration(seconds: 1),
              child: WidgetTextFieldPersonalized(
                  type: 2,
                  color: GlobalColors.colorLetterSubTitle,
                  size: 18,
                  title: GlobalLabel.textTitleWelcome,
                  align: TextAlign.center)),
        ),
        DelayedDisplay(
            delay: const Duration(seconds: 1),
            child: WidgetTextFieldPersonalized(
                type: 1,
                color: GlobalColors.colorLetterTitle,
                size: 20,
                title:
                    '${prPreRegisterRead.preRegistration.name} ${prPreRegisterRead.preRegistration.lastName}',
                align: TextAlign.center)),
      ],
    );
  }
}
