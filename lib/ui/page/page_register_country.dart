import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_pre_register.dart';
import '../provider/provider_service/provider_service_rest.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_button.dart';
import '../util/global_widgets/widget_container.dart';
import '../util/global_widgets/widget_divider.dart';
import '../util/global_widgets/widget_message_page.dart';
import '../util/global_widgets/widget_scaffold.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';
import '../util/global_widgets/widget_text_field_title.dart';

class PageRegisterCountry extends StatefulWidget {
  const PageRegisterCountry({Key? key}) : super(key: key);

  @override
  State<PageRegisterCountry> createState() => _PageRegisterCountryState();
}

class _PageRegisterCountryState extends State<PageRegisterCountry> {
  @override
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: GlobalFunction().colorBarView(),
        child: WidgetScaffold(
          onPressed: () => Navigator.pop(context),
          widget: const Stack(children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  WidgetMessagePage(
                      title: GlobalLabel.textSelectCountry,
                      message: GlobalLabel.textDescriptionSelectCountry),
                  ListCountry(),
                  ListCity(),
                  ButtonNext()
                ],
              ),
            ),
          ]),
        ));
  }

  @override
  void initState() {
    super.initState();
    context.read<ProviderServiceRest>().consultCountry(context);
  }
}

class ButtonNext extends StatelessWidget {
  const ButtonNext({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prPreRegisterRead = context.read<ProviderPreRegister>();
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
        width: double.infinity,
        height: 60,
        child: WidgetButton(
            text: GlobalLabel.buttonNext,
            type: 1,
            onPressed: () {
              prPreRegisterRead.validateSelectedCity(context);
            }),
      ),
    );
  }
}

class ListCity extends StatelessWidget {
  const ListCity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prPreRegisterRead = context.read<ProviderPreRegister>();
    final prPreRegisterWatch = context.watch<ProviderPreRegister>();

    return Container(
      width: double.infinity,
      color: GlobalColors.colorWhite,
      margin: const EdgeInsets.only(top: 20, left: 30, right: 30),
      child: WidgetContainer(
        color: GlobalColors.colorWhite,
        widget: ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: prPreRegisterRead.listCity.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    prPreRegisterRead.selectedCityList(
                        prPreRegisterRead.listCity[index].idCity!);
                  },
                  child: Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: SizedBox(
                            width: double.infinity,
                            child: WidgetTextFieldSubTitle(
                                title: prPreRegisterRead.listCity[index].city!,
                                align: TextAlign.left)),
                      ),
                      Flexible(
                        flex: 0,
                        child: Icon(Icons.check_circle,
                            color: prPreRegisterWatch
                                    .listCity[index].stateSelection!
                                ? GlobalColors.colorButton
                                : Colors.transparent),
                      ),
                    ],
                  ),
                ),
                index != prPreRegisterWatch.listCity.length - 1
                    ? const WidgetDivider()
                    : Container()
              ],
            );
          },
        ),
      ),
    );
  }
}

class ListCountry extends StatelessWidget {
  const ListCountry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prPreRegisterRead = context.read<ProviderPreRegister>();
    final prPreRegisterWatch = context.watch<ProviderPreRegister>();
    return Container(
      margin: const EdgeInsets.only(top: 40, left: 30, right: 30),
      height: 35,
      width: double.infinity,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: prPreRegisterRead.listCountry!.length,
        itemBuilder: (context, index) {
          return Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: GestureDetector(
                onTap: () {
                  prPreRegisterRead.selectionCountryList(index);
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: GlobalColors.colorBackground,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    children: [
                      WidgetTextFieldTitle(
                          title: prPreRegisterRead.listCountry![index].country!,
                          align: TextAlign.left),
                      const SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.check_circle,
                          color: prPreRegisterWatch
                                  .listCountry![index].stateSelection!
                              ? GlobalColors.colorButton
                              : Colors.transparent),
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}
