import 'package:flutter/material.dart';

import '../util/global_colors.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_scaffold.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';

class PageNoResult extends StatelessWidget {
  const PageNoResult({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return WidgetScaffold(
        onPressed: () => Navigator.pop(context),
        widget: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const CircleAvatar(
              //   radius: 50,
              //   backgroundImage:
              //       AssetImage('${GlobalLabel.directionImageInternal}ghost.gif'),
              // ),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                child: Image.asset(
                  '${GlobalLabel.directionImageInternal}ghost.gif',
                  cacheWidth: 131,
                  cacheHeight: 131,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const CircleAvatar(
                      radius: 23.0,
                      backgroundColor: GlobalColors.colorBackgroundView,
                      child: Icon(Icons.person,
                          size: 35.0, color: GlobalColors.colorWhite),
                    );
                  },
                  width: 104,
                  height: 104,
                ),
              ),
              const SizedBox(height: 20),
              WidgetTextFieldSubTitle(title: message, align: TextAlign.center)
            ],
          ),
        ));
  }
}
