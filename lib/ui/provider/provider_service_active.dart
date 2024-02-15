import 'package:flutter/cupertino.dart';

import '../../data/response/response_service_active.dart';
import '../../domain/entities/model_service_active.dart';

class ProviderServiceActive with ChangeNotifier {
  List<ModelServiceActive>? listServiceActive = [];

  /// Add service active to the list
  void addListServiceActive(ResponseServiceActive responseServiceActive) {
    if (listServiceActive!.isNotEmpty) listServiceActive!.clear();
    listServiceActive!.addAll(responseServiceActive.data!);
    notifyListeners();
  }
}
