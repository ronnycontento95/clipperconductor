
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../util/global_function.dart';
import '../util/global_widgets/widget_circular_progress_page.dart';
import '../util/global_widgets/widget_scaffold.dart';

class PageTermCondition extends StatefulWidget {
  const PageTermCondition({super.key});

  @override
  State<PageTermCondition> createState() => _PageTermConditionState();
}

class _PageTermConditionState extends State<PageTermCondition> {
  late final WebViewController _controller;
  bool? _showPage = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..enableZoom(false)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {
          if (progress == 100) {
            setState(() {
              _showPage = false;
            });
          }
        },
      ))
      ..loadRequest(
          Uri.parse('https://ktaxi.com.ec/ayuda/terminos_conductor.html'));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: GlobalFunction().colorBarView(),
        child: WidgetScaffold(
            onPressed: () {
              Navigator.pop(context);
            },
            widget: _showPage!
                ? const Center(child: WidgetCircularProgressPage())
                : WebViewWidget(controller: _controller)));
  }
}
