import 'dart:async';
import 'dart:io';

import 'package:battery_info/battery_info_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

import 'package:geolocator/geolocator.dart' as geolo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as permit;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../data/response/response_point_tracing.dart';
import '../../domain/entities/model_heat_map.dart';
import '../../domain/entities/model_point_tracing.dart';
import '../../domain/entities/model_request.dart';
import '../page/page_location_background.dart';
import '../page/page_principal.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_preference.dart';
import 'provider_configuration_app.dart';
import 'provider_principal.dart';
import 'provider_service/provider_service_rest.dart';
import 'provider_splash.dart';
import 'provider_taximeter.dart';

class ProviderMap with ChangeNotifier {
  GoogleMapController? _mapController;
  double? _positionLatitude = 0.0;
  double? _positionLongitude = 0.0;
  double? _positionSpeed = 0.0;
  double? _positionAltitude = 0.0;
  double? _positionAccuracy = 0.0;
  double? _positionRotation = 0.0;
  Timer? _timerTracking;
  Marker? _updateMarker;
  Map<MarkerId, Marker>? markers = {};
  Set<Circle>? _circles = {};
  Map<PolylineId, Polyline>? polyLines = <PolylineId, Polyline>{};
  String? _polylineIdVal;
  Polyline? _polyline;
  StreamSubscription<geolo.ServiceStatus>? _serviceStatusStream;
  bool? _statusGPS = true;
  final Location location = Location();
  LocationData? _location;
  geolo.Position? _locationIos;
  StreamSubscription<LocationData>? _locationSubscriptionAndroid;
  int? _countAccuracy = 0;
  StreamSubscription<geolo.Position>? _locationSubscriptionIos;
  late geolo.LocationSettings locationSettings;
  FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin= FlutterLocalNotificationsPlugin();
  NotificationDetails? _notificationDetails= const NotificationDetails();

  int get countAccuracy => _countAccuracy!;

  set countAccuracy(int value) {
    _countAccuracy = value;
  }

  double get positionRotation => _positionRotation!;

  set positionRotation(double value) {
    _positionRotation = value;
  }

  Set<Circle> get circles => _circles!;

  set circles(Set<Circle> value) {
    _circles = value;
  }

  Marker get updateMarker => _updateMarker!;

  set updateMarker(Marker value) {
    _updateMarker = value;
  }

  double get positionAccuracy => _positionAccuracy!;

  set positionAccuracy(double value) {
    _positionAccuracy = value;
  }

  double get positionAltitude => _positionAltitude!;

  set positionAltitude(double value) {
    _positionAltitude = value;
  }

  double get positionSpeed => _positionSpeed!;

  set positionSpeed(double value) {
    _positionSpeed = value;
  }

  bool get statusGPS => _statusGPS!;

  set statusGPS(bool value) {
    _statusGPS = value;
  }

  StreamSubscription<geolo.ServiceStatus> get serviceStatusStream =>
      _serviceStatusStream!;

  set serviceStatusStream(StreamSubscription<geolo.ServiceStatus> value) {
    _serviceStatusStream = value;
  }

  GoogleMapController get mapController => _mapController!;

  set mapController(GoogleMapController value) {
    _mapController = value;
    notifyListeners();
  }

  double get positionLongitude => _positionLongitude!;

  set positionLongitude(double value) {
    _positionLongitude = value;
  }

  double get positionLatitude => _positionLatitude!;

  set positionLatitude(double value) {
    _positionLatitude = value;
  }

