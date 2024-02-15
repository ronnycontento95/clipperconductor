import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_circular_progress_page.dart';
import '../util/global_widgets/widget_scaffold.dart';

class PageAbout extends StatefulWidget {
  const PageAbout({Key? key}) : super(key: key);

  @override
  State<PageAbout> createState() => _PageAboutState();
}

class _PageAboutState extends State<PageAbout> {
  late final WebViewController _controller;
  bool? _showPage = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(GlobalColors.colorBackgroundView)
      ..setNavigationDelegate(NavigationDelegate(onProgress: (int progress) {
        if (progress == 100) {
          setState(() {
            _showPage = false;
          });
        }
      }))
      ..enableZoom(false)
      ..loadRequest(Uri.parse(
          'https://ktaxi.com.ec/ayuda/acerca.php?name=${GlobalLabel.nameApp}'));
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
