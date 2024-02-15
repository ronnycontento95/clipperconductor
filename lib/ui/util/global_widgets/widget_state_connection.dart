import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/provider_principal.dart';
import '../global_colors.dart';
import '../global_label.dart';
import 'widget_icon.dart';
import 'widget_text_field_personalized.dart';

class WidgetStateConnection extends StatelessWidget {
  const WidgetStateConnection({super.key});

  @override
  Widget build(BuildContext context) {
    final prPrincipalWatch = context.watch<ProviderPrincipal>();
    return Visibility(
      visible: !prPrincipalWatch.stateInternet,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          alignment: Alignment.bottomCenter,
          color: GlobalColors.colorRed.withOpacity(.9),
          height: 60,
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              const Expanded(
                child: Center(
                  child: WidgetTextFieldPersonalized(
                      type: 1,
                      size: 14,
                      color: GlobalColors.colorWhite,
                      title: GlobalLabel.textDescriptionConnection,
                      align: TextAlign.left),
                ),
              ),
              Expanded(
                  flex: 0,
                  child: Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: const WidgetIcon(
                        icon: Icons.wifi_off_rounded,
                        size: 30,
                        colors: GlobalColors.colorWhite),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
