import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_button.dart';
import '../util/global_widgets/widget_image_background.dart';
import '../util/global_widgets/widget_text_field_personalized.dart';

class PageBlockUser extends StatefulWidget {
  const PageBlockUser({super.key, required this.message});

  final String message;

  @override
  State<PageBlockUser> createState() => _PageBlockUser();
}

class _PageBlockUser extends State<PageBlockUser> {
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
        child:  Scaffold(
            body: Stack(
          children: [
            const WidgetImageBackground(name: 'background.png'),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [InformationMessenger(message: widget.message), const ButtonLogOut()],
            ),
          ],
        )),
      ),
    );
  }
}

class InformationMessenger extends StatelessWidget {
  const InformationMessenger({Key? key, required this.message}) : super(key: key);

  final String message;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30),
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
              title: GlobalLabel.textDescriptionMessageCanceledDriver,
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

class ButtonLogOut extends StatelessWidget {
  const ButtonLogOut({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, right: 30, left: 30),
      child: WidgetButton(
          text: GlobalLabel.buttonAccept,
          type: 1,
          onPressed: () {
            GlobalFunction().closeView();
            GlobalFunction().closeView();
          }),
    );
  }
}
