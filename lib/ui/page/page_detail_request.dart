import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../provider/provider_chat_request.dart';
import '../provider/provider_map.dart';
import '../provider/provider_principal.dart';
import '../provider/provider_service/provider_service_rest.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_container.dart';
import '../util/global_widgets/widget_divider.dart';
import '../util/global_widgets/widget_icon.dart';
import '../util/global_widgets/widget_scaffold.dart';
import '../util/global_widgets/widget_text_field_personalized.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';
import '../util/global_widgets/widget_text_field_title.dart';
import 'page_chat_request.dart';
import 'package:badges/badges.dart' as badges;

class PageDetailRequest extends StatefulWidget {
  const PageDetailRequest({super.key});

  @override
  State<PageDetailRequest> createState() => _PageDetailRequestState();
}

class _PageDetailRequestState extends State<PageDetailRequest> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetScaffold(
        onPressed: () {
          Navigator.pop(context);
        },
        widget: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 30, right: 30),
                child: const WidgetTextFieldPersonalized(
                    type: 1,
                    title: GlobalLabel.textDetailService,
                    align: TextAlign.left,
                    size: 25,
                    color: GlobalColors.colorLetterTitle),
              ),
              const MapOrigenService(),
              const PageDetailUser(),
              const PageDetailService(),
              const TypePayment(),
              const Toll(),
              const PageListCanceled()
            ],
          ),
        ));
  }
}

