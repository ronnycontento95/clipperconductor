
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../data/repositories/api_rest.dart';
import '../ui/provider/provider_payment.dart';
import '../ui/provider/provider_taximeter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui/page/page_splash.dart';
import 'ui/provider/provider_balance.dart';
import 'ui/provider/provider_buy_package.dart';
import 'ui/provider/provider_canceled_user.dart';
import 'ui/provider/provider_chat_request.dart';
import 'ui/provider/provider_configuration_app.dart';
import 'ui/provider/provider_contact.dart';
import 'ui/provider/provider_gain.dart';
import 'ui/provider/provider_history_request.dart';
import 'ui/provider/provider_login.dart';
import 'ui/provider/provider_map.dart';
import 'ui/provider/provider_notification.dart';
import 'ui/provider/provider_pre_register.dart';
import 'ui/provider/provider_principal.dart';
import 'ui/provider/provider_radio.dart';
import 'ui/provider/provider_referred.dart';
import 'ui/provider/provider_register_dispositive.dart';
import 'ui/provider/provider_report_anomaly.dart';
import 'ui/provider/provider_request_day.dart';
import 'ui/provider/provider_retrieve_password.dart';
import 'ui/provider/provider_search_destination.dart';
import 'ui/provider/provider_service/provider_service_rest.dart';
import 'ui/provider/provider_service/provider_service_socket.dart';
import 'ui/provider/provider_service_active.dart';
import 'ui/provider/provider_slider.dart';
import 'ui/provider/provider_splash.dart';
import 'ui/provider/provider_total_qualification.dart';
import 'ui/provider/provider_transaction.dart';
import 'ui/provider/provider_update_password.dart';
import 'ui/provider/provider_vehicle_operator.dart';
import 'ui/provider/provider_verify_identity.dart';
import 'ui/provider/provider_walkies_talkie.dart';
import 'ui/util/global_function.dart';
import 'ui/util/global_label.dart';
import 'ui/util/style_scroll.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProviderSplash()),
        ChangeNotifierProvider(create: (_) => ProviderServiceSocket()),
        ChangeNotifierProvider(create: (_) => ProviderServiceRest(ApiRest())),
        ChangeNotifierProvider(create: (_) => ProviderSlider()),
        ChangeNotifierProvider(create: (_) => ProviderLogin()),
        ChangeNotifierProvider(create: (_) => ProviderVehicleOperator()),
        ChangeNotifierProvider(create: (_) => ProviderPrincipal()),
        ChangeNotifierProvider(create: (_) => ProviderMap()),
        ChangeNotifierProvider(create: (_) => ProviderRadio()),
        ChangeNotifierProvider(create: (_) => ProviderTaximeter()),
        ChangeNotifierProvider(create: (_) => ProviderPayment()),
        ChangeNotifierProvider(create: (_) => ProviderRegisterDispositive()),
        ChangeNotifierProvider(create: (_) => ProviderRequestDay()),
        ChangeNotifierProvider(create: (_) => ProviderContact()),
        ChangeNotifierProvider(create: (_) => ProviderReportAnomaly()),
        ChangeNotifierProvider(create: (_) => ProviderSearchDestination()),
        ChangeNotifierProvider(create: (_) => ProviderWalkiesTalkie()),
        ChangeNotifierProvider(create: (_) => ProviderUpdatePassword()),
        ChangeNotifierProvider(create: (_) => ProviderConfigurationApp()),
        ChangeNotifierProvider(create: (_) => ProviderServiceActive()),
        ChangeNotifierProvider(create: (_) => ProviderBuyPackage()),
        ChangeNotifierProvider(create: (_) => ProviderBalance()),
        ChangeNotifierProvider(create: (_) => ProviderTransaction()),
        ChangeNotifierProvider(create: (_) => ProviderCanceledUser()),
        ChangeNotifierProvider(create: (_) => ProviderNotification()),
        ChangeNotifierProvider(create: (_) => ProviderChatRequest()),
        ChangeNotifierProvider(create: (_) => ProviderGain()),
        ChangeNotifierProvider(create: (_) => ProviderHistoryRequest()),
        ChangeNotifierProvider(create: (_) => ProviderPreRegister()),
        ChangeNotifierProvider(create: (_) => ProviderRetrievePassword()),
        ChangeNotifierProvider(create: (_) => ProviderTotalQualification()),
        ChangeNotifierProvider(create: (_) => ProviderReferred()),
        ChangeNotifierProvider(create: (_) => ProviderVerifyIdentity()),
      ],
      child: MaterialApp(
        navigatorKey: GlobalFunction.context,
        debugShowCheckedModeBanner: false,
        scrollBehavior: StyleScroll(),
        title: GlobalLabel.nameApp,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0),
              ),
              child: child!);
        },
        home: const PageSplash(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('es'),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    GlobalFunction().hideProgress();
  }
}

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    WakelockPlus.enable();
    await Firebase.initializeApp();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    renderMap();
    runApp(const MyApp());
  }, (error, stackTrace) {
    if (kDebugMode) {
      final prServiceRestRead =
          GlobalFunction.context.currentContext!.read<ProviderServiceRest>();
      print('ERROR STOP APP >>> : $error');
      print('ERROR STOP APP >>> : ${stackTrace.toString().split('\n')[0]}');
      prServiceRestRead.saveErrorApp(
          error.toString(), stackTrace.toString().split('\n')[0]);
    }
  });
}

void renderMap() async {
  GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  try {
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = true;
      await mapsImplementation
          .initializeWithRenderer(AndroidMapRenderer.legacy);
    }
  } on Exception catch (e) {
    if (kDebugMode) {
      print("ERROR MAP RENDER >>> $e");
    }
  }
}
