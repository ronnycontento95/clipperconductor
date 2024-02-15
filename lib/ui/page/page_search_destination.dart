import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../provider/provider_search_destination.dart';
import '../provider/provider_service/provider_service_rest.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_container.dart';
import '../util/global_widgets/widget_divider.dart';
import '../util/global_widgets/widget_icon.dart';
import '../util/global_widgets/widget_message_page.dart';
import '../util/global_widgets/widget_scaffold.dart';
import '../util/global_widgets/widget_text_field_personalized.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';
import '../util/global_widgets/widget_text_field_title.dart';

class PageSearchDestination extends StatefulWidget {
  const PageSearchDestination({Key? key}) : super(key: key);

  @override
  State<PageSearchDestination> createState() => _PageSearchDestinationState();
}

class _PageSearchDestinationState extends State<PageSearchDestination> {
  @override
  void initState() {
    super.initState();
    context.read<ProviderSearchDestination>().initSpeech();
    context.read<ProviderSearchDestination>().getDirectionRecent();
    context.read<ProviderServiceRest>().getDirectionForCoordinate(context);
    context.read<ProviderSearchDestination>().markerSearchDirection(context);
  }

  @override
  Widget build(BuildContext context) {
    return WidgetScaffold(
        onPressed: () => Navigator.pop(context),
        widget: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              WidgetMessagePage(
                  title: GlobalLabel.textTitleSearchDestination,
                  message: GlobalLabel.textDescriptionSearchDestination),
              TextFieldSearch(),
              ListDirection(),
              ListDirectionRecent(),
            ],
          ),
        ));
  }
}