class Toll extends StatelessWidget {
  const Toll({super.key});

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    return Visibility(
      visible: prPrincipalRead.modelRequestActive!.requestData != null &&
          prPrincipalRead.modelRequestActive!.requestData!.toll! > 0,
      child: Container(
          margin: const EdgeInsets.only(top: 20, left: 30, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WidgetTextFieldTitle(
                  title: GlobalLabel.textTitleDetailToll,
                  align: TextAlign.left),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: GlobalColors.colorWhite,
                  border: Border.all(
                    width: 0.5,
                    color: GlobalColors.colorBorder,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: GlobalColors.colorBorder.withOpacity(.8),
                      blurRadius: 5.0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount:
                          prPrincipalRead.modelRequestActive!.requestData !=
                                  null
                              ? prPrincipalRead.modelRequestActive!.requestData!
                                  .pointsToll!.length
                              : 0,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            color: Colors.transparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: WidgetTextFieldSubTitle(
                                          title: prPrincipalRead
                                              .modelRequestActive!
                                              .requestData!
                                              .pointsToll![index]
                                              .name!,
                                          align: TextAlign.left),
                                    ),
                                    Expanded(
                                        flex: 0,
                                        child: WidgetTextFieldTitle(
                                            title:
                                                '${prPrincipalRead.modelRequestActive!.requestData!.pointsToll![index].price!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                                            align: TextAlign.right))
                                  ],
                                ),
                                index !=
                                        prPrincipalRead
                                                .modelRequestActive!
                                                .requestData!
                                                .pointsToll!
                                                .length -
                                            1
                                    ? const WidgetDivider()
                                    : Container()
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const WidgetDivider(),
                    Row(
                      children: [
                        const Expanded(
                            child: WidgetTextFieldSubTitle(
                                title: GlobalLabel.textCostTotal,
                                align: TextAlign.left)),
                        Expanded(
                            child: WidgetTextFieldTitle(
                                title:
                                    '${prPrincipalRead.modelRequestActive!.requestData != null ? prPrincipalRead.modelRequestActive!.requestData!.toll!.toStringAsFixed(2) : 0} ${prPrincipalRead.nameMoney}',
                                align: TextAlign.right))
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}

class TypePayment extends StatelessWidget {
  const TypePayment({super.key});

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
      child: WidgetContainer(
          color: GlobalColors.colorWhite,
          widget: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                      child: WidgetTextFieldSubTitle(
                          title: GlobalLabel.textNumberService,
                          align: TextAlign.left)),
                  Expanded(
                      flex: 0,
                      child: WidgetTextFieldTitle(
                          title: '${prPrincipalRead.getRequestId()}',
                          align: TextAlign.left))
                ],
              ),
              const WidgetDivider(),
              Row(
                children: [
                  const Expanded(
                    child: WidgetTextFieldSubTitle(
                        title: GlobalLabel.textTypePay, align: TextAlign.left),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    flex: 0,
                    child: WidgetTextFieldTitle(
                        title: prPrincipalRead
                            .nameTypePay(prPrincipalRead.modelRequestActive!),
                        align: TextAlign.left),
                  ),
                ],
              ),
              Visibility(
                  visible:
                      prPrincipalRead.modelRequestActive!.requestData != null &&
                          prPrincipalRead.modelRequestActive!.requestData!
                              .destination!.isNotEmpty,
                  child: Column(
                    children: [
                      const WidgetDivider(),
                      Row(
                        children: [
                          const Expanded(
                            child: WidgetTextFieldSubTitle(
                                title: GlobalLabel.textFeeService,
                                align: TextAlign.left),
                          ),
                          Expanded(
                            flex: 0,
                            child: WidgetTextFieldTitle(
                                title:
                                    '${prPrincipalRead.modelRequestActive!.requestData != null ? prPrincipalRead.modelRequestActive!.requestData!.destination!.isNotEmpty ? prPrincipalRead.modelRequestActive!.requestData!.destination![0].isBid == 0 ? (prPrincipalRead.modelRequestActive!.requestData!.destination![0].desC! - prPrincipalRead.modelRequestActive!.requestData!.toll!).toStringAsFixed(2) : (prPrincipalRead.modelRequestActive!.requestData!.destination![0].cost! - prPrincipalRead.modelRequestActive!.requestData!.toll!).toStringAsFixed(2) : '0.00' : '0.00'} ${prPrincipalRead.nameMoney}',
                                align: TextAlign.left),
                          ),
                        ],
                      ),
                    ],
                  )),
              Visibility(
                  visible: prPrincipalRead.modelRequestActive!.requestData !=
                          null &&
                      prPrincipalRead.modelRequestActive!.requestData!.toll! >
                          0,
                  child: Column(
                    children: [
                      const WidgetDivider(),
                      Row(
                        children: [
                          const Expanded(
                            child: WidgetTextFieldSubTitle(
                                title: GlobalLabel.textToll,
                                align: TextAlign.left),
                          ),
                          Expanded(
                            flex: 0,
                            child: WidgetTextFieldTitle(
                                title:
                                    '${prPrincipalRead.modelRequestActive!.requestData != null ? prPrincipalRead.modelRequestActive!.requestData!.toll : 0.00} ${prPrincipalRead.nameMoney}',
                                align: TextAlign.left),
                          ),
                        ],
                      ),
                    ],
                  )),
              Visibility(
                  visible: prPrincipalRead
                              .modelRequestActive!.requestData !=
                          null &&
                      prPrincipalRead
                              .modelRequestActive!.requestData!.paymentType !=
                          9 &&
                      prPrincipalRead.modelRequestActive!.requestData!.tip! > 0,
                  child: Column(
                    children: [
                      const WidgetDivider(),
                      Row(
                        children: [
                          const Expanded(
                            child: WidgetTextFieldSubTitle(
                                title: GlobalLabel.textCostTotal,
                                align: TextAlign.left),
                          ),
                          Expanded(
                            flex: 0,
                            child: WidgetTextFieldTitle(
                                title:
                                    '${prPrincipalRead.modelRequestActive!.requestData != null ? prPrincipalRead.modelRequestActive!.requestData!.paymentType != 9 ? prPrincipalRead.modelRequestActive!.requestData!.tip : '0.00' : '0.00'} ${prPrincipalRead.nameMoney}',
                                align: TextAlign.left),
                          ),
                        ],
                      ),
                    ],
                  )),
              Visibility(
                  visible: prPrincipalRead.modelRequestActive!.requestData !=
                          null &&
                      prPrincipalRead.modelRequestActive!.requestData!.toll! >
                          0,
                  child: Column(
                    children: [
                      const WidgetDivider(),
                      Row(
                        children: [
                          const Expanded(
                            child: WidgetTextFieldSubTitle(
                                title: GlobalLabel.textCostTotal,
                                align: TextAlign.left),
                          ),
                          Expanded(
                            flex: 0,
                            child: WidgetTextFieldTitle(
                                title:
                                    '${prPrincipalRead.modelRequestActive!.requestData != null ? prPrincipalRead.modelRequestActive!.requestData!.destination!.isNotEmpty ? prPrincipalRead.modelRequestActive!.requestData!.destination![0].isBid == 0 ? prPrincipalRead.modelRequestActive!.requestData!.destination![0].desC!.toStringAsFixed(2) : prPrincipalRead.modelRequestActive!.requestData!.destination![0].cost!.toStringAsFixed(2) : '0.00' : '0.00'} ${prPrincipalRead.nameMoney}',
                                align: TextAlign.left),
                          ),
                        ],
                      ),
                    ],
                  )),
            ],
          )),
    );
  }
}

