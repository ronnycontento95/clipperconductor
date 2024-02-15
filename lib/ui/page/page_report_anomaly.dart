import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_report_anomaly.dart';
import '../provider/provider_service/provider_service_rest.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_button.dart';
import '../util/global_widgets/widget_divider.dart';
import '../util/global_widgets/widget_icon.dart';
import '../util/global_widgets/widget_icon_button.dart';
import '../util/global_widgets/widget_message_page.dart';
import '../util/global_widgets/widget_scaffold.dart';
import '../util/global_widgets/widget_text_field_edit.dart';

class PageReportAnomaly extends StatelessWidget {
  const PageReportAnomaly({Key? key}) : super(key: key);

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
                title: GlobalLabel.textTitleReportAnomaly,
                message: GlobalLabel.textDescriptionReportAnomaly),
            SelectedImage(),
            FormReportAnomaly(),
            ButtonReportAnomaly(),
          ],
        ),
      ),
    );
  }
}

class ButtonReportAnomaly extends StatelessWidget {
  const ButtonReportAnomaly({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prServiceRestRead = context.read<ProviderServiceRest>();

    return WidgetButton(
      text: GlobalLabel.buttonSendReport,
      type: 1,
      onPressed: () {
        prServiceRestRead.sendAnomaly(context);
      },
    );
  }
}

class SelectedImage extends StatelessWidget {
  const SelectedImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prReportAnomalyWatch = context.watch<ProviderReportAnomaly>();
    final prReportAnomalyRead = context.read<ProviderReportAnomaly>();

    return Container(
      margin: const EdgeInsets.only(top: 20),
      height: 200,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: GlobalColors.colorBackgroundView,
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          Visibility(
            visible: prReportAnomalyWatch.listImage!.isNotEmpty ? false : true,
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () async {
                        GlobalFunction().openCamera(2);
                      },
                      child: const WidgetIcon(
                          icon: Icons.camera_alt_outlined,
                          size: 50,
                          colors: GlobalColors.colorLetterTitle)),
                  const SizedBox(
                    width: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      GlobalFunction().openGallery(2);
                    },
                    child: const WidgetIcon(
                        icon: Icons.image,
                        size: 50,
                        colors: GlobalColors.colorLetterTitle),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: prReportAnomalyWatch.listImage!.isNotEmpty ? true : false,
            child: SizedBox(
              width: double.infinity,
              height: 260,
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  child: prReportAnomalyWatch.listImage!.isNotEmpty
                      ? Image.file(
                          prReportAnomalyWatch.listImage![0],
                          fit: BoxFit.contain,
                        )
                      : Container()),
            ),
          ),
          Visibility(
            visible: prReportAnomalyWatch.listImage!.isNotEmpty ? true : false,
            child: GestureDetector(
              onTap: () {
                prReportAnomalyRead.deleteImage();
              },
              child: Container(
                alignment: Alignment.topRight,
                margin: const EdgeInsets.all(10),
                child: const CircleAvatar(
                    backgroundColor: GlobalColors.colorWhite,
                    radius: 10,
                    child: WidgetIcon(
                        icon: Icons.close,
                        size: 20,
                        colors: GlobalColors.colorLetterTitle)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FormReportAnomaly extends StatelessWidget {
  const FormReportAnomaly({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prReportAnomalyRead = context.read<ProviderReportAnomaly>();
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      color: GlobalColors.colorWhite,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: WidgetTextFieldEdit(
                    identifier: prReportAnomalyRead.editLate,
                    limitCharacter: 45,
                    typeKeyBoard: TextInputType.text,
                    icon: Icons.abc_rounded,
                    hintText: GlobalLabel.textPlate),
              ),
              Expanded(
                  flex: 0,
                  child: WidgetIconButton(
                      onPressed: () {
                        prReportAnomalyRead.cleanTextFieldEditLate();
                      },
                      icon: Icons.close_rounded,
                      size: 20,
                      color: GlobalColors.colorLetterTitle)),
            ],
          ),
          const WidgetDivider(),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: WidgetTextFieldEdit(
                    identifier: prReportAnomalyRead.editColor,
                    limitCharacter: 45,
                    typeKeyBoard: TextInputType.text,
                    icon: Icons.color_lens,
                    hintText: GlobalLabel.textColor),
              ),
              Expanded(
                flex: 0,
                child: WidgetIconButton(
                    onPressed: () {
                      prReportAnomalyRead.cleanTextEditColor();
                    },
                    color: GlobalColors.colorLetterTitle,
                    icon: Icons.close,
                    size: 20),
              ),
            ],
          ),
          const WidgetDivider(),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: WidgetTextFieldEdit(
                    identifier: prReportAnomalyRead.editCommentary,
                    limitCharacter: 45,
                    typeKeyBoard: TextInputType.text,
                    icon: Icons.comment_bank,
                    hintText: GlobalLabel.textCommentary),
              ),
              Expanded(
                  flex: 0,
                  child: WidgetIconButton(
                      onPressed: () {
                        prReportAnomalyRead.cleanTextEditCommentary();
                      },
                      color: GlobalColors.colorLetterTitle,
                      icon: Icons.close,
                      size: 20)),
            ],
          ),
        ],
      ),
    );
  }
}
