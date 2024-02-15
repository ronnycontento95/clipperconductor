import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../data/response/response_suggestion_destination.dart';
import '../provider/provider_search_destination.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_button.dart';
import '../util/global_widgets/widget_container.dart';
import '../util/global_widgets/widget_divider.dart';
import '../util/global_widgets/widget_message_page.dart';
import '../util/global_widgets/widget_scaffold.dart';
import '../util/global_widgets/widget_text_field_personalized.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';
import '../util/global_widgets/widget_text_field_title.dart';

class PageDetailDestination extends StatefulWidget {
  final ResponseSuggestionDestination responseSuggestionDestination;

  const PageDetailDestination(
      {Key? key, required this.responseSuggestionDestination})
      : super(key: key);

  @override
  State<PageDetailDestination> createState() => _PageDetailDestinationState();
}

class _PageDetailDestinationState extends State<PageDetailDestination> {
  @override
  Widget build(BuildContext context) {
    final prSearchDestination = context.read<ProviderSearchDestination>();
    return WidgetScaffold(
      onPressed: () => Navigator.pop(context),
      widget: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                prSearchDestination.markerSearchDirection(context);
              },
              child: const WidgetMessagePage(
                  title: GlobalLabel.textBestRoute,
                  message: GlobalLabel.textDescriptionBestRoute),
            ),
            DetailDestination(
              responseSuggestionDestination:
                  widget.responseSuggestionDestination,
            ),
            MapDestination(
                responseSuggestionDestination:
                    widget.responseSuggestionDestination),
            ButtonSend(
                responseSuggestionDestination:
                    widget.responseSuggestionDestination),
          ],
        ),
      ),
    );
  }
}

class DetailDestination extends StatelessWidget {
  final ResponseSuggestionDestination responseSuggestionDestination;

  const DetailDestination(
      {Key? key, required this.responseSuggestionDestination})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prSearchDestinationRead = context.read<ProviderSearchDestination>();
    return !prSearchDestinationRead.contList
        ? SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 40, left: 30, right: 30),
                  child: WidgetContainer(
                    color: GlobalColors.colorWhite,
                    widget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: WidgetTextFieldPersonalized(
                                    color: GlobalColors.colorLetterTitle,
                                    type: 1,
                                    size: 18,
                                    title: prSearchDestinationRead
                                        .selectedDirectionStreet
                                        .structuredFormatting!
                                        .mainText!,
                                    align: TextAlign.center)),
                            const SizedBox(height: 30),
                            Row(
                              children: [
                                const Expanded(
                                    flex: 1,
                                    child: WidgetTextFieldSubTitle(
                                        title: GlobalLabel.textDistance,
                                        align: TextAlign.left)),
                                Expanded(
                                  flex: 0,
                                  child: WidgetTextFieldTitle(
                                    title:
                                        '${responseSuggestionDestination.listSuggestion![0].distance!.value!.toStringAsFixed(2)} ${responseSuggestionDestination.listSuggestion![0].distance!.unity!}',
                                    align: TextAlign.right,
                                  ),
                                )
                              ],
                            ),
                            const WidgetDivider(),
                            Row(
                              children: [
                                const Expanded(
                                    flex: 1,
                                    child: WidgetTextFieldSubTitle(
                                        title: GlobalLabel.textCostByDistance,
                                        align: TextAlign.left)),
                                Expanded(
                                    flex: 0,
                                    child: WidgetTextFieldTitle(
                                      title: responseSuggestionDestination
                                          .listSuggestion![0]
                                          .listDetail![0]
                                          .value!,
                                      align: TextAlign.right,
                                    ))
                              ],
                            ),
                            const WidgetDivider(),
                            Row(
                              children: [
                                const Expanded(
                                    flex: 1,
                                    child: WidgetTextFieldSubTitle(
                                        title: GlobalLabel.textTimeEstimated,
                                        align: TextAlign.left)),
                                Expanded(
                                    flex: 0,
                                    child: WidgetTextFieldTitle(
                                      title: responseSuggestionDestination
                                          .listSuggestion![0]
                                          .timeApproximate!
                                          .value!,
                                      align: TextAlign.right,
                                    ))
                              ],
                            ),
                            const WidgetDivider(),
                            Row(
                              children: [
                                const Expanded(
                                    flex: 1,
                                    child: WidgetTextFieldSubTitle(
                                        title: GlobalLabel.textToll,
                                        align: TextAlign.left)),
                                Expanded(
                                    flex: 0,
                                    child: WidgetTextFieldTitle(
                                      title: responseSuggestionDestination
                                          .listSuggestion![0]
                                          .listDetail![1]
                                          .value!,
                                      align: TextAlign.right,
                                    ))
                              ],
                            ),
                            const WidgetDivider(),
                            Row(
                              children: [
                                const Expanded(
                                    flex: 1,
                                    child: WidgetTextFieldSubTitle(
                                        title: GlobalLabel.textCostTotal,
                                        align: TextAlign.left)),
                                Expanded(
                                  flex: 0,
                                  child: WidgetTextFieldTitle(
                                    title: responseSuggestionDestination
                                        .listSuggestion![0]
                                        .listDetail![2]
                                        .value!,
                                    align: TextAlign.right,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // listSuggestion()
              ],
            ),
          )
        : Center(child: GlobalFunction().noResult(GlobalLabel.textNoResult));
  }
}

class ButtonSend extends StatelessWidget {
  final ResponseSuggestionDestination responseSuggestionDestination;

  const ButtonSend({Key? key, required this.responseSuggestionDestination})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prSearchDestination = context.read<ProviderSearchDestination>();
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
      child: WidgetButton(
          text: GlobalLabel.buttonConfirmTravel,
          type: 1,
          onPressed: () {
            prSearchDestination.sendConfirmationTravel(
                responseSuggestionDestination, context);
          }),
    );
  }
}

class MapDestination extends StatefulWidget {
  final ResponseSuggestionDestination responseSuggestionDestination;

  const MapDestination(
      {super.key, required this.responseSuggestionDestination});

  @override
  State<MapDestination> createState() => _MapDestinationState();
}

class _MapDestinationState extends State<MapDestination> {

  @override
  Widget build(BuildContext context) {
    final prSearchDestinationRead = context.read<ProviderSearchDestination>();
    return Container(
      height: 300,
      margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
      child: WidgetContainer(
        color: GlobalColors.colorWhite,
        widget: GoogleMap(
          onMapCreated: (controller) {
            prSearchDestinationRead.loadMap(controller);
          },
          minMaxZoomPreference: const MinMaxZoomPreference(16, 19),
          initialCameraPosition: CameraPosition(
            target: LatLng(prSearchDestinationRead.latitudeStreet,
                prSearchDestinationRead.longitudeStreet),
            zoom: 16,
            tilt: 0,
          ),
          buildingsEnabled: false,
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          markers: {
            prSearchDestinationRead
                    .markers![const MarkerId(GlobalLabel.textMarkerVehicle)] =
                Marker(
                    anchor: const Offset(0.5, 0.5),
                    markerId: const MarkerId(GlobalLabel.textMarkerVehicle),
                    position: LatLng(prSearchDestinationRead.latitudeStreet,
                        prSearchDestinationRead.longitudeStreet),
                    icon: prSearchDestinationRead.iconDestiny!)
          },
          compassEnabled: false,
          rotateGesturesEnabled: false,
          zoomControlsEnabled: false,
          onCameraMove: prSearchDestinationRead.onCameraMove,
        ),
      ),
    );
  }
}
