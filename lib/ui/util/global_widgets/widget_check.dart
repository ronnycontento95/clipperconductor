import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import '../global_colors.dart';
import '../global_function.dart';
import '../global_label.dart';
import 'widget_icon.dart';
import 'widget_text_field_personalized.dart';

class WidgetCheck extends StatefulWidget {
  const WidgetCheck({super.key, required this.message});

  final String message;

  @override
  State<WidgetCheck> createState() => _WidgetCheckState();
}

class _WidgetCheckState extends State<WidgetCheck> {
  @override
  void initState() {
    super.initState();
    GlobalFunction().speakMessage(widget.message);
    Future.delayed(const Duration(seconds: 2), () {
      GlobalFunction().closeView();
      GlobalFunction().closeView();
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
          statusBarColor: GlobalColors.colorGreenAqua,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: GlobalColors.colorGreenAqua),
      child: Scaffold(
        backgroundColor: GlobalColors.colorGreenAqua,
        body: PopScope(
          canPop: false,
          child: Stack(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WidgetAnimator(
                        incomingEffect: WidgetTransitionEffects(
                            delay: const Duration(milliseconds: 400),
                            offset: const Offset(0, -30),
                            curve: Curves.easeOutQuart,
                            duration: const Duration(milliseconds: 400)),
                        atRestEffect: WidgetRestingEffects.wave(),
                        child: const WidgetIcon(
                            icon: Icons.check_circle,
                            size: 100,
                            colors: GlobalColors.colorWhite),
                      ),
                      const SizedBox(height: 20),
                      const WidgetTextFieldPersonalized(
                          title: GlobalLabel.textExcellent,
                          align: TextAlign.center,
                          size: 30,
                          color: GlobalColors.colorWhite,
                          type: 1),
                      const SizedBox(height: 10),
                      const WidgetTextFieldPersonalized(
                          title: GlobalLabel.textSuccessPayment,
                          align: TextAlign.center,
                          size: 18,
                          color: GlobalColors.colorWhite,
                          type: 2)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
