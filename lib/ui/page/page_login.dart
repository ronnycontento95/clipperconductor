import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_login.dart';
import '../provider/provider_splash.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_button.dart';
import '../util/global_widgets/widget_container.dart';
import '../util/global_widgets/widget_icon.dart';
import '../util/global_widgets/widget_image_background.dart';
import '../util/global_widgets/widget_text_field_edit.dart';
import '../util/global_widgets/widget_text_field_edit_password.dart';
import '../util/global_widgets/widget_text_field_personalized.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';
import 'page_pre_register.dart';
import 'page_retrieve_password.dart';

class PageLogin extends StatefulWidget {
  const PageLogin({super.key});

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  @override
  void initState() {
    super.initState();
    context.read<ProviderSplash>().informationDispositive();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: GlobalFunction().colorBarView(),
        child: const Scaffold(
            backgroundColor: GlobalColors.colorWhite,
            body: SafeArea(
                child: Stack(
              children: [
                WidgetImageBackground(name: 'imageBackground.png'),
                Center(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TitleWelcome(),
                      Animation(),
                      FormPage(),
                      MenuOption()
                    ],
                  ),
                ))
              ],
            ))));
  }
}

class TitleWelcome extends StatelessWidget {
  const TitleWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            WidgetTextFieldPersonalized(
              type: 1,
              title: GlobalLabel.textTitleWelcome,
              align: TextAlign.center,
              size: 40,
              color: GlobalColors.colorLetterTitle,
            ),
            WidgetTextFieldSubTitle(
                title: GlobalLabel.textDescriptionWelcome,
                align: TextAlign.center)
          ],
        ));
  }
}

class Animation extends StatelessWidget {
  const Animation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 210,
        margin: const EdgeInsets.only(bottom: 20, left: 22, right: 20),
        child: Image.asset(
            '${GlobalLabel.directionImageInternal}imagelogin.png',
            width: double.infinity));
  }
}

class FormPage extends StatelessWidget {
  const FormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final providerLoginRead = context.read<ProviderLogin>();
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30),
      child: WidgetContainer(
          color: GlobalColors.colorWhite,
          widget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Column(
                  children: [
                    WidgetTextFieldEdit(
                        identifier: providerLoginRead.editUser,
                        limitCharacter: 45,
                        typeKeyBoard: TextInputType.text,
                        icon: Icons.person_2_rounded,
                        hintText: GlobalLabel.textUser),
                    Row(
                      children: [
                        Expanded(
                            child: WidgetTextFieldEditPassword(
                                identifier: providerLoginRead.editPassword,
                                limitCharacter: 45,
                                typeKeyBoard: TextInputType.text,
                                icon: Icons.key,
                                hintText: GlobalLabel.textPassword)),
                      ],
                    ),
                  ],
                ),
              ),
              const SendButtonLogin(),
              const SizedBox(height: 20),
            ],
          )),
    );
  }
}

class SendButtonLogin extends StatelessWidget {
  const SendButtonLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prLoginRead = context.read<ProviderLogin>();

    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: WidgetButton(
          text: GlobalLabel.buttonInitialSession,
          type: 1,
          onPressed: () {
            prLoginRead.initLogIn(context);
          }),
    );
  }
}

class MenuOption extends StatelessWidget {
  const MenuOption({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 1,
            child: GestureDetector(
                onTap: () {
                  GlobalFunction()
                      .nextPageViewTransition(const PageRetrievePassword());
                },
                child: const WidgetContainer(
                  color: GlobalColors.colorBackground,
                  widget: Column(
                    children: [
                      WidgetIcon(
                          icon: Icons.key_outlined,
                          size: 30,
                          colors: GlobalColors.colorLetterTitle),
                      WidgetTextFieldSubTitle(
                          title: GlobalLabel.textForgetPassword,
                          align: TextAlign.center)
                    ],
                  ),
                )),
          ),
          Flexible(
            flex: 1,
            child: Visibility(
              visible: false,
              child: GestureDetector(
                onTap: () {
                  // _providerLogIn!.authenticate(
                  //     widget.serviceSocket,
                  //     widget.providerPrincipal,
                  //     widget.providerTaximeter,
                  //     widget.providerConfigurationApp,
                  //     widget.providerPayment,
                  //     widget.providerChatRequest,
                  //     _providerLogIn!,
                  //     widget.providerRegisterDispositive,
                  //     widget.providerProfile,
                  //     widget.providerCanceledUser,
                  //     widget.providerWalKieTalkie);
                },
                child: Card(
                  elevation: .5,
                  shadowColor: GlobalColors.colorBorder,
                  color: GlobalColors.colorWhite,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        color: GlobalColors.colorBorder, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: 100,
                    child: const Column(
                      children: [
                        WidgetIcon(
                            icon: Icons.face,
                            size: 30,
                            colors: GlobalColors.colorLetterTitle),
                        WidgetTextFieldSubTitle(
                            title: GlobalLabel.textBiometric,
                            align: TextAlign.center)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          Flexible(
            flex: 1,
            child: GestureDetector(
                onTap: () {
                  GlobalFunction()
                      .nextPageViewTransition(const PagePreRegister());
                },
                child: const WidgetContainer(
                  color: GlobalColors.colorBackground,
                  widget: Column(
                    children: [
                      WidgetIcon(
                          icon: Icons.app_registration,
                          size: 30,
                          colors: GlobalColors.colorLetterTitle),
                      WidgetTextFieldSubTitle(
                          title: GlobalLabel.textRegisterNow,
                          align: TextAlign.center)
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }
}
