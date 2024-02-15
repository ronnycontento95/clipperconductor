import 'package:flutter/material.dart';

import '../global_label.dart';

class WidgetImageBackgroundSplash extends StatelessWidget {
  const WidgetImageBackgroundSplash({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      '${GlobalLabel.directionImageInternalSplash}$name',
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.cover,
    );
  }
}
