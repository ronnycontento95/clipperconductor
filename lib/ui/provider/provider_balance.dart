import 'package:flutter/material.dart';

import '../../data/response/response_balance.dart';
import '../../data/response/response_debts.dart';
import '../../domain/entities/model_balance.dart';
import '../../domain/entities/model_debts.dart';

class ProviderBalance with ChangeNotifier {
  List<ModelBalance>? listBalance = [];
  List<ModelDebts>? listDebts = [];
  double? _balanceTotal = 0.0;
  double? _payDebtsTotal = 0.0;
  bool? _contList = false;

  bool get contList => _contList!;

  set contList(bool value) {
    _contList = value;
  }

  double get payDebtsTotal => _payDebtsTotal!;

  set payDebtsTotal(double value) {
    _payDebtsTotal = value;
  }

  double get balanceTotal => _balanceTotal!;

  set balanceTotal(double value) {
    _balanceTotal = value;
  }

  /// Add list to balance user
  void addListBalance(ResponseBalance responseBalance) {
    if (listBalance!.isNotEmpty) listBalance!.clear();
    listBalance!.addAll(responseBalance.lS!);
    countBalanceTotal();
    notifyListeners();
  }

  /// Add list to
  void addListDebts(ResponseDebts responseDebts) {
    if (listDebts!.isNotEmpty) listDebts!.clear();
    listDebts!.addAll(responseDebts.lD!);
    countPayDebtsTotal();
    notifyListeners();
  }

  void countBalanceTotal() {
    _balanceTotal = 0.0;
    for (ModelBalance balance in listBalance!) {
      _balanceTotal = _balanceTotal! + balance.balance!;
    }
    _contList = true;
    notifyListeners();
  }

  void countPayDebtsTotal() {
    _payDebtsTotal = 0.0;
    for (ModelDebts debts in listDebts!) {
      _payDebtsTotal = _payDebtsTotal! + debts.debts!;
    }
    notifyListeners();
  }


}