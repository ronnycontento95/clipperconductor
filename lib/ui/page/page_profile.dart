import 'package:flutter/material.dart';
import 'dart:io';

import 'package:provider/provider.dart';

import '../provider/provider_login.dart';
import '../provider/provider_principal.dart';
import '../provider/provider_service/provider_service_rest.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_preference.dart';
import '../util/global_widgets/widget_divider.dart';
import '../util/global_widgets/widget_icon.dart';
import '../util/global_widgets/widget_image_network.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';
import '../util/global_widgets/widget_text_field_title.dart';
import 'page_about.dart';
import 'page_configuration_profile.dart';
import 'page_history_request.dart';
import 'page_referred.dart';
import 'page_service_active.dart';
import 'page_term_condition.dart';
import 'page_verify_identity.dart';

class PageProfile extends StatefulWidget {
  const PageProfile({Key? key}) : super(key: key);

  @override
  State<PageProfile> createState() => _PageProfileState();
}

class _PageProfileState extends State<PageProfile> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: GlobalFunction().colorBarView(),
      child: Scaffold(
        backgroundColor: GlobalColors.colorWhite,
        body: SafeArea(
            child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: const SingleChildScrollView(
            child: Column(
              children: [
                InfoUser(),
                Profile(),
                Balance(),
                // Statistics(),
                Information(),
                LogOut(),
              ],
            ),
          ),
        )),
      ),
    );
  }
}

