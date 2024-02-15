import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_vehicle_operator.dart';
import '../util/global_colors.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_container.dart';
import '../util/global_widgets/widget_icon.dart';
import '../util/global_widgets/widget_message_page.dart';
import '../util/global_widgets/widget_scaffold.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';
import '../util/global_widgets/widget_text_field_title.dart';

class PageVehicleOperator extends StatelessWidget {
  const PageVehicleOperator({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetScaffold(
        onPressed: () {
          Navigator.pop(context);
        },
        widget: const SingleChildScrollView(
          child: Column(
            children: [
              WidgetMessagePage(
                  title: GlobalLabel.textTitleVehicleEnable,
                  message: GlobalLabel.textDescriptionVehicle),
              ListVehicle()
            ],
          ),
        ));
  }
}

class ListVehicle extends StatelessWidget {
  const ListVehicle({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProviderVehicleOperator>();
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: provider.listUser!.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              provider.initLogIn(context, provider.listUser![index]);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 5),
                  child: WidgetContainer(
                    color: GlobalColors.colorWhite,
                    widget: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              WidgetTextFieldTitle(
                                  title: provider.listUser![index].business!,
                                  align: TextAlign.left),
                              WidgetTextFieldSubTitle(
                                  title:
                                      provider.listUser![index].vehiclePlate!,
                                  align: TextAlign.left),
                              WidgetTextFieldSubTitle(
                                  title: provider.listUser![index].city!,
                                  align: TextAlign.left),
                            ],
                          ),
                        ),
                        const Expanded(
                            flex: 0,
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: GlobalColors.colorBackground,
                              child: WidgetIcon(
                                  icon: Icons.navigate_next_rounded,
                                  size: 25,
                                  colors: GlobalColors.colorLetterSubTitle),
                            ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
