import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'provider_service/provider_service_rest.dart';

class ProviderCanceledUser with ChangeNotifier {
  TextEditingController editComment = TextEditingController();

  void qualificationUser(BuildContext context, int requestId) {
    final prServiceRestRead = context.read<ProviderServiceRest>();
    prServiceRestRead.qualificationUser(context, requestId);
  }
}
