import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../global_label.dart';

class WidgetImageAssets extends StatelessWidget {
  const WidgetImageAssets({super.key, required this.name, required this.size});

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 3),
      child: Image.asset(
        '${GlobalLabel.directionImageInternal}$name',
        width: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
