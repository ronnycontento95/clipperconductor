import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/provider_principal.dart';
import '../provider/provider_service/provider_service_socket.dart';
import '../provider/provider_taximeter.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_widgets/widget_button.dart';
import '../util/global_widgets/widget_divider.dart';
import '../util/global_widgets/widget_text_field_title.dart';
import 'page_taximeter_request.dart';

class PageTaximeterStreet extends StatefulWidget {
  const PageTaximeterStreet({super.key});

  @override
  State<PageTaximeterStreet> createState() => _PageTaximeterStreet();
}

class _PageTaximeterStreet extends State<PageTaximeterStreet> {
  @override
  Widget build(BuildContext context) {
    final prPrincipalWatch = context.watch<ProviderPrincipal>();
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prServiceSocketRead = context.watch<ProviderServiceSocket>();
    final prTaximeterRead = context.watch<ProviderTaximeter>();

    return Visibility(
      visible: prPrincipalWatch.stateTaximeterStreet,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: GlobalColors.colorBackgroundBlue.withOpacity(.4),
                blurRadius: 10.0,
              ),
            ],
            color: GlobalColors.colorWhite,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            border: Border.all(
              width: 2,
              color: GlobalColors.colorWhite,
            ),
          ),
          alignment: Alignment.bottomCenter,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 0,
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: WidgetTextFieldTitle(
                      title: prPrincipalRead.modelRequestActive!.requestData !=
                              null
                          ? prPrincipalWatch.messageStateRequest
                          : GlobalLabel.textServiceStreet,
                      align: TextAlign.center),
                ),
              ),
              const WidgetDivider(),
              const Expanded(flex: 0, child: PageTaximeterRequest()),
              Expanded(
                flex: 0,
                child: Container(
                  height: 60,
                  margin: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
                  child: WidgetButton(
                      text: GlobalLabel.buttonEndService,
                      type: 1,
                      onPressed: () {
                        if (!prTaximeterRead.connectedTaximeterExternal) {
                          prServiceSocketRead.activePayment(context);
                        } else {
                          if(prPrincipalRead.stateTaximeterStreet && !prTaximeterRead.statusRunTaximeter){
                            prServiceSocketRead.actionButtonRequest(context);
                          }else {
                            GlobalFunction().speakMessage(
                                GlobalLabel.textMessageFinalizeTaximeter);
                            GlobalFunction().messageConfirmation(
                                GlobalLabel.textQuestionFinalizeTaximeter, () {
                            });
                          }
                        }
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