class TextFieldSearch extends StatelessWidget {
  const TextFieldSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prSearchDestinationRead = context.read<ProviderSearchDestination>();
    return Container(
      margin: const EdgeInsets.only(top: 40, right: 30, left: 30),
      height: 50,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: GlobalColors.colorBackground,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                border: Border.all(width: 1.0, color: GlobalColors.colorBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: TextFieldSearchDestination(
                          type: TextInputType.text,
                          identifier: prSearchDestinationRead.editSearch,
                          nameTextField: GlobalLabel.textSearchDestination,
                          icon: Icons.search_outlined,
                          limitCharacter: 200)),
                  Expanded(
                    flex: 0,
                    child: GestureDetector(
                      onTap: () {
                        GlobalFunction().hideQuery();
                        prSearchDestinationRead.cleanTextFieldSearch();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: const WidgetIcon(
                            icon: Icons.close_rounded,
                            size: 20,
                            colors: GlobalColors.colorLetterTitle),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 0,
            child: GestureDetector(
              onLongPress: () => prSearchDestinationRead.startListening(),
              onLongPressUp: () {
                Timer(const Duration(milliseconds: 300), () {
                  prSearchDestinationRead.stopListening(context);
                });
              },
              child: const CircleAvatar(
                backgroundColor: GlobalColors.colorGreenAqua,
                child: WidgetIcon(
                    icon: Icons.mic_rounded,
                    size: 30,
                    colors: GlobalColors.colorWhite),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ListDirectionRecent extends StatelessWidget {
  const ListDirectionRecent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prSearchDestinationRead = context.read<ProviderSearchDestination>();
    final prSearchDestinationWatch = context.watch<ProviderSearchDestination>();
    final prServiceRestRead = context.read<ProviderServiceRest>();
    return Visibility(
      visible: prSearchDestinationWatch.listDirectionStreetRecent!.isNotEmpty,
      child: Container(
        margin: const EdgeInsets.only(left: 30, right: 30, top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WidgetDivider(),
            const SizedBox(height: 10),
             const WidgetTextFieldPersonalized(
               type: 1,
              color: GlobalColors.colorLetterTitle,
              size: 16,
                title: GlobalLabel.textSuggestionSearchRecent,
                align: TextAlign.left),
            const SizedBox(height: 10),
            WidgetContainer(
              color: GlobalColors.colorWhite,
              widget: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount:
                    prSearchDestinationRead.listDirectionStreetRecent!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      prSearchDestinationRead.selectedDirectionStreet =
                          prSearchDestinationRead
                              .listDirectionStreetRecent![index];
                      prServiceRestRead.getSuggestionDirection(context);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  WidgetTextFieldTitle(
                                      title:
                                          "${prSearchDestinationRead.listDirectionStreetRecent![index].structuredFormatting!.mainText}",
                                      align: TextAlign.left),
                                  WidgetTextFieldSubTitle(
                                      title:
                                          "${prSearchDestinationRead.listDirectionStreetRecent![index].structuredFormatting!.secondaryText}",
                                      align: TextAlign.left)
                                ],
                              ),
                            ),
                            const Expanded(
                              flex: 0,
                              child: WidgetIcon(
                                  icon: Icons.navigate_next_rounded,
                                  size: 25,
                                  colors: GlobalColors.colorLetterTitle),
                            )
                          ],
                        ),
                        index ==
                                prSearchDestinationRead
                                        .listDirectionStreetRecent!.length -
                                    1
                            ? Container()
                            : const WidgetDivider(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListDirection extends StatelessWidget {
  const ListDirection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prSearchDestinationRead = context.read<ProviderSearchDestination>();
    final prSearchDestinationWatch = context.watch<ProviderSearchDestination>();
    final prServiceRestRead = context.read<ProviderServiceRest>();
    return Visibility(
      visible: prSearchDestinationWatch.listDirectionStreet!.isNotEmpty,
      child: Container(
        margin: const EdgeInsets.only(left: 30, right: 30, top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WidgetTextFieldTitle(
                title:
                    '${GlobalLabel.textSuggestionSearch} (${prSearchDestinationRead.listDirectionStreet!.length})',
                align: TextAlign.left),
            const SizedBox(height: 20),
            WidgetContainer(
              color: GlobalColors.colorWhite,
              widget: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: prSearchDestinationRead.listDirectionStreet!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      prSearchDestinationRead.selectedDirectionStreet =
                          prSearchDestinationRead.listDirectionStreet![index];
                      prServiceRestRead.getSuggestionDirection(context);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  WidgetTextFieldTitle(
                                      title:
                                          "${prSearchDestinationRead.listDirectionStreet![index].structuredFormatting!.mainText}",
                                      align: TextAlign.left),
                                  WidgetTextFieldSubTitle(
                                      title:
                                          "${prSearchDestinationRead.listDirectionStreet![index].structuredFormatting!.secondaryText}",
                                      align: TextAlign.left)
                                ],
                              ),
                            ),
                            const Expanded(
                              flex: 0,
                              child: WidgetIcon(
                                  icon: Icons.navigate_next_rounded,
                                  size: 25,
                                  colors: GlobalColors.colorLetterTitle),
                            )
                          ],
                        ),
                        index ==
                                prSearchDestinationRead
                                        .listDirectionStreet!.length -
                                    1
                            ? Container()
                            : const WidgetDivider(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextFieldSearchDestination extends StatelessWidget {
  const TextFieldSearchDestination(
      {Key? key,
      required this.type,
      required this.identifier,
      required this.nameTextField,
      required this.icon,
      required this.limitCharacter})
      : super(key: key);
  final TextInputType type;
  final TextEditingController identifier;
  final String nameTextField;
  final IconData icon;
  final int limitCharacter;

  @override
  Widget build(BuildContext context) {
    final prSearchDestinationRead = context.read<ProviderSearchDestination>();
    final prServiceRestRead = context.read<ProviderServiceRest>();
    return Container(
        height: 50.0,
        padding: const EdgeInsets.all(5.0),
        child: TextFormField(
          controller: identifier,
          autocorrect: true,
          autofocus: false,
          inputFormatters: [
            LengthLimitingTextInputFormatter(limitCharacter),
          ],
          keyboardType: type,
          onChanged: (value) {
            if (value.length > 3) {
              prServiceRestRead.getListSuggestionDirection(context, value);
            } else if (value.isEmpty) {
              prSearchDestinationRead.cleanTextFieldSearch();
            }
          },
          style:
              TextStyle(color: GlobalColors.colorLetterTitle.withOpacity(.8)),
          decoration: InputDecoration(
            hintText: nameTextField,
            contentPadding: const EdgeInsets.only(top: 10.0),
            prefixIcon: Icon(icon),
            hintStyle: TextStyle(
                color: GlobalColors.colorLetterSubTitle.withOpacity(.3)),
            filled: true,
            fillColor: GlobalColors.colorBackground,
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              borderSide:
                  BorderSide(color: GlobalColors.colorBackground, width: .5),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              borderSide:
                  BorderSide(color: GlobalColors.colorBackground, width: .5),
            ),
          ),
        ));
  }
}