  Future checkGPS(int typeConnected) async {
    final prSplashRead =
        GlobalFunction.context.currentContext!.read<ProviderSplash>();
    final prServiceRestRead =
        GlobalFunction.context.currentContext!.read<ProviderServiceRest>();
    final statusBackground = await permit.Permission.locationAlways.status;
    final statusIos = await permit.Permission.locationWhenInUse.status;
    if (Platform.isAndroid) {
      if (statusBackground == permit.PermissionStatus.granted) {
        if (!(await geolo.Geolocator.isLocationServiceEnabled())) {
          geolo.Geolocator.openLocationSettings();
        } else {
          if (!prSplashRead.statusPage) {
            return prServiceRestRead.consultInProgress(
                GlobalFunction.context.currentContext!, 1);
          }
          GlobalFunction().nextPageUntilView(const PagePrincipal());
          prSplashRead.statusPage = false;
        }
      } else {
        GlobalFunction().nextPageUntilView(const PageLocationBackground());
      }
    } else if (Platform.isIOS) {
      if (!statusIos.isGranted) {
        var status = await permit.Permission.locationWhenInUse.request();
        if (status.isGranted) {
          if (!prSplashRead.statusPage) {
            return prServiceRestRead.consultInProgress(
                GlobalFunction.context.currentContext!, 1);
          }
          GlobalFunction().nextPageUntilView(const PagePrincipal());
          prSplashRead.statusPage = false;
        } else {
          GlobalFunction().nextPageUntilView(const PageLocationBackground());
        }
      } else {
        if (!prSplashRead.statusPage) {
          return prServiceRestRead.consultInProgress(
              GlobalFunction.context.currentContext!, 1);
        }
        GlobalFunction().nextPageUntilView(const PagePrincipal());
        prSplashRead.statusPage = false;
      }
    }
  }

  /// Method for get position of driver
  void getPosition(BuildContext context) async {
    final prPrincipalRead = context.read<ProviderPrincipal>();

    if (Platform.isIOS) {
      if (_locationSubscriptionIos != null) {
        _locationSubscriptionIos!.cancel();
        _locationSubscriptionIos = null;
      }
      geolo.Geolocator.getCurrentPosition().then((position) {
        _positionLatitude = position.latitude;
        _positionLongitude = position.longitude;
        _positionSpeed = position.speed;
        _positionAccuracy = position.accuracy;
        _positionRotation = position.heading;
        _positionAltitude = _positionAltitude;
        moveMapButton();
        markerDriver();
        prPrincipalRead.reconnectedTaximeter(context);
        notifyListeners();
      });
      _locationSubscriptionIos = geolo.Geolocator.getPositionStream()
          .listen((geolo.Position position) {
        _locationIos = position;
        _positionLatitude = _locationIos!.latitude;
        _positionLongitude = _locationIos!.longitude;
        _positionSpeed = _locationIos!.speed;
        _positionAccuracy = _locationIos!.accuracy;
        _positionRotation = _locationIos!.heading;
        _positionAltitude = _positionAltitude;
        if (_locationIos!.speed > 1) {
          moveMapButton();
          GlobalFunction().proximityNotice();
        }
        markerDriver();
        startTimerTracking();
        notifyListeners();
      });
    } else {
      if (_locationSubscriptionAndroid != null) {
        _locationSubscriptionAndroid!.cancel();
        _locationSubscriptionAndroid = null;
      }
      await location.getLocation().then((position) {
        _positionLatitude = position.latitude;
        _positionLongitude = position.longitude;
        _positionSpeed = position.speed;
        _positionAccuracy = position.accuracy;
        _positionRotation = position.heading;
        _positionAltitude = _positionAltitude;
        moveMapButton();
        markerDriver();
        sendDataTracking();
        prPrincipalRead.reconnectedTaximeter(context);
        notifyListeners();
      });

      location.enableBackgroundMode(enable: true);
      _locationSubscriptionAndroid =
          location.onLocationChanged.handleError((dynamic error) {
        if (kDebugMode) {
          print('ERROR LOCATION >>> $error');
        }
        _locationSubscriptionAndroid?.cancel();
        _locationSubscriptionAndroid = null;
      }).listen((currentLocation) {
        _location = currentLocation;
        _positionLatitude = _location!.latitude;
        _positionLongitude = _location!.longitude;
        _positionSpeed = _location!.speed;
        _positionAccuracy = _location!.accuracy;
        _positionRotation = _location!.heading;
        _positionAltitude = _positionAltitude;
        if (_location!.speed! > 1) {
          moveMapButton();
          GlobalFunction().proximityNotice();
        }
        markerDriver();
        startTimerTracking();
        notifyListeners();
      });
    }
    updateNotification();
  }

