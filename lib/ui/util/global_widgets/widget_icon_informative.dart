import 'package:flutter/material.dart';

import '../global_colors.dart';

class WidgetIconInformative extends StatelessWidget {
  const WidgetIconInformative({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 30),
        child: const CircleAvatar(
          backgroundColor: GlobalColors.colorButton,
          radius: 40,
          child: Icon(
            Icons.info_outline_rounded,
            size: 70,
            color: GlobalColors.colorWhite,
          ),
        ));
  }
}
