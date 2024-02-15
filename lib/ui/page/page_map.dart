import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../provider/provider_map.dart';
import '../provider/provider_principal.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_widgets/widget_circular_progress_page.dart';

class MapGoogle extends StatefulWidget {
  const MapGoogle({super.key});

  @override
  State<MapGoogle> createState() => _MapGoogleState();
}

class _MapGoogleState extends State<MapGoogle> {
  @override
  Widget build(BuildContext context) {
    final prMapRead = context.read<ProviderMap>();
    final prMapWatch = context.watch<ProviderMap>();
    final prPrincipalRead = context.read<ProviderPrincipal>();
    return prMapWatch.positionLatitude != 0.0 &&
            prMapWatch.positionLongitude != 0.0
        ? GestureDetector(
            onLongPressDown: (_) {
              if (prPrincipalRead.stateTracking) {
                prPrincipalRead.stateTracking = false;
              }
            },
            child: Container(
              color: GlobalFunction().checkHourDay()
                  ? GlobalColors.colorWhite
                  : GlobalColors.colorThemeDark,
              child: GoogleMap(
                onMapCreated: prMapRead.loadMap,
                minMaxZoomPreference: const MinMaxZoomPreference(15.5, 18),
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      prMapRead.positionLatitude, prMapRead.positionLongitude),
                  zoom: !prPrincipalRead.stateTracking ? 15.5 : 18.5,
                  tilt: !prPrincipalRead.stateTracking ? 0 : 55,
                ),
                buildingsEnabled: false,
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                markers:
                    prMapRead.markers != null && prMapRead.markers!.isNotEmpty
                        ? Set<Marker>.of(prMapRead.markers!.values)
                        : <Marker>{},
                circles: prMapRead.circles.isNotEmpty
                    ? Set<Circle>.of(context.read<ProviderMap>().circles)
                    : <Circle>{},
                polylines: prMapRead.polyLines != null &&
                        prMapRead.polyLines!.isNotEmpty
                    ? Set<Polyline>.of(prMapRead.polyLines!.values)
                    : <Polyline>{},
                compassEnabled: false,
                rotateGesturesEnabled: false,
                zoomControlsEnabled: false,
                onCameraMove: prMapRead.onCameraMove,
              ),
            ),
          )
        : const WidgetCircularProgressPage();
  }
}
