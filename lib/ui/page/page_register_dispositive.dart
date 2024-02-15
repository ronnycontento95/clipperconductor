import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../provider/provider_register_dispositive.dart';
import '../provider/provider_service/provider_service_rest.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_button.dart';
import '../util/global_widgets/widget_container.dart';
import '../util/global_widgets/widget_icon.dart';
import '../util/global_widgets/widget_image_background.dart';
import '../util/global_widgets/widget_text_field_personalized.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';

class PageRegisterDispositive extends StatefulWidget {
  const PageRegisterDispositive({super.key});

  @override
  State<PageRegisterDispositive> createState() =>
      _PageRegisterDispositiveState();
}

class _PageRegisterDispositiveState extends State<PageRegisterDispositive> {
  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarColor:
              GlobalColors.colorBackgroundCream.withOpacity(.1)),
      child: const Scaffold(
        body: PopScope(
          canPop: false,
          child: Stack(
            children: [
              WidgetImageBackground(name: 'background.png'),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [MessageInformative(), ButtonRegister()],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MessageInformative extends StatelessWidget {
  const MessageInformative({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prRegisterDispositiveRead =
        context.read<ProviderRegisterDispositive>();
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetTextFieldPersonalized(
              title: prRegisterDispositiveRead.typeRegisterDispositive == 1
                  ? GlobalLabel.textTitleRegisterDispositive
                  : GlobalLabel.textTitleActiveDispositive,
              align: TextAlign.left,
              size: 40,
              color: GlobalColors.colorLetterTitle.withOpacity(.4),
              type: 1),
          WidgetTextFieldPersonalized(
              title: prRegisterDispositiveRead.typeRegisterDispositive == 1
                  ? GlobalLabel.textTitleTwoRegisterDispositive
                  : GlobalLabel.textTitleTwoActiveDispositive,
              align: TextAlign.left,
              size: 40,
              color: GlobalColors.colorLetterTitle,
              type: 1),
          const SizedBox(height: 20),
          WidgetTextFieldPersonalized(
              title: prRegisterDispositiveRead.typeRegisterDispositive == 1
                  ? GlobalLabel.textDescriptionRegisterDispositive
                  : GlobalLabel.textDescriptionActiveDispositive,
              align: TextAlign.left,
              size: 14,
              color: GlobalColors.colorLetterTitle,
              type: 2),
          const ListOperator(),
          Visibility(
            visible: prRegisterDispositiveRead.typeRegisterDispositive != 1,
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              child: WidgetTextFieldPersonalized(
                  title: prRegisterDispositiveRead.message,
                  align: TextAlign.center,
                  size: 14,
                  color: GlobalColors.colorLetterTitle,
                  type: 2),
            ),
          ),
        ],
      ),
    );
  }
}

class ListOperator extends StatelessWidget {
  const ListOperator({super.key});

  @override
  Widget build(BuildContext context) {
    final prRegisterDispositiveRead =
        context.read<ProviderRegisterDispositive>();

    return Visibility(
      visible: prRegisterDispositiveRead.typeRegisterDispositive != 1,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: prRegisterDispositiveRead.listUserOperator!.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(top: 10),
            child: WidgetContainer(
              color: GlobalColors.colorWhite,
              widget: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      GlobalFunction().dialCall(prRegisterDispositiveRead
                          .listUserOperator![index].phone!);
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: WidgetTextFieldSubTitle(
                              title: prRegisterDispositiveRead
                                  .listUserOperator![index].name!,
                              align: TextAlign.left),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: const WidgetIcon(
                                      icon: Icons.phone,
                                      size: 25,
                                      colors: GlobalColors.colorIcon))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ButtonRegister extends StatelessWidget {
  const ButtonRegister({super.key});

  @override
  Widget build(BuildContext context) {
    final prRegisterDispositiveWatch =
        context.watch<ProviderRegisterDispositive>();
    final prServiceRest = context.read<ProviderServiceRest>();
    return Container(
      margin: const EdgeInsets.only(right: 30, left: 30, top: 20),
      child: WidgetButton(
          text: prRegisterDispositiveWatch.typeRegisterDispositive == 1
              ? GlobalLabel.buttonRegisterDispositive
              : GlobalLabel.buttonAccept,
          type: 1,
          onPressed: () {
            if (prRegisterDispositiveWatch.typeRegisterDispositive == 1) {
              prServiceRest.sendRegisterDispositive(context);
            } else {
              Navigator.pop(context);
            }
          }),
    );
  }
}