  initLocalNotification() async {
    if (Platform.isIOS) {
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      var initializationSettingsIOS = const DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true);
      await _flutterLocalNotificationsPlugin!
          .initialize(InitializationSettings(iOS: initializationSettingsIOS));
      _notificationDetails = const NotificationDetails(
          iOS: DarwinNotificationDetails(
        categoryIdentifier: 'plainCategory',
      ));
    }
  }

  /// Update notification
  updateNotification() async {
    final prPrincipal =
        GlobalFunction.context.currentContext!.read<ProviderPrincipal>();
    if (Platform.isIOS) {
      await _flutterLocalNotificationsPlugin!.show(
        GlobalLabel.idApplication,
        '${GlobalLabel.textHello} ${prPrincipal.modelUser.name}',
        prPrincipal.stateService &&
                prPrincipal.modelRequestActive!.requestData != null
            ? GlobalLabel.textDoingRequest
            : prPrincipal.stateService &&
                    prPrincipal.modelRequestActive!.requestData == null
                ? GlobalLabel.textWaitSoonRequest
                : GlobalLabel.textYourOffline,
        _notificationDetails!,
        payload: GlobalLabel.nameApp,
      );
    } else {
      location.changeNotificationOptions(
        channelName: GlobalLabel.nameApp,
        title: '${GlobalLabel.textHello} ${prPrincipal.modelUser.name}',
        subtitle: prPrincipal.stateService &&
                prPrincipal.modelRequestActive!.requestData != null
            ? GlobalLabel.textDoingRequest
            : prPrincipal.stateService &&
                    prPrincipal.modelRequestActive!.requestData == null
                ? GlobalLabel.textWaitSoonRequest
                : GlobalLabel.textYourOffline,
        iconName: 'ic_bubble',
      );
    }
  }

  /// Add marker driver
  void markerDriver() async {
    Marker? marker = markers![const MarkerId(GlobalLabel.textMarkerVehicle)];
    GlobalFunction()
        .createMarker(GlobalFunction().checkHourDay()
            ? '${GlobalLabel.directionImageInternal}blackcircle.png'
            : '${GlobalLabel.directionImageInternal}whitecircle.png')
        .then((markerVehicle) {
      if (marker == null) {
        markers![const MarkerId(GlobalLabel.textMarkerVehicle)] = Marker(
            anchor: const Offset(0.5, 0.5),
            markerId: const MarkerId(GlobalLabel.textMarkerVehicle),
            position: LatLng(_positionLatitude!, _positionLongitude!),
            icon: markerVehicle);
      } else {
        updateMarkers(marker, markerVehicle, GlobalLabel.textMarkerVehicle,
            LatLng(_positionLatitude!, _positionLongitude!));
      }
    });
  }

  Future updateMarkers(Marker marker, BitmapDescriptor markerVehicle,
      String idMarker, LatLng latLng) async {
    _updateMarker = marker.copyWith(
        iconParam: markerVehicle,
        anchorParam: const Offset(0.5, 0.5),
        positionParam: latLng);
    markers![MarkerId(idMarker)] = _updateMarker!;
    notifyListeners();
  }

  /// Add marker destiny client
  void markerDestiny(
      LatLng position, String user, String direction, double distance) async {
    GlobalFunction()
        .createMarker('${GlobalLabel.directionImageInternal}pindestiny.png')
        .then((iconDestiny) {
      markers![const MarkerId(GlobalLabel.textDestinyMarker)] = Marker(
          anchor: const Offset(0.5, 0.5),
          markerId: const MarkerId(GlobalLabel.textDestinyMarker),
          position: position,
          icon: iconDestiny);
    });

    notifyListeners();
  }

  /// Create marker origin
  void markerOrigin(BuildContext context, LatLng position, user, direction,
      double distance) async {
    GlobalFunction()
        .createMarker('${GlobalLabel.directionImageInternal}pinuser.png')
        .then((iconOrigin) {
      markers![const MarkerId(GlobalLabel.textOriginMarker)] = Marker(
          anchor: const Offset(0.5, 0.5),
          markerId: const MarkerId(GlobalLabel.textOriginMarker),
          position: position,
          icon: iconOrigin);
    });
    notifyListeners();
  }

  /// Delete marker
  void deleteMarker(String identifier) {
    if (markers!.isEmpty) return;
    markers!.removeWhere((key, value) => value.markerId.value == identifier);
    notifyListeners();
  }

  /// Listening status GPS
  void listeningStatusGPS(BuildContext context) {
    serviceStatusStream =
        geolo.Geolocator.getServiceStatusStream().listen((serviceStatus) {
      if (serviceStatus == geolo.ServiceStatus.enabled) {
        statusGPS = true;
        GlobalFunction().speakMessage(GlobalLabel.textGPSActive);
      } else {
        statusGPS = false;
        GlobalFunction().speakMessage(GlobalLabel.textGPSInactive);
      }
      notifyListeners();
    });
  }

  void onCameraMove(CameraPosition position) async {}

  /// Method update tracking driver
  void updateTrackingDriver(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    if (prPrincipalRead.stateTracking) {
      prPrincipalRead.stateTracking = false;
      GlobalPreference().setStateTracking(false);
      if (_mapController == null) return;
      _mapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(_positionLatitude!, _positionLongitude!),
            zoom: 15.5,
            tilt: 10,
            bearing: _positionRotation!),
      ));
    } else {
      prPrincipalRead.stateTracking = true;
      GlobalPreference().setStateTracking(true);
      moveMapButton();
    }
  }

  /// Method move map
  void moveMapButton() {
    final prPrincipalRead =
        GlobalFunction.context.currentContext!.read<ProviderPrincipal>();
    if (!prPrincipalRead.stateTracking) return;
    if (_mapController == null) return;
    _mapController!.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(_positionLatitude!, _positionLongitude!),
          zoom: 18,
          tilt: 60,
          bearing: _positionSpeed! > 2 ? _positionRotation! : 0.00),
    ));
  }

  /// Method delete tracing route map
  void deleteTracingRouteMap() {
    polyLines!.clear();
    GlobalPreference.deleteTracedRequestOrigin();
    GlobalPreference.deleteRouterRequestDestiny();
  }

  /// Method tracing route map
  void tracingRouteMap(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prServiceRestRead = context.read<ProviderServiceRest>();
    final prConfigurationAppRead = context.read<ProviderConfigurationApp>();
    if (prPrincipalRead.modelRequestActive!.statusDriver == 3) {
      if (prConfigurationAppRead.modelConfigurationApp.routeMap!) {
        if (prPrincipalRead.modelRequestActive!.requestType != 3) {
          prServiceRestRead.getRouteActiveRequest(
              context,
              LatLng(prPrincipalRead.modelRequestActive!.requestData!.latitude!,
                  prPrincipalRead.modelRequestActive!.requestData!.longitude!),
              1);
        }
      } else if (prConfigurationAppRead.modelConfigurationApp.routeGoogle!) {
        GlobalFunction().openGoogleMaps(
            prPrincipalRead.modelRequestActive!.requestData!.latitude!,
            prPrincipalRead.modelRequestActive!.requestData!.longitude!);
      } else {
        GlobalFunction().openWaze(
            prPrincipalRead.modelRequestActive!.requestData!.latitude!,
            prPrincipalRead.modelRequestActive!.requestData!.longitude!);
      }
    } else if (prPrincipalRead.modelRequestActive!.statusDriver == 5 &&
        prPrincipalRead
            .modelRequestActive!.requestData!.destination!.isNotEmpty) {
      if (prConfigurationAppRead.modelConfigurationApp.routeMap!) {
        prServiceRestRead.getRouteActiveRequest(
            context,
            LatLng(
                prPrincipalRead
                    .modelRequestActive!.requestData!.destination![0].ltD!,
                prPrincipalRead
                    .modelRequestActive!.requestData!.destination![0].lgD!),
            2);
      } else if (prConfigurationAppRead.modelConfigurationApp.routeGoogle!) {
        GlobalFunction().openGoogleMaps(
            prPrincipalRead
                .modelRequestActive!.requestData!.destination![0].ltD!,
            prPrincipalRead
                .modelRequestActive!.requestData!.destination![0].lgD!);
      } else {
        GlobalFunction().openWaze(
            prPrincipalRead
                .modelRequestActive!.requestData!.destination![0].ltD!,
            prPrincipalRead
                .modelRequestActive!.requestData!.destination![0].lgD!);
      }
    }
  }

  /// Stop background location
  void stopBackgroundLocation() {
    if (Platform.isIOS) {
      if (_locationSubscriptionIos != null) {
        _locationSubscriptionIos!.cancel();
        _locationSubscriptionIos = null;
      }
    } else {
      if (_locationSubscriptionAndroid != null) {
        _locationSubscriptionAndroid!.cancel();
        _locationSubscriptionAndroid = null;
      }
    }
  }

  /// Format data tracking
  void sendDataTracking() async {
    final prPrincipalRead =
        GlobalFunction.context.currentContext!.read<ProviderPrincipal>();
    final prServiceRead =
        GlobalFunction.context.currentContext!.read<ProviderServiceRest>();
    final prTaximeterRead =
        GlobalFunction.context.currentContext!.read<ProviderTaximeter>();

    String timeZone = await FlutterTimezone.getLocalTimezone();

    final data = {
      "requestId": prPrincipalRead.modelRequestActive!.requestData != null
          ? prPrincipalRead.modelRequestActive!.requestData!.requestId
          : 0,
      'waitTime': prPrincipalRead.modelRequestActive!.requestData != null &&
              prPrincipalRead.modelRequestActive!.statusDriver == 5
          ? prTaximeterRead.timeTotalWait
          : '00:00:00',
      "distancia": prPrincipalRead.modelRequestActive!.requestData != null
          ? prTaximeterRead.distanceTracking
          : 0,
      "valor": prPrincipalRead.modelRequestActive!.requestData != null &&
              prPrincipalRead.modelRequestActive!.statusDriver == 5
          ? prTaximeterRead.priceStart
          : 0.00,
      "fecha":
          '${GlobalFunction().date.format(GlobalFunction().dateNow)} ${GlobalFunction().hour.format(GlobalFunction().dateNow)}',
      "idEquipo": prPrincipalRead.modelUser.idEquipment,
      "latitud": _positionLatitude,
      "longitud": _positionLongitude,
      "altitud": _positionAltitude,
      "velocidad": _positionSpeed!.toStringAsFixed(2),
      "acury": GlobalFunction().formatAccuracyGPS(_positionAccuracy!),
      "direccion": _positionRotation!,
      "bateria": Platform.isAndroid
          ? (await BatteryInfoPlugin().androidBatteryInfo)!.batteryLevel!
          : (await BatteryInfoPlugin().iosBatteryInfo)?.batteryLevel,
      "conexion": 2,
      "gps": 1,
      "estado": prPrincipalRead.verifyStateTracking(),
      "temperatura": Platform.isAndroid
          ? (await BatteryInfoPlugin().androidBatteryInfo)!.temperature!
          : 0,
      "consumo": 1.32,
      "tipoRed": 0.0,
      "version": prPrincipalRead.modelDispositive.version,
      "timeZone": timeZone,
    };
    prServiceRead.sendTrackingDriver(data);
  }

  /// Get polyline of the route
  void getPolylineRoute(BuildContext context, ResponsePointTracing pointTracing,
      ModelRequest modelRequest, int type) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final List<LatLng> route = [];
    for (ModelPointTracing modelPoint in pointTracing.points!) {
      route.add(LatLng(modelPoint.lat!, modelPoint.lng!));
    }
    if (modelRequest.requestData == null) return;
    if (type == 1) {
      prPrincipalRead.timePostulationRequest(context);
      markerOrigin(
          context,
          LatLng(modelRequest.requestData!.latitude!,
              modelRequest.requestData!.longitude!),
          GlobalLabel.textOriginMarker,
          modelRequest.requestData!.user!.addresses![0].description!,
          modelRequest.requestData!.distance!);
    } else {
      markerDestiny(
          LatLng(modelRequest.requestData!.destination![0].ltD!,
              modelRequest.requestData!.destination![0].lgD!),
          GlobalLabel.textDestinyMarker,
          modelRequest.requestData!.destination![0].desBar!,
          modelRequest.requestData!.destination![0].desDis!);
    }

    addRouteMap(1, route, type);
    moveMapButton();
  }

  /// Add route in the map
  void addRouteMap(
      int polylineIdCounter, List<LatLng> listPoint, int type) async {
    await Future.delayed(const Duration(milliseconds: 300));
    List<LatLng> points = <LatLng>[];
    points.clear();

    for (LatLng position in listPoint) {
      points.add(LatLng(position.latitude, position.longitude));
    }

    _polylineIdVal = 'polyline_id_$polylineIdCounter';
    polylineIdCounter++;
    PolylineId polylineId = PolylineId(_polylineIdVal!);

    _polyline = Polyline(
      polylineId: polylineId,
      consumeTapEvents: true,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      color: type == 1 ? GlobalColors.colorBlue : GlobalColors.colorGreen,
      width: 10,
      points: points,
    );
    polyLines![polylineId] = _polyline!;
    notifyListeners();
  }

  Future<void> loadMap(GoogleMapController controller) async {
    final prPrincipalRead =
        GlobalFunction.context.currentContext!.read<ProviderPrincipal>();
    final prServiceRestRead =
        GlobalFunction.context.currentContext!.read<ProviderServiceRest>();
    _mapController = controller;
    notifyListeners();
    if (_mapController != null) {
      if (GlobalFunction().checkHourDay()) {
        _mapController!.setMapStyle(await rootBundle
            .loadString('${GlobalLabel.typeMap}style_map_day.json'));
        notifyListeners();
      } else {
        _mapController!.setMapStyle(await rootBundle
            .loadString('${GlobalLabel.typeMap}style_map_night.json'));
        notifyListeners();
      }
    }
    if (prPrincipalRead.stateService) {
      prServiceRestRead.consultInProgress(
          GlobalFunction.context.currentContext!, 1);
    }
    GlobalFunction()
        .checkPermissionBubble(GlobalFunction.context.currentContext!);
  }

  void resetTimerTracking() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (_timerTracking != null) {
      _timerTracking!.cancel();
      _timerTracking = null;
    }
  }

  void startTimerTracking() {
    _timerTracking ??=
        Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (positionSpeed > 2) {
        sendDataTracking();
      }
    });
  }

  void addCircleMap(List<ModelHeatMap> list) {
    clearHeatMap();
    for (ModelHeatMap map in list) {
      _circles!.add(
        Circle(
          circleId: CircleId(map.circleId!),
          center: LatLng(map.latitude!, map.longitude!),
          radius: 100,
          strokeWidth: 0,
          fillColor: map.count! <= 5
              ? GlobalFunction().checkHourDay()
                  ? GlobalColors.colorRed.withOpacity(0.1)
                  : GlobalColors.colorRed.withOpacity(0.3)
              : map.count! > 5 && map.count! < 10
                  ? GlobalFunction().checkHourDay()
                      ? GlobalColors.colorRed.withOpacity(0.2)
                      : GlobalColors.colorRed.withOpacity(0.4)
                  : GlobalFunction().checkHourDay()
                      ? GlobalColors.colorRed.withOpacity(0.3)
                      : GlobalColors.colorRed.withOpacity(0.5),
        ),
      );
    }
    notifyListeners();
  }

  void clearHeatMap() {
    if (_circles!.isNotEmpty) _circles!.clear();
    notifyListeners();
  }
}
