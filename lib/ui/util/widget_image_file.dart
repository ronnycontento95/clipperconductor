import 'dart:io';
import 'package:flutter/material.dart';

class WidgetImageFile extends StatelessWidget {
  const WidgetImageFile({super.key, required this.file});

  final File? file;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 150,
      backgroundColor: Colors.transparent,
      child: ClipOval(
          child: file != null
              ? SizedBox(
                  width: 300,
                  child: Image.file(
                    file!,
                    fit: BoxFit.cover,
                  ),
                )
              : Container()),
    );
  }
}