class LogOut extends StatelessWidget {
  const LogOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prServiceRestRead = context.read<ProviderServiceRest>();
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prLoginInRead = context.read<ProviderLogin>();
    return Column(
      children: [
        const WidgetDivider(),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  if (prPrincipalRead.modelRequestActive!.requestData != null) {
                    GlobalFunction()
                        .speakMessage(GlobalLabel.textRequestNowActive);
                    GlobalFunction().messageAlert(
                        context, GlobalLabel.textRequestNowActive);
                    GlobalFunction().closeView();
                  } else {
                    GlobalFunction().messageConfirmation(
                        GlobalLabel.textMessageOut, () async {
                      if (prLoginInRead.googleSignIn == null) {
                        prLoginInRead.googleSignIn!.isSignedIn().then((value) {
                          if (value) {
                            prLoginInRead.googleSignIn!.disconnect();
                          }
                        });
                      }
                      GlobalPreference().setStateService(false);
                      prPrincipalRead.stateService = false;
                      exit(0);
                    });
                  }
                },
                child: Container(
                    margin:
                        const EdgeInsets.only(top: 10, left: 20, bottom: 10),
                    color: Colors.transparent,
                    child: const WidgetTextFieldTitle(
                        title: GlobalLabel.textExitApp, align: TextAlign.left)),
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  prServiceRestRead.logOut(context);
                },
                child: Container(
                    margin:
                        const EdgeInsets.only(top: 10, right: 25, bottom: 10),
                    color: Colors.transparent,
                    child: const WidgetTextFieldTitle(
                        title: GlobalLabel.textLogOut, align: TextAlign.right)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class Information extends StatelessWidget {
  const Information({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    return GestureDetector(
      onTap: () {
        GlobalFunction().nextPageViewTransition(const PageAbout());
      },
      child: Column(
        children: [
          Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                color: GlobalColors.colorBackgroundGrey.withOpacity(.1),
                border: Border.all(
                    width: .1, color: GlobalColors.colorBackgroundGrey),
                boxShadow: [
                  BoxShadow(
                    color: GlobalColors.colorBackgroundGrey.withOpacity(.3),
                    blurRadius: .1,
                  ),
                ],
              ),
              width: double.infinity,
              margin: const EdgeInsets.only(top: 20, left: 10, right: 25),
              height: 40,
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: const WidgetTextFieldTitle(
                  title: GlobalLabel.textInformation, align: TextAlign.left)),
          Container(
            margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
            color: Colors.transparent,
            child: const Row(
              children: [
                Expanded(
                    flex: 1,
                    child: WidgetTextFieldSubTitle(
                        title: GlobalLabel.textAbout, align: TextAlign.left)),
                Expanded(
                    flex: 0,
                    child: WidgetIcon(
                        icon: Icons.navigate_next_rounded,
                        size: 25,
                        colors: GlobalColors.colorLetterTitle))
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              GlobalFunction().openGooglePlay();
            },
            child: Container(
              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
              color: Colors.transparent,
              child: const Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: WidgetTextFieldSubTitle(
                          title: GlobalLabel.textEvaluate,
                          align: TextAlign.left)),
                  Expanded(
                      flex: 0,
                      child: WidgetIcon(
                          icon: Icons.navigate_next_rounded,
                          size: 25,
                          colors: GlobalColors.colorLetterTitle))
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              GlobalFunction()
                  .nextPageViewTransition(const PageTermCondition());
            },
            child: Container(
              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
              color: Colors.transparent,
              child: const Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: WidgetTextFieldSubTitle(
                          title: GlobalLabel.textCondition,
                          align: TextAlign.left)),
                  Expanded(
                      flex: 0,
                      child: WidgetIcon(
                          icon: Icons.navigate_next_rounded,
                          size: 25,
                          colors: GlobalColors.colorLetterTitle))
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, left: 20, right: 25),
            color: Colors.transparent,
            child: Row(
              children: [
                const Expanded(
                    flex: 1,
                    child: WidgetTextFieldSubTitle(
                        title: GlobalLabel.textVersion, align: TextAlign.left)),
                Expanded(
                    flex: 0,
                    child: WidgetTextFieldSubTitle(
                        title: prPrincipalRead.modelDispositive.version!,
                        align: TextAlign.right))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Statistics extends StatelessWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          color: GlobalColors.colorWhite,
          width: double.infinity,
          margin: const EdgeInsets.only(top: 20),
          height: 40,
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: const WidgetTextFieldTitle(
              title: GlobalLabel.textStatistics, align: TextAlign.left),
        ),
        GestureDetector(
          onTap: () {
            // _providerHistoryRequest!.typeConsult = 0;
            // GlobalWidget().nextPageViewTransition(PageHistoryRequest(
            //     providerPrincipal: widget.providerPrincipal));
            GlobalFunction().nextPageViewTransition(const PageHistoryDay());
          },
          child: Container(
            margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
            color: Colors.transparent,
            child: const Row(
              children: [
                Expanded(
                    flex: 1,
                    child: WidgetTextFieldSubTitle(
                        title: GlobalLabel.textHistoryService,
                        align: TextAlign.left)),
                Expanded(
                    flex: 0,
                    child: WidgetIcon(
                        icon: Icons.navigate_next_rounded,
                        size: 25,
                        colors: GlobalColors.colorLetterTitle))
              ],
            ),
          ),
        ),
        // GlobalWidget().divider(),
        // Container(
        //   margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
        //   color: Colors.transparent,
        //   child: Row(
        //     children: [
        //       Expanded(
        //         flex: 1,
        //         child: GlobalWidget().styleTextSubTitle(
        //             GlobalLabel.textTimeConnection,
        //             GlobalColor.colorLetterSubTitle,
        //             0.0,
        //             TextAlign.left),
        //       ),
        //       const Expanded(flex: 0, child: Icon(Icons.navigate_next_rounded))
        //     ],
        //   ),
        // ),
      ],
    );
  }
}

class InfoUser extends StatelessWidget {
  const InfoUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prServiceRestRead = context.read<ProviderServiceRest>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      color: GlobalColors.colorWhite,
      child: Center(
        child: SizedBox(
          width: double.infinity,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    prServiceRestRead.consultTotalRating(context);
                  },
                  child: SizedBox(
                      height: 60,
                      width: 60,
                      child: WidgetImageNetwork(
                          url:
                              '${GlobalLabel.urlImage}${prPrincipalRead.modelUser.imageDriver}',
                          radio: 80,
                          size: 80)),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const WidgetIcon(
                            icon: Icons.star,
                            size: 15,
                            colors: GlobalColors.colorBackgroundView),
                        Container(
                            margin: const EdgeInsets.only(left: 3),
                            child: WidgetTextFieldTitle(
                                title: prPrincipalRead.qualificationDriver
                                    .toStringAsFixed(1),
                                align: TextAlign.left)),
                      ],
                    ),
                  ),
                ),
                WidgetTextFieldTitle(
                    title:
                        '${prPrincipalRead.modelUser.name} ${prPrincipalRead.modelUser.lastName}',
                    align: TextAlign.center),
                const SizedBox(
                  height: 5,
                ),
                WidgetTextFieldSubTitle(
                    title: '${prPrincipalRead.modelUser.city}',
                    align: TextAlign.center),
                const SizedBox(
                  height: 5,
                ),
                WidgetTextFieldSubTitle(
                    title:
                        '${prPrincipalRead.modelUser.vehiclePlate} - ${GlobalLabel.textUnited} ${prPrincipalRead.modelUser.unitVehicle}',
                    align: TextAlign.center),
                const SizedBox(
                  height: 10,
                ),
                Container(
                    margin: const EdgeInsets.only(right: 15),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      color: GlobalColors.colorBackgroundGrey.withOpacity(.1),
                      border: Border.all(
                          width: .1, color: GlobalColors.colorBackgroundGrey),
                      boxShadow: [
                        BoxShadow(
                          color:
                              GlobalColors.colorBackgroundGrey.withOpacity(.3),
                          blurRadius: .1,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              const Icon(Icons.timer_outlined),
                              const SizedBox(
                                height: 5,
                              ),
                              WidgetTextFieldTitle(
                                  title: prPrincipalRead.timeConnection,
                                  align: TextAlign.left),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              const Icon(Icons.speed),
                              const SizedBox(
                                height: 5,
                              ),
                              WidgetTextFieldTitle(
                                  title:
                                      '${GlobalFunction().formatDistance(prPrincipalRead.distanceConnection)} ${prPrincipalRead.distanceConnection > 1000 ? 'Km' : 'm'}',
                                  align: TextAlign.left),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              // GlobalWidget().nextPageViewTransition(
                              //     PageStatisticsGain(
                              //         providerPrincipal:
                              //             widget.providerPrincipal));
                            },
                            child: Column(
                              children: [
                                const Icon(Icons.local_taxi_outlined),
                                const SizedBox(
                                  height: 5,
                                ),
                                WidgetTextFieldTitle(
                                    title: '${prPrincipalRead.numberRequest}',
                                    align: TextAlign.left),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              color: GlobalColors.colorBackgroundGrey.withOpacity(.1),
              border: Border.all(
                  width: .1, color: GlobalColors.colorBackgroundGrey),
              boxShadow: [
                BoxShadow(
                  color: GlobalColors.colorBackgroundGrey.withOpacity(.3),
                  blurRadius: .1,
                ),
              ],
            ),
            width: double.infinity,
            margin: const EdgeInsets.only(top: 20, left: 10, right: 25),
            height: 40,
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: const WidgetTextFieldTitle(
                title: GlobalLabel.textProfile, align: TextAlign.left)),
        GestureDetector(
          onTap: () {
            GlobalFunction().closeView();
            GlobalFunction()
                .nextPageViewTransition(const PageConfigurationProfile());
          },
          child: Container(
            margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
            color: Colors.transparent,
            child: const Row(
              children: [
                Expanded(
                  flex: 1,
                  child: WidgetTextFieldSubTitle(
                      title: GlobalLabel.textConfigurationProfile,
                      align: TextAlign.left),
                ),
                Expanded(
                    flex: 0,
                    child: WidgetIcon(
                        icon: Icons.navigate_next_rounded,
                        size: 25,
                        colors: GlobalColors.colorLetterTitle))
              ],
            ),
          ),
        ),
        // GlobalWidget().divider(),
        // GestureDetector(
        //   onTap: () {
        //     GlobalFunction().nextPageViewTransition(const PageNotifications());
        //   },
        //   child: Container(
        //     margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
        //     color: Colors.transparent,
        //     child: const Row(
        //       children: [
        //         Expanded(
        //             flex: 1,
        //             child: WidgetTextFieldSubTitle(
        //                 title: GlobalLabel.textNotification,
        //                 align: TextAlign.left)),
        //         Expanded(
        //             flex: 0,
        //             child: WidgetIcon(
        //                 icon: Icons.navigate_next_rounded,
        //                 size: 25,
        //                 colors: GlobalColors.colorIconNext))
        //       ],
        //     ),
        //   ),
        // ),
        // GlobalWidget().divider(),
        Visibility(
          visible: prPrincipalRead.stateCodeReferred,
          child: GestureDetector(
            onTap: () {
              GlobalFunction().closeView();
              GlobalFunction().nextPageViewTransition(const PageReferred());
            },
            child: Container(
              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
              color: Colors.transparent,
              child: const Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: WidgetTextFieldSubTitle(
                          title: GlobalLabel.textReferred,
                          align: TextAlign.left)),
                  Expanded(
                      flex: 0,
                      child: WidgetIcon(
                          icon: Icons.navigate_next_rounded,
                          size: 25,
                          colors: GlobalColors.colorLetterTitle))
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: prPrincipalRead.stateVerifyIdentity,
          child: GestureDetector(
            onTap: () {
              GlobalFunction().closeView();
              GlobalFunction()
                  .nextPageViewTransition(const PageVerifyIdentity());
            },
            child: Container(
              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
              color: Colors.transparent,
              child: const Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: WidgetTextFieldSubTitle(
                          title: GlobalLabel.textVerifyIdentity,
                          align: TextAlign.left)),
                  Expanded(
                      flex: 0,
                      child: WidgetIcon(
                          icon: Icons.navigate_next_rounded,
                          size: 25,
                          colors: GlobalColors.colorLetterTitle))
                ],
              ),
            ),
          ),
        ),
        // GlobalWidget().divider(),
        // Container(
        //   margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
        //   color: Colors.transparent,
        //   child: Row(
        //     children: [
        //       Expanded(
        //         flex: 1,
        //         child: GlobalWidget().styleTextSubTitle(GlobalLabel.textChanger,
        //             GlobalColor.colorLetterSubTitle, 0.0, TextAlign.left),
        //       ),
        //       const Expanded(flex: 0, child: Icon(Icons.navigate_next_rounded))
        //     ],
        //   ),
        // ),
        GestureDetector(
          onTap: () {
            GlobalFunction().closeView();
            GlobalFunction().nextPageViewTransition(const PageServiceActive());
          },
          child: Container(
            margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
            color: Colors.transparent,
            child: const Row(
              children: [
                Expanded(
                    flex: 1,
                    child: WidgetTextFieldSubTitle(
                        title: GlobalLabel.textTitleServiceActive,
                        align: TextAlign.left)),
                Expanded(
                    flex: 0,
                    child: WidgetIcon(
                        icon: Icons.navigate_next_rounded,
                        size: 25,
                        colors: GlobalColors.colorLetterTitle))
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Balance extends StatelessWidget {
  const Balance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prServiceRestRead = context.read<ProviderServiceRest>();
    return GestureDetector(
      onTap: () {
        prServiceRestRead.consultNumberHistoryRequestGain(context);
      },
      child: Column(
        children: [
          Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                color: GlobalColors.colorBackgroundGrey.withOpacity(.1),
                border: Border.all(
                    width: .1, color: GlobalColors.colorBackgroundGrey),
                boxShadow: [
                  BoxShadow(
                    color: GlobalColors.colorBackgroundGrey.withOpacity(.3),
                    blurRadius: .1,
                  ),
                ],
              ),
              width: double.infinity,
              margin: const EdgeInsets.only(top: 20, left: 10, right: 25),
              height: 40,
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: const WidgetTextFieldTitle(
                  title: GlobalLabel.textAccounting, align: TextAlign.left)),
          Container(
            margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
            color: Colors.transparent,
            child: const Row(
              children: [
                Expanded(
                  flex: 1,
                  child: WidgetTextFieldSubTitle(
                      title: GlobalLabel.textGainGenerate,
                      align: TextAlign.left),
                ),
                Expanded(
                    flex: 0,
                    child: WidgetIcon(
                        icon: Icons.navigate_next_rounded,
                        size: 25,
                        colors: GlobalColors.colorLetterTitle))
              ],
            ),
          ),
          // GestureDetector(
          //   onTap: () {
          //     GlobalFunction().nextPageViewTransition(const PageBuyPackage());
          //   },
          //   child: Container(
          //     margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
          //     color: Colors.transparent,
          //     child: const Row(
          //       children: [
          //         Expanded(
          //           flex: 1,
          //           child: WidgetTextFieldSubTitle(
          //               title: GlobalLabel.textRecharger,
          //               align: TextAlign.left),
          //         ),
          //         Expanded(
          //             flex: 0,
          //             child: WidgetIcon(
          //                 icon: Icons.navigate_next_rounded,
          //                 size: 25,
          //                 colors: GlobalColors.colorLetterTitle))
          //       ],
          //     ),
          //   ),
          // ),
          // GestureDetector(
          //   onTap: () {
          //     GlobalFunction().nextPageViewTransition(const PageBalance());
          //   },
          //   child: Container(
          //     margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
          //     color: Colors.transparent,
          //     child: const Row(
          //       children: [
          //         Expanded(
          //           flex: 1,
          //           child: WidgetTextFieldSubTitle(
          //               title: GlobalLabel.textMont, align: TextAlign.left),
          //         ),
          //         Expanded(
          //             flex: 0,
          //             child: WidgetIcon(
          //                 icon: Icons.navigate_next_rounded,
          //                 size: 25,
          //                 colors: GlobalColors.colorIcon))
          //       ],
          //     ),
          //   ),
          // ),
          // GestureDetector(
          //   onTap: () {
          //     GlobalFunction().nextPageViewTransition(const PageTransaction());
          //   },
          //   child: Container(
          //     margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
          //     color: Colors.transparent,
          //     child: const Row(
          //       children: [
          //         Expanded(
          //             flex: 1,
          //             child: WidgetTextFieldSubTitle(
          //                 title: GlobalLabel.textTransaction,
          //                 align: TextAlign.left)),
          //         Expanded(
          //             flex: 0,
          //             child: WidgetIcon(
          //                 icon: Icons.navigate_next_rounded,
          //                 size: 25,
          //                 colors: GlobalColors.colorIcon))
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
