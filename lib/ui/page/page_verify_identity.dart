import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_service/provider_service_rest.dart';
import '../provider/provider_verify_identity.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_button_disable.dart';
import '../util/global_widgets/widget_icon.dart';
import '../util/global_widgets/widget_message_page.dart';
import '../util/global_widgets/widget_scaffold.dart';
import '../util/global_widgets/widget_text_field_sub_title.dart';
import '../util/global_widgets/widget_text_field_title.dart';
import '../util/widget_image_file.dart';

class PageVerifyIdentity extends StatefulWidget {
  const PageVerifyIdentity({super.key});

  @override
  State<PageVerifyIdentity> createState() => _PageVerifyIdentityState();
}

class _PageVerifyIdentityState extends State<PageVerifyIdentity> {
  @override
  Widget build(BuildContext context) {
    final prVerifyIdentityRead = context.read<ProviderVerifyIdentity>();
    return WidgetScaffold(
        onPressed: () {
          GlobalFunction().closeView();
          prVerifyIdentityRead.deleteImage();
        },
        widget: const SingleChildScrollView(
            child: Column(
          children: [
            WidgetMessagePage(
                title: GlobalLabel.textValidateIdentity,
                message: GlobalLabel.textDescriptionValidateIdentity),
            Image(),
            SendImage(),
          ],
        )));
  }

  @override
  void initState() {
    super.initState();
    context.read<ProviderVerifyIdentity>().activeDetectionFace();
  }
}

class SendImage extends StatelessWidget {
  const SendImage({super.key});

  @override
  Widget build(BuildContext context) {
    final prVerifyIdentityWatch = context.watch<ProviderVerifyIdentity>();
    final prServiceRestRead = context.read<ProviderServiceRest>();
    return Container(
      margin: const EdgeInsets.all(30),
      child: WidgetButtonDisable(
          text: GlobalLabel.buttonVerifyIdentity,
          type: prVerifyIdentityWatch.imageFile == null ? 2 : 1,
          onPressed: () {
            prServiceRestRead.sendVerifyIdentity(
                context, prVerifyIdentityWatch.base64Image);
          }),
    );
  }
}

class Image extends StatelessWidget {
  const Image({super.key});

  @override
  Widget build(BuildContext context) {
    final prVerifyIdentityWatch = context.watch<ProviderVerifyIdentity>();
    final prVerifyIdentityRead = context.read<ProviderVerifyIdentity>();
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 40, left: 30, right: 30),
        child: Column(
          children: [
            CircleAvatar(
              radius: 150,
              backgroundColor: GlobalColors.colorBackgroundGrey,
              child: Stack(children: [
                prVerifyIdentityWatch.imageFile != null
                    ? WidgetImageFile(file: prVerifyIdentityWatch.imageFile)
                    : Container(),
                Center(
                  child: GestureDetector(
                      onTap: () async {
                        prVerifyIdentityRead.captureImage();
                        prVerifyIdentityRead.deleteImage();
                      },
                      child: CircleAvatar(
                        backgroundColor: prVerifyIdentityWatch.imageFile != null
                            ? GlobalColors.colorBackground.withOpacity(.5)
                            : GlobalColors.colorBackground,
                        child: const WidgetIcon(
                            icon: Icons.camera_alt_rounded,
                            size: 25,
                            colors: GlobalColors.colorIcon),
                      )),
                ),
              ]),
            ),
            const SizedBox(height: 20),
            const WidgetTextFieldTitle(
                title: GlobalLabel.textSelfie, align: TextAlign.center),
            const WidgetTextFieldSubTitle(
                title: GlobalLabel.textDescriptionSelfie,
                align: TextAlign.center)
          ],
        ),
      ),
    );
  }
}
