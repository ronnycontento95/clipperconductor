import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../provider/provider_splash.dart';
import '../util/global_colors.dart';
import '../util/global_widgets/widget_image_background_splash.dart';

class PageSplash extends StatefulWidget {
  const PageSplash({super.key});

  @override
  State<PageSplash> createState() => _PageSplashState();
}

class _PageSplashState extends State<PageSplash> {
  ProviderSplash? _providerSplash;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_providerSplash == null) {
      _providerSplash ??= Provider.of<ProviderSplash>(context);
      _providerSplash!.startApp(context);
      _providerSplash!.statusPage = true;
    }
    return const AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: GlobalColors.colorPrincipal),
      child: Scaffold(
          body: Stack(children: [
        WidgetImageBackgroundSplash(name: '27.png'),
      ])),
    );
  }
}
