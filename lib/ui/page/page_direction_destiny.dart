import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_principal.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_divider.dart';
import '../util/global_widgets/widget_icon.dart';
import '../util/global_widgets/widget_text_field_personalized.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';
import 'page_detail_request.dart';

class PageDirectionDestiny extends StatelessWidget {
  const PageDirectionDestiny({super.key});

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prPrincipalWatch = context.watch<ProviderPrincipal>();
    return Visibility(
      visible: prPrincipalWatch.modelRequestActive!.requestData != null
          ? prPrincipalWatch.modelRequestActive!.statusDriver == 5 &&
                  prPrincipalWatch
                      .modelRequestActive!.requestData!.destination!.isNotEmpty
              ? true
              : false
          : false,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: GlobalColors.colorWhite,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(width: .3, color: GlobalColors.colorWhite),
          boxShadow: [
            BoxShadow(
              color: GlobalColors.colorBackgroundBlue.withOpacity(.4),
              blurRadius: 8.0,
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: GestureDetector(
          onTap: (){
            GlobalFunction().nextPageViewTransition(const PageDetailRequest());
          },
          child: Row(
            children: [
              const Expanded(
                flex: 0,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: GlobalColors.colorGreen,
                  child: WidgetIcon(
                      icon: Icons.directions,
                      size: 20,
                      colors: GlobalColors.colorWhite),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const WidgetTextFieldSubTitle(
                        title: GlobalLabel.textEndDestiny, align: TextAlign.left),
                    const WidgetDivider(),
                    WidgetTextFieldPersonalized(
                        type: 1,
                        title: prPrincipalRead.neighborhoodDestinyRequest(
                            prPrincipalRead.modelRequestActive!),
                        align: TextAlign.left,
                        size: 15,
                        color: GlobalColors.colorLetterTitle),
                    WidgetTextFieldPersonalized(
                        type: 2,
                        color: GlobalColors.colorLetterTitle,
                        size: 14,
                        title: prPrincipalRead.streetDestinyRequest(
                            prPrincipalRead.modelRequestActive!),
                        align: TextAlign.left),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
