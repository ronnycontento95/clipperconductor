import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../global_colors.dart';
import '../global_label.dart';
import 'widget_text_field_title.dart';

class WidgetCircularProgressPage extends StatefulWidget {
  const WidgetCircularProgressPage({super.key});

  @override
  State<WidgetCircularProgressPage> createState() =>
      _WidgetCircularProgressPageState();
}

class _WidgetCircularProgressPageState
    extends State<WidgetCircularProgressPage> {
  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
          statusBarColor: GlobalColors.colorWhite,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: GlobalColors.colorWhite),
      child: Scaffold(
        backgroundColor: GlobalColors.colorWhite,
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                color: GlobalColors.colorWhite,
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LoadingAnimationWidget.staggeredDotsWave(
                          size: 50,
                          color: GlobalColors.colorButton,
                        ),
                        const SizedBox(height: 10),
                        const WidgetTextFieldTitle(
                            title: GlobalLabel.textWaitMoment, align: TextAlign.center)
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
