import 'package:flutter/material.dart';
import '../global_colors.dart';
import '../global_function.dart';
import 'widget_icon_button.dart';

class WidgetScaffold extends StatelessWidget {
  const WidgetScaffold(
      {super.key, required this.onPressed, required this.widget});

  final Widget widget;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: GlobalFunction().colorBarView(),
        child: Scaffold(
          appBar: AppBar(
            leading: Container(
              margin: const EdgeInsets.only(left: 20),
              child: WidgetIconButton(
                  onPressed: onPressed,
                  icon: Icons.arrow_back_ios,
                  size: 20,
                  color: GlobalColors.colorLetterTitle),
            ),
            elevation: 0.0,
            backgroundColor: GlobalColors.colorBackground,
            scrolledUnderElevation: 0.0,
            centerTitle: false,
          ),
          backgroundColor: GlobalColors.colorBackground,
          body: SafeArea(
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: widget,
            ),
          ),
        ));
  }
}
