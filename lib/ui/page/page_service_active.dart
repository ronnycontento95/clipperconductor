import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_service_active.dart';
import '../util/global_colors.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_container.dart';
import '../util/global_widgets/widget_divider.dart';
import '../util/global_widgets/widget_message_page.dart';
import '../util/global_widgets/widget_scaffold.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';
import '../util/global_widgets/widget_text_field_title.dart';

class PageServiceActive extends StatefulWidget {
  const PageServiceActive({Key? key}) : super(key: key);

  @override
  State<PageServiceActive> createState() => _PageServiceActiveState();
}

class _PageServiceActiveState extends State<PageServiceActive> {
  @override
  void initState() {
    super.initState();
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
                  title: GlobalLabel.textTitleServiceActive,
                  message: GlobalLabel.textDescriptionServiceActive),
              ListService()
            ],
          ),
        ));
  }
}

class ListService extends StatelessWidget {
  const ListService({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prServiceActiveRead = context.read<ProviderServiceActive>();
    final prServiceActiveWatch = context.watch<ProviderServiceActive>();
    return Visibility(
      visible: prServiceActiveWatch.listServiceActive!.isNotEmpty,
      child: Container(
        margin: const EdgeInsets.only(top: 40, right: 30, left: 30),
        child: WidgetContainer(
          color: GlobalColors.colorWhite,
          widget: ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: prServiceActiveWatch.listServiceActive!.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WidgetTextFieldTitle(
                                title: prServiceActiveRead
                                    .listServiceActive![index].service!,
                                align: TextAlign.left),
                            const WidgetTextFieldSubTitle(
                                title: 'Falta la descripcion del servicio',
                                align: TextAlign.left)
                          ],
                        ),
                      ),
                      // Expanded(
                      //   flex: 0,
                      //   child: SizedBox(
                      //     height: 30,
                      //     child: Switch(
                      //       activeColor: GlobalColors.colorButton,
                      //       value: true,
                      //       onChanged: (value) {},
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                  index != prServiceActiveRead.listServiceActive!.length - 1
                      ? const WidgetDivider()
                      : Container()
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
