import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_principal.dart';
import '../provider/provider_taximeter.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_widgets/widget_text_field_personalized.dart';
import '../util/global_widgets/widget_text_field_title.dart';

class PageTaximeterRequest extends StatelessWidget {
  const PageTaximeterRequest({super.key});

  @override
  Widget build(BuildContext context) {
    final prTaximeterWatch = context.watch<ProviderTaximeter>();
    final prPrincipalRead = context.read<ProviderPrincipal>();

    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: GestureDetector(
        onTap: () {
          GlobalFunction().configurationTaximeter(context);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WidgetTextFieldPersonalized(
                type: 1,
                title: prTaximeterWatch.priceStart,
                align: TextAlign.center,
                size: 36,
                color: GlobalColors.colorLetterTitle),
            WidgetTextFieldTitle(
                title: prPrincipalRead.nameMoney, align: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
