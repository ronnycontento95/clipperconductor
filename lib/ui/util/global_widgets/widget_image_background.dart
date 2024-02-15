import 'package:flutter/cupertino.dart';

import '../global_label.dart';

class WidgetImageBackground extends StatelessWidget {
  const WidgetImageBackground({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 3),
      child: Image.asset(
        '${GlobalLabel.directionImageInternal}$name',
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
    );
  }
}
