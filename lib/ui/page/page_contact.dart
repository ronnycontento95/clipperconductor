import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_contact.dart';
import '../provider/provider_principal.dart';
import '../provider/provider_service/provider_service_rest.dart';
import '../util/global_colors.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_button.dart';
import '../util/global_widgets/widget_circular_progress_page.dart';
import '../util/global_widgets/widget_divider.dart';
import '../util/global_widgets/widget_icon_button.dart';
import '../util/global_widgets/widget_message_page.dart';
import '../util/global_widgets/widget_scaffold.dart';
import '../util/global_widgets/widget_text_field_edit.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';
import '../util/global_widgets/widget_text_field_title.dart';

class PageContact extends StatefulWidget {
  const PageContact({Key? key}) : super(key: key);

  @override
  State<PageContact> createState() => _PageContactState();
}

class _PageContactState extends State<PageContact> {
  @override
  void initState() {
    super.initState();
    context.read<ProviderServiceRest>().consultListContact(context);
  }

  @override
  Widget build(BuildContext context) {
    final prContactWatch = context.watch<ProviderContact>();

    return WidgetScaffold(
        onPressed: () {
          Navigator.pop(context);
        },
        widget: Column(
          children: [
            const Expanded(
              flex: 0,
              child: Column(
                children: [
                  WidgetMessagePage(
                      title: GlobalLabel.textContact,
                      message: GlobalLabel.textDescriptionContact),
                  FormContact(),
                ],
              ),
            ),
            Expanded(
                child: prContactWatch.listContactUser!.isEmpty &&
                        !prContactWatch.contList
                    ? const Center(child: WidgetCircularProgressPage())
                    : const ListContact()),
          ],
        ));
  }
}

class ButtonContact extends StatelessWidget {
  const ButtonContact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prServiceRestRead = context.read<ProviderServiceRest>();

    return WidgetButton(
      text: GlobalLabel.buttonSave,
      type: 1,
      onPressed: () {
        prServiceRestRead.sendContact(context);
      },
    );
  }
}

class FormContact extends StatelessWidget {
  const FormContact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prContactRead = context.read<ProviderContact>();
    final prPrincipalRead = context.read<ProviderPrincipal>();
    return Container(
      margin: const EdgeInsets.only(top: 30),
      color: GlobalColors.colorWhite,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: WidgetTextFieldEdit(
                    identifier: prContactRead.editName,
                    limitCharacter: 45,
                    typeKeyBoard: TextInputType.text,
                    icon: Icons.perm_identity,
                    hintText: GlobalLabel.textUser),
              ),
              Expanded(
                  flex: 0,
                  child: WidgetIconButton(
                      onPressed: () {
                        prContactRead.clearEditName();
                      },
                      icon: Icons.close,
                      size: 20,
                      color: GlobalColors.colorLetterTitle)),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      flex: 0,
                      child: Visibility(
                        visible: false,
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: WidgetTextFieldTitle(
                              title:
                                  '+${prPrincipalRead.modelUser.codeCountry}',
                              align: TextAlign.left),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: WidgetTextFieldEdit(
                        identifier: prContactRead.editContact,
                        limitCharacter: 10,
                        typeKeyBoard: TextInputType.phone,
                        icon: Icons.phone_android_outlined,
                        hintText: GlobalLabel.textHintContact,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  flex: 0,
                  child: WidgetIconButton(
                      onPressed: () {},
                      icon: Icons.close,
                      size: 20,
                      color: GlobalColors.colorLetterTitle)),
            ],
          ),
        ],
      ),
    );
  }
}

class ListContact extends StatelessWidget {
  const ListContact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prContactWatch = context.watch<ProviderContact>();
    final prContactRead = context.read<ProviderContact>();
    final prServiceRestRead = context.watch<ProviderServiceRest>();
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Visibility(
        visible: !prContactRead.contList,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: prContactRead.listContactUser!.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: WidgetTextFieldSubTitle(
                          title:
                              '${prContactRead.listContactUser![index].name}',
                          align: TextAlign.left),
                    ),
                    Expanded(
                      flex: 0,
                      child: SizedBox(
                        width: 30,
                        height: 40,
                        child: Checkbox(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            value:
                                prContactWatch.listContactUser![index].state ==
                                        1
                                    ? true
                                    : false,
                            activeColor: GlobalColors.colorButton,
                            onChanged: (state) {
                              if (prContactWatch
                                      .listContactUser![index].state ==
                                  1) {
                                prServiceRestRead.disableContact(
                                    context,
                                    prContactWatch.listContactUser![index]
                                        .idContactUser!);
                              } else {
                                prServiceRestRead.enableContact(
                                    context,
                                    prContactWatch.listContactUser![index]
                                        .idContactUser!);
                              }
                            }),
                      ),
                    )
                  ],
                ),
                const WidgetDivider()
              ],
            );
          },
        ),
      ),
    );
  }
}
