import 'package:flutter/cupertino.dart';

import '../../data/response/response_package_pending.dart';
import '../../data/response/response_package_recharge.dart';
import '../../data/response/response_package_request.dart';
import '../../domain/entities/model_package_pending.dart';
import '../../domain/entities/model_package_recharge.dart';
import '../../domain/entities/model_package_request.dart';
import '../page/page_detail_package_request.dart';
import '../util/global_function.dart';

class ProviderBuyPackage with ChangeNotifier {
  bool? _countPackageRequest = false;
  bool? _countPackageOrder = false;
  List<ModelPackageRequest>? listPackageRequest = [];
  List<ModelPackageRecharge>? listPackageRechargeRequest = [];
  List<ModelPackageRecharge>? listPackageRechargeOrder = [];
  List<ModelPackagePending>? listPackagePending = [];
  List<Package>? listPackageHistory = [];
  ModelPackagePending? _packagePending;
  bool? _contList = false;
  int? _typeBuyCancelPackage = 0;

  int get typeBuyCancelPackage => _typeBuyCancelPackage!;

  set typeBuyCancelPackage(int value) {
    _typeBuyCancelPackage = value;
  }

  bool get contList => _contList!;

  set contList(bool value) {
    _contList = value;
  }

  bool get countPackageRequest => _countPackageRequest!;

  set countPackageRequest(bool value) {
    _countPackageRequest = value;
  }

  ModelPackagePending get packagePending => _packagePending!;

  set packagePending(ModelPackagePending value) {
    _packagePending = value;
  }

  bool get countPackageOrder => _countPackageOrder!;

  set countPackageOrder(bool value) {
    _countPackageOrder = value;
  }

  /// Add package pending to the list
  void addListPackagePending(ResponsePackagePending responsePackagePending) {
    if (listPackagePending!.isNotEmpty) listPackagePending!.clear();
    listPackagePending!.addAll(responsePackagePending.lP!);
    checkPackagePendingRequest();
    checkPackagePendingOrder();
    notifyListeners();
  }

  /// Add package request to the list
  void addListPackageRequest(ResponsePackageRequest responsePackageRequest) {
    if (listPackageRequest!.isNotEmpty) listPackageRequest!.clear();
    listPackageRequest!.addAll(responsePackageRequest.lPt!);
    if (listPackageRequest!.isNotEmpty) {
      _contList = false;
    } else {
      _contList = true;
    }
    notifyListeners();
  }

  /// Add package of request type travel to the list
  void addListPackageRechargeRequest(
      ResponsePackageRecharge responsePackageRecharge) {
    if (listPackageRechargeRequest!.isNotEmpty) {
      listPackageRechargeRequest!.clear();
    }
    listPackageRechargeRequest!.addAll(responsePackageRecharge.data!);

    notifyListeners();
  }

  /// Add package of order type travel to the list
  void addListPackageRechargeOrder(
      ResponsePackageRecharge responsePackageRecharge) {
    if (listPackageRechargeOrder!.isNotEmpty) listPackageRechargeOrder!.clear();
    listPackageRechargeOrder!.addAll(responsePackageRecharge.data!);
    notifyListeners();
  }

  /// Set selected package of request type travel
  void checkPackagePendingRequest() {
    if (listPackagePending!.isEmpty) return;
    for (ModelPackagePending packagePending in listPackagePending!) {
      if (packagePending.idPackageType == 1) {
        countPackageRequest = true;
        break;
      }
    }
    notifyListeners();
  }

  /// Set selected package of request type order
  void checkPackagePendingOrder() {
    if (listPackagePending!.isEmpty) return;
    for (ModelPackagePending packagePending in listPackagePending!) {
      if (packagePending.idPackageType == 2) {
        countPackageOrder = true;
        break;
      }
    }
    notifyListeners();
  }

  /// Add package to the list
  void addListHistoryPackage(BuildContext context, List<Package> listHistory) {
    if (listPackageHistory!.isNotEmpty) listPackageHistory!.clear();
    listPackageHistory!.addAll(listHistory);
    GlobalFunction().hideProgress();
    GlobalFunction().nextPageViewTransition(const PageDetailPackageRequest());
    notifyListeners();
  }

  /// Canceled package pending
  void canceledPackagePending() {
    _packagePending = listPackagePending![0];
    _typeBuyCancelPackage = 2;
    notifyListeners();
  }
}