class PageDetailUser extends StatelessWidget {
  const PageDetailUser({super.key});

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prChatRequestWatch = context.watch<ProviderChatRequest>();
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
      child: WidgetContainer(
        color: GlobalColors.colorWhite,
        widget: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                    flex: 0,
                    child: WidgetIcon(
                        icon: Icons.person_pin,
                        size: 40,
                        colors: GlobalColors.colorBackgroundBlue)),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WidgetTextFieldTitle(
                            title: prPrincipalRead
                                        .modelRequestActive!.requestType !=
                                    3
                                ? prPrincipalRead
                                            .modelRequestActive!.requestData !=
                                        null
                                    ? prPrincipalRead.modelRequestActive!
                                        .requestData!.user!.names!
                                    : GlobalLabel.textStranger
                                : GlobalLabel.textServiceStreet,
                            align: TextAlign.left),
                        Visibility(
                          visible:
                              prPrincipalRead.modelRequestActive!.requestType !=
                                  3,
                          child: Row(
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(bottom: 1),
                                  child: const WidgetIcon(
                                      icon: Icons.star,
                                      size: 15,
                                      colors: GlobalColors.colorIcon)),
                              const SizedBox(width: 5),
                              WidgetTextFieldTitle(
                                  title: prPrincipalRead.modelRequestActive!
                                              .requestData !=
                                          null
                                      ? prPrincipalRead.modelRequestActive!
                                          .requestData!.user!.rating!
                                          .toStringAsFixed(1)
                                      : '0',
                                  align: TextAlign.left),
                              const SizedBox(width: 5),
                              const WidgetIcon(
                                  icon: Icons.lens_rounded,
                                  size: 5,
                                  colors: GlobalColors.colorIcon),
                              const SizedBox(width: 5),
                              WidgetTextFieldTitle(
                                  title:
                                      '${prPrincipalRead.modelRequestActive!.requestData != null ? prPrincipalRead.modelRequestActive!.requestData!.user!.totalRequest : 5}',
                                  align: TextAlign.left),
                              const SizedBox(width: 5),
                              const WidgetTextFieldTitle(
                                  title: GlobalLabel.textTravel,
                                  align: TextAlign.left),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 0,
                    child: Visibility(
                      visible:
                          prPrincipalRead.modelRequestActive!.requestType != 3,
                      child: Container(
                        margin: const EdgeInsets.only(right: 10, left: 10),
                        child: GestureDetector(
                            onTap: () {
                              GlobalFunction().nextPageViewTransition(
                                  const PageChatRequest());
                              prChatRequestWatch.deleteBadgeChat();
                            },
                            child: badges.Badge(
                                showBadge: prChatRequestWatch.countChat > 0
                                    ? true
                                    : false,
                                badgeContent: Text(
                                  '${prChatRequestWatch.countChat}',
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: GlobalColors.colorWhite,
                                      fontWeight: FontWeight.bold),
                                ),
                                child: const CircleAvatar(
                                  radius: 18,
                                  backgroundColor: GlobalColors.colorBackground,
                                  child: WidgetIcon(
                                      icon: Icons.perm_phone_msg_rounded,
                                      size: 25,
                                      colors: GlobalColors.colorIcon),
                                ))),
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PageDetailService extends StatelessWidget {
  const PageDetailService({super.key});

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 30, right: 30),
      child: WidgetContainer(
        color: GlobalColors.colorWhite,
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WidgetTextFieldTitle(
                title: GlobalLabel.textOrigin, align: TextAlign.left),
            const SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                        flex: 0,
                        child: WidgetIcon(
                            icon: Icons.directions,
                            size: 25,
                            colors: GlobalColors.colorBlue)),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WidgetTextFieldTitle(
                            title: prPrincipalRead.neighborhoodOriginRequest(
                                prPrincipalRead.modelRequestActive!),
                            align: TextAlign.left),
                        WidgetTextFieldSubTitle(
                            title: prPrincipalRead.streetOriginRequest(
                                prPrincipalRead.modelRequestActive!),
                            align: TextAlign.left)
                      ],
                    ))
                  ],
                )
              ],
            ),
            SizedBox(
              height: prPrincipalRead.modelRequestActive!.requestData != null
                  ? prPrincipalRead.modelRequestActive!.requestType == 2 ||
                          prPrincipalRead.modelRequestActive!.requestData!
                              .destination!.isNotEmpty
                      ? 10
                      : 0
                  : 0,
            ),
            Visibility(
              visible: prPrincipalRead.modelRequestActive!.requestData != null
                  ? prPrincipalRead.modelRequestActive!.requestType == 2 ||
                          prPrincipalRead.modelRequestActive!.requestData!
                              .destination!.isNotEmpty
                      ? true
                      : false
                  : false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WidgetTextFieldTitle(
                      title: prPrincipalRead.modelRequestActive!.requestData !=
                              null
                          ? prPrincipalRead.modelRequestActive!.requestType! ==
                                      1 ||
                                  prPrincipalRead
                                          .modelRequestActive!.requestType! ==
                                      3
                              ? GlobalLabel.textDestiny
                              : GlobalLabel.textDeliver
                          : '',
                      align: TextAlign.left),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Expanded(
                          flex: 0,
                          child: WidgetIcon(
                              icon: Icons.directions,
                              size: 25,
                              colors: GlobalColors.colorGreen)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WidgetTextFieldTitle(
                                title:
                                    prPrincipalRead.neighborhoodDestinyRequest(
                                        prPrincipalRead.modelRequestActive!),
                                align: TextAlign.left),
                            WidgetTextFieldSubTitle(
                                title: prPrincipalRead.streetDestinyRequest(
                                    prPrincipalRead.modelRequestActive!),
                                align: TextAlign.left)
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Visibility(
              visible: prPrincipalRead.modelRequestActive!.requestData != null
                  ? prPrincipalRead.modelRequestActive!.requestData!.user!
                          .addresses!.isNotEmpty
                      ? prPrincipalRead.modelRequestActive!.requestData!.user!
                          .addresses![3].description!
                          .trim()
                          .isNotEmpty
                      : false
                  : false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const WidgetDivider(),
                  const WidgetTextFieldTitle(
                      title: GlobalLabel.textReference, align: TextAlign.left),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Expanded(
                          flex: 0,
                          child: WidgetIcon(
                              icon: Icons.home_rounded,
                              size: 25,
                              colors: GlobalColors.colorBlue)),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WidgetTextFieldSubTitle(
                              title: prPrincipalRead.referenceAddress(
                                  prPrincipalRead.modelRequestActive!),
                              align: TextAlign.left)
                        ],
                      ))
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageListCanceled extends StatelessWidget {
  const PageListCanceled({super.key});

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prServiceRestRead = context.read<ProviderServiceRest>();
    return Visibility(
      visible: prPrincipalRead.listEventuality!.isNotEmpty &&
          prPrincipalRead.modelRequestActive!.statusDriver != 5,
      child: Container(
          margin: const EdgeInsets.only(top: 30, left: 30, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: WidgetTextFieldTitle(
                    title: GlobalLabel.textMessageCancelled,
                    align: TextAlign.left),
              ),
              const MessageCanceled(),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: GlobalColors.colorWhite,
                  border: Border.all(width: .1, color: GlobalColors.colorWhite),
                  boxShadow: [
                    BoxShadow(
                      color: GlobalColors.colorBorder.withOpacity(.5),
                      blurRadius: 5.0,
                    ),
                  ],
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: prPrincipalRead.listEventuality!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        GlobalFunction().messageConfirmation(
                            '${GlobalLabel.textConfirmCancellation} \n\n'
                            '${prPrincipalRead.listEventuality![index].eventuality!}',
                            () {
                          prServiceRestRead.cancelRequestBeforePostulation(
                              context,
                              prPrincipalRead.modelRequestActive!,
                              7,
                              prPrincipalRead
                                  .listEventuality![index].eventualityId!);
                        });
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: WidgetTextFieldSubTitle(
                                      title: prPrincipalRead
                                          .listEventuality![index].eventuality!,
                                      align: TextAlign.left),
                                ),
                                const Expanded(
                                    flex: 0,
                                    child: WidgetIcon(
                                        icon: Icons.navigate_next_rounded,
                                        size: 25,
                                        colors: GlobalColors.colorIcon))
                              ],
                            ),
                            index != prPrincipalRead.listEventuality!.length - 1
                                ? const WidgetDivider()
                                : Container()
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          )),
    );
  }
}

