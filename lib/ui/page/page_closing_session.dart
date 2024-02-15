import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../provider/provider_service/provider_service_rest.dart';
import '../util/global_colors.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_button.dart';
import '../util/global_widgets/widget_image_background.dart';
import '../util/global_widgets/widget_text_field_personalized.dart';

class PageClosingSession extends StatefulWidget {
  const PageClosingSession({
    Key? key,
    required this.message,
  }) : super(key: key);
  final String message;

  @override
  State<PageClosingSession> createState() => _PageClosingSessionState();
}

class _PageClosingSessionState extends State<PageClosingSession> {
  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor:
                GlobalColors.colorBackgroundCream.withOpacity(.1)),
        child: Scaffold(
          body: Stack(
            children: [
              const WidgetImageBackground(name: 'background.png'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InformationMessenger(message: widget.message),
                  const ButtonLogOutRemote()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InformationMessenger extends StatelessWidget {
  const InformationMessenger({Key? key, required this.message})
      : super(key: key);
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetTextFieldPersonalized(
              title: GlobalLabel.textTitleLogOutRemote,
              align: TextAlign.left,
              size: 40,
              color: GlobalColors.colorLetterTitle.withOpacity(.4),
              type: 1),
          const WidgetTextFieldPersonalized(
              title: GlobalLabel.textTitleLogOutRemoteDescription,
              align: TextAlign.left,
              size: 40,
              color: GlobalColors.colorLetterTitle,
              type: 1),
          const SizedBox(height: 20),
          WidgetTextFieldPersonalized(
              title: message,
              align: TextAlign.left,
              size: 14,
              color: GlobalColors.colorLetterTitle,
              type: 2)
        ],
      ),
    );
  }
}

class ButtonLogOutRemote extends StatelessWidget {
  const ButtonLogOutRemote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prServiceRestRead = context.read<ProviderServiceRest>();
    return Container(
      margin: const EdgeInsets.only(top: 40, left: 30, right: 30),
      child: WidgetButton(
          text: GlobalLabel.buttonAccept,
          type: 1,
          onPressed: () {
            prServiceRestRead.logOut(context);
          }),
    );
  }
}
