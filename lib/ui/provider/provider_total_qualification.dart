import 'package:flutter/cupertino.dart';

import '../../data/response/response_total_qualification.dart';
import '../../domain/entities/model_total_qualification.dart';

class ProviderTotalQualification with ChangeNotifier {
  List<ModelTotalQualification>? listTotalQualification = [];

  void addTotalQualification(
      ResponseTotalQualification responseTotalQualification) {
    if (listTotalQualification!.isNotEmpty) listTotalQualification!.clear();
    listTotalQualification!.addAll(responseTotalQualification.data!);
    notifyListeners();
  }
}
