import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_pre_register.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_container.dart';
import '../util/global_widgets/widget_message_page.dart';
import '../util/global_widgets/widget_scaffold.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';
import '../util/global_widgets/widget_text_field_title.dart';

class PagePreRegister extends StatelessWidget {
  const PagePreRegister({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidgetScaffold(
      onPressed: () {
        Navigator.pop(context);
      },
      widget: const Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                WidgetMessagePage(
                  title: GlobalLabel.textTitleRegister,
                  message: GlobalLabel.textDescriptionRegister,
                ),
                OptionRegister()
              ],
            ),
          ),
          TermCondition(),
          LogIn(),
        ],
      ),
    );
  }
}

class LogIn extends StatelessWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: () {
          GlobalFunction().closeView();
        },
        child: Container(
          height: 100,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const WidgetTextFieldSubTitle(
                  title: GlobalLabel.textHaveAccount, align: TextAlign.left),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: const WidgetTextFieldTitle(
                    title: GlobalLabel.textLogIn, align: TextAlign.left),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TermCondition extends StatelessWidget {
  const TermCondition({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 200,
          margin: const EdgeInsets.only(left: 30, right: 30),
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 30),
          child: Align(
            alignment: Alignment.center,
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text: GlobalLabel.textSingUp,
                style: TextStyle(
                    fontFamily: GlobalLabel.typeLetterSubTitle,
                    fontSize: 12,
                    color: GlobalColors.colorLetterSubTitle),
                children: <TextSpan>[
                  TextSpan(
                      text: GlobalLabel.textTermService,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: GlobalColors.colorBlack)),
                  TextSpan(text: GlobalLabel.textConfirmWatch),
                  TextSpan(
                      text: GlobalLabel.textPoliticPrivacy,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: GlobalColors.colorBlack)),
                  TextSpan(text: GlobalLabel.textCollectionInformation),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OptionRegister extends StatelessWidget {
  const OptionRegister({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prPreRegisterRead = context.read<ProviderPreRegister>();
    return Container(
      margin: const EdgeInsets.only(top: 40, right: 30, left: 30),
      child: Column(
        children: [
          Visibility(
            visible: false,
            child: GestureDetector(
              onTap: () {
                prPreRegisterRead.loginFacebook();
              },
              child: WidgetContainer(
                color: GlobalColors.colorWhite,
                widget: Row(
                  children: [
                    Image.asset(
                      '${GlobalLabel.directionImageInternal}facebook.png',
                      height: 25,
                      fit: BoxFit.cover,
                      cacheHeight: 65,
                      cacheWidth: 65,
                    ),
                    Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: const WidgetTextFieldTitle(
                            title: GlobalLabel.buttonContinueFacebook,
                            align: TextAlign.left),),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              prPreRegisterRead.loginGoogle(context);
            },
            child: WidgetContainer(
              color: GlobalColors.colorWhite,
              widget: Row(
                children: [
                  Image.asset(
                    '${GlobalLabel.directionImageInternal}google.png',
                    height: 25,
                    fit: BoxFit.cover,
                    cacheHeight: 65,
                    cacheWidth: 65,
                  ),
                  Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: const WidgetTextFieldTitle(
                          title: GlobalLabel.buttonContinueGoogle,
                          align: TextAlign.left))
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          if (Platform.isIOS) ...[
            GestureDetector(
              onTap: () {
                prPreRegisterRead.loginApple();
              },
              child: WidgetContainer(
                color: GlobalColors.colorWhite,
                widget: Row(
                  children: [
                    Image.asset(
                      '${GlobalLabel.directionImageInternal}apple.png',
                      height: 25,
                      fit: BoxFit.cover,
                      cacheHeight: 65,
                      cacheWidth: 65,
                    ),
                    Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: const WidgetTextFieldTitle(
                            title: GlobalLabel.buttonContinueApple,
                            align: TextAlign.left))
                  ],
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