class MessageCanceled extends StatelessWidget {
  const MessageCanceled({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(5),
      child: const Center(
        child: WidgetTextFieldSubTitle(
            title: GlobalLabel.textAlertCancelled, align: TextAlign.center),
      ),
    );
  }
}

class MapOrigenService extends StatefulWidget {
  const MapOrigenService({super.key});

  @override
  State<MapOrigenService> createState() => _MapOrigenService();
}

class _MapOrigenService extends State<MapOrigenService> {
  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prMapRead = context.read<ProviderMap>();
    return Container(
      height: 250,
      margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
      child: WidgetContainer(
        color: GlobalColors.colorWhite,
        widget: GoogleMap(
          onMapCreated: (controller) {
            prPrincipalRead.loadMapDetailRequest(controller);
          },
          minMaxZoomPreference: const MinMaxZoomPreference(16, 19),
          initialCameraPosition: CameraPosition(
            target: LatLng(
                prPrincipalRead.modelRequestActive!.requestData != null
                    ? prPrincipalRead.modelRequestActive!.requestData!.latitude!
                    : 0.00,
                prPrincipalRead.modelRequestActive!.requestData != null
                    ? prPrincipalRead
                        .modelRequestActive!.requestData!.longitude!
                    : 0.00),
            zoom: 18,
            tilt: 0,
          ),
          buildingsEnabled: false,
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          markers: {
            prPrincipalRead
                    .markers![const MarkerId(GlobalLabel.textMarkerVehicle)] =
                Marker(
                    anchor: const Offset(0.5, 0.5),
                    markerId: const MarkerId(GlobalLabel.textMarkerVehicle),
                    position: LatLng(prMapRead.positionLatitude,
                        prMapRead.positionLongitude),
                    icon: prPrincipalRead.iconDetailVehicle!),
            prPrincipalRead
                    .markers![const MarkerId(GlobalLabel.textOriginMarker)] =
                Marker(
                    anchor: const Offset(0.5, 0.5),
                    markerId: const MarkerId(GlobalLabel.textOriginMarker),
                    position: LatLng(
                        prPrincipalRead.modelRequestActive!.requestData != null
                            ? prPrincipalRead
                                .modelRequestActive!.requestData!.latitude!
                            : 0.00,
                        prPrincipalRead.modelRequestActive!.requestData != null
                            ? prPrincipalRead
                                .modelRequestActive!.requestData!.longitude!
                            : 0.00),
                    icon: prPrincipalRead.iconDetailOrigin!)
          },
          compassEnabled: false,
          rotateGesturesEnabled: false,
          zoomControlsEnabled: false,
          onCameraMove: prPrincipalRead.onCameraMove,
        ),
      ),
    );
  }
}
