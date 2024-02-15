
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../provider/provider_service/provider_service_rest.dart';
import '../util/global_colors.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_button.dart';
import '../util/global_widgets/widget_image_background.dart';
import '../util/global_widgets/widget_text_field_personalized.dart';

class PageLogOutRemote extends StatefulWidget {
  const PageLogOutRemote({super.key});

  @override
  State<PageLogOutRemote> createState() => _PageLogOutRemoteState();
}

class _PageLogOutRemoteState extends State<PageLogOutRemote> {
  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child:  AnnotatedRegion(
        value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: GlobalColors.colorBackgroundCream.withOpacity(.1)),
        child: const Scaffold(
            body: Stack(
          children: [
            WidgetImageBackground(name: 'background.png'),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [InformationMessenger(), ButtonLogOut()],
            ),
          ],
        )),
      ),
    );
  }
}

class InformationMessenger extends StatelessWidget {
  const InformationMessenger({Key? key}) : super(key: key);

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
              title: GlobalLabel.textTitleLogOutRemoteDescription,
              align: TextAlign.left,
              size: 40,
              color: GlobalColors.colorLetterTitle,
              type: 1),
          const SizedBox(height: 20),
          const WidgetTextFieldPersonalized(
              title: GlobalLabel.textDescriptionLogOutRemote,
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
    final prServiceRestRead = context.read<ProviderServiceRest>();
    return Container(
      margin: const EdgeInsets.only(top: 20, right: 30, left: 30),
      child: WidgetButton(
          text: GlobalLabel.buttonLogOutRemote,
          type: 1,
          onPressed: () {
            prServiceRestRead.logOutRemote(context);
          }),
    );
  }
}
