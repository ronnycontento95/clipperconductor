import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../global_colors.dart';
import '../global_label.dart';
import 'widget_text_field_personalized.dart';

class WidgetProgress extends StatefulWidget {
  const WidgetProgress({super.key});

  @override
  State<WidgetProgress> createState() => _WidgetProgressState();
}

class _WidgetProgressState extends State<WidgetProgress> {
  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
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
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingAnimationWidget.stretchedDots(
                size: 50,
                color: GlobalColors.colorPrincipal,
              ),
              const SizedBox(height: 10),
              const WidgetTextFieldPersonalized(
                  type: 1,
                  title: GlobalLabel.textWaitMoment,
                  align: TextAlign.center,
                  color: GlobalColors.colorLetterTitle,
                  size: 16)
            ],
          ),
        ),
      ),
    );
  }
}
