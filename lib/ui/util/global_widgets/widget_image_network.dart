import 'package:flutter/material.dart';

import '../global_colors.dart';
import 'widget_icon.dart';

class WidgetImageNetwork extends StatelessWidget {
  const WidgetImageNetwork(
      {super.key, required this.url, required this.radio, required this.size});

  final String url;
  final double radio;
  final double size;

  @override
  Widget build(BuildContext context) {
    return url.isNotEmpty
        ? ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(radio)),
            child: Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const CircleAvatar(
                  radius: 23.0,
                  backgroundColor: GlobalColors.colorBackgroundView,
                  child: WidgetIcon(
                      icon: Icons.person,
                      size: 35,
                      colors: GlobalColors.colorBlue),
                );
              },
              width: size,
              height: size,
            ),
          )
        : const CircleAvatar(
            radius: 23.0,
            backgroundColor: GlobalColors.colorBackgroundView,
            child: WidgetIcon(
                icon: Icons.person, size: 35, colors: GlobalColors.colorWhite));
  }
}
