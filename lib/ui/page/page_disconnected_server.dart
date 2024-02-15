import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_button.dart';
import '../util/global_widgets/widget_image_background.dart';
import '../util/global_widgets/widget_text_field_personalized.dart';
import 'page_splash.dart';

class PageDisconnectedServer extends StatefulWidget {
  const PageDisconnectedServer({Key? key}) : super(key: key);

  @override
  State<PageDisconnectedServer> createState() => _PageDisconnectedServerState();
}

class _PageDisconnectedServerState extends State<PageDisconnectedServer> {
  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarColor:
              GlobalColors.colorBackgroundCream.withOpacity(.1)),
      child: const Scaffold(
        body: PopScope(
          canPop: false,
          child: Stack(
            children: [
              WidgetImageBackground(name: 'background.png'),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MessageDisconnectedService(),
                  ButtonCheckConnected()
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MessageDisconnectedService extends StatelessWidget {
  const MessageDisconnectedService({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetTextFieldPersonalized(
              title: GlobalLabel.textTitleConnectionServer,
              align: TextAlign.left,
              size: 40,
              color: GlobalColors.colorLetterTitle.withOpacity(.4),
              type: 1),
          const WidgetTextFieldPersonalized(
              title: GlobalLabel.textTitleDescriptionConnectionServer,
              align: TextAlign.left,
              size: 40,
              color: GlobalColors.colorLetterTitle,
              type: 1),
          const SizedBox(height: 20),
          const WidgetTextFieldPersonalized(
              title: GlobalLabel.textDescriptionConnectionServer,
              align: TextAlign.left,
              size: 14,
              color: GlobalColors.colorLetterTitle,
              type: 2)
        ],
      ),
    );
  }
}

class ButtonCheckConnected extends StatelessWidget {
  const ButtonCheckConnected({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40, left: 30, right: 30),
      child: WidgetButton(
        text: GlobalLabel.buttonRetry,
        type: 1,
        onPressed: () {
          GlobalFunction().checkConnectionServer().then(
            (value) {
              if (value) {
                GlobalFunction().nextPageUntilView(const PageSplash());
              } else {
                GlobalFunction()
                    .speakMessage(GlobalLabel.textCheckConnectionWifi);
              }
            },
          );
        },
      ),
    );
  }
}
