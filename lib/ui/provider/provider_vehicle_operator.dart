
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/model_user.dart';
import 'provider_service/provider_service_rest.dart';

class ProviderVehicleOperator with ChangeNotifier {
  List<ModelUser>? listUser = [];

  void addListUser(List<ModelUser> list) {
    if (listUser!.isNotEmpty) listUser!.clear();
    listUser!.addAll(list);
    notifyListeners();
  }

  void initLogIn(BuildContext context, ModelUser modelUser) {
    final prServiceSocketRead = context.read<ProviderServiceRest>();
    prServiceSocketRead.initLogInOperator(context, modelUser);
  }
}
