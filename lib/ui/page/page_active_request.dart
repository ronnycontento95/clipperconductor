
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_chat_request.dart';
import '../provider/provider_map.dart';
import '../provider/provider_principal.dart';
import '../provider/provider_service/provider_service_socket.dart';
import '../provider/provider_taximeter.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_button.dart';
import '../util/global_widgets/widget_divider.dart';
import '../util/global_widgets/widget_icon.dart';
import '../util/global_widgets/widget_text_field_personalized.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';
import 'page_chat_request.dart';
import 'page_detail_request.dart';
import 'package:badges/badges.dart' as badges;

import 'page_taximeter_request.dart';

class PageActiveRequest extends StatefulWidget {
  const PageActiveRequest({super.key});

  @override
  State<PageActiveRequest> createState() => _PageActiveRequestState();
}

class _PageActiveRequestState extends State<PageActiveRequest> {
  @override
  Widget build(BuildContext context) {
    final prPrincipalWatch = context.watch<ProviderPrincipal>();
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prTaximeterRead = context.read<ProviderTaximeter>();
    final prMapWatch = context.watch<ProviderMap>();
    final prServiceSocketRead = context.read<ProviderServiceSocket>();

    return Visibility(
      visible: prMapWatch.positionLatitude != 0.0 &&
          prMapWatch.positionLongitude != 0.0 &&
          prPrincipalWatch.modelRequestActive!.requestData != null &&
          prPrincipalWatch.stateInternet,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: GlobalColors.colorBackgroundBlue.withOpacity(.4),
                blurRadius: 10.0,
              ),
            ],
            color: GlobalColors.colorWhite,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            border: Border.all(
              width: 2,
              color: GlobalColors.colorWhite,
            ),
          ),
          alignment: Alignment.bottomCenter,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 0,
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      Visibility(
                        visible:
                            prPrincipalWatch.modelRequestActive!.statusDriver ==
                                5,
                        child: Expanded(
                          flex: 0,
                          child: GestureDetector(
                            onTap: () {
                              GlobalFunction().configurationTaximeter(context);
                            },
                            child: const WidgetIcon(
                                icon: Icons.expand_less_rounded,
                                size: 25,
                                colors: GlobalColors.colorIcon),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          child: WidgetTextFieldSubTitle(
                              title: prPrincipalWatch.messageStateRequest,
                              align: TextAlign.center),
                        ),
                      ),
                      Visibility(
                        visible:
                            prPrincipalWatch.modelRequestActive!.statusDriver ==
                                5,
                        child: Expanded(
                          flex: 0,
                          child: GestureDetector(
                            onTap: () {
                              GlobalFunction().nextPageViewTransition(
                                  const PageDetailRequest());
                            },
                            child: const WidgetIcon(
                                icon: Icons.person,
                                size: 25,
                                colors: GlobalColors.colorIcon),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const WidgetDivider(),
              Expanded(
                flex: 0,
                child: prPrincipalWatch.modelRequestActive!.requestData != null
                    ? prPrincipalWatch.modelRequestActive!.statusDriver == 3
                        ? const InformationUser()
                        : prPrincipalWatch.modelRequestActive!.statusDriver == 5
                            ? const PageTaximeterRequest()
                            : Container()
                    : prPrincipalWatch.stateTaximeterStreet
                        ? const PageTaximeterRequest()
                        : Container(),
              ),
              Expanded(
                flex: 0,
                child: Container(
                  height: 60,
                  margin: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
                  child: WidgetButton(
                      text: prPrincipalWatch.labelNameButtonRequest,
                      type: 1,
                      onPressed: () {
                        if (!prTaximeterRead.connectedTaximeterExternal) {
                          prServiceSocketRead.actionButtonRequest(context);
                        } else {
                          if(prPrincipalRead.modelRequestActive!.requestData != null){
                            if(prPrincipalRead.modelRequestActive!.statusDriver == 3){
                              GlobalFunction().speakMessage(
                                  GlobalLabel.textMessageInitialTaximeter);
                              GlobalFunction().messageConfirmation(
                                  GlobalLabel.textQuestionInitialTaximeter, () {
                              });
                            }else {
                              if(!prTaximeterRead.statusRunTaximeter){
                                prServiceSocketRead.actionButtonRequest(context);
                              }
                            }
                          }
                        }
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class InformationUser extends StatelessWidget {
  const InformationUser({super.key});

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prChatRequestWatch = context.watch<ProviderChatRequest>();
    return GestureDetector(
      onTap: () {
        GlobalFunction().nextPageViewTransition(const PageDetailRequest());
      },
      child: Container(
        height: 72,
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: Row(
          children: [
            const Expanded(
              flex: 0,
              child: WidgetIcon(
                  icon: Icons.person_pin,
                  size: 40,
                  colors: GlobalColors.colorBackgroundBlue),
            ),
            const SizedBox(width: 10),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WidgetTextFieldPersonalized(
                    size: 18,
                    type: 1,
                    color: GlobalColors.colorLetterTitle,
                    title: prPrincipalRead.modelRequestActive!.requestType != 3
                        ? prPrincipalRead
                            .modelRequestActive!.requestData!.user!.names!
                        : prPrincipalRead.modelRequestActive!.requestData !=
                                null
                            ? prPrincipalRead
                                .modelRequestActive!.requestData!.user!.names!
                            : GlobalLabel.textServiceStreet,
                    align: TextAlign.left),
                WidgetTextFieldSubTitle(
                    title:
                        '${prPrincipalRead.distanceTravelClient(prPrincipalRead.modelRequestActive!.requestData!)} · ${prPrincipalRead.modelRequestActive!.requestData!.times!} min.',
                    align: TextAlign.left)
              ],
            )),
            const SizedBox(width: 10),
            Expanded(
              flex: 0,
              child: Visibility(
                visible: prPrincipalRead.modelRequestActive!.requestType != 3,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (prPrincipalRead.modelRequestActive!.requestData !=
                            null) {
                          GlobalFunction().dialCall(prPrincipalRead
                              .modelRequestActive!.requestData!.user!.phone!);
                        }
                      },
                      child: const CircleAvatar(
                        radius: 18,
                        backgroundColor: GlobalColors.colorBackground,
                        child: WidgetIcon(
                            icon: Icons.phone,
                            size: 25,
                            colors: GlobalColors.colorIcon),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        GlobalFunction()
                            .nextPageViewTransition(const PageChatRequest());
                        prChatRequestWatch.deleteBadgeChat();
                      },
                      child: badges.Badge(
                        showBadge:
                            prChatRequestWatch.countChat > 0 ? true : false,
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
                              icon: Icons.wechat_rounded,
                              size: 25,
                              colors: GlobalColors.colorIcon),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
