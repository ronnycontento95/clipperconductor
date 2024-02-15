import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';

import '../../data/response/response_history_order.dart';
import '../../data/response/response_history_request.dart';
import '../../domain/entities/model_history_order.dart';
import '../../domain/entities/model_history_request.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import 'provider_service/provider_service_rest.dart';

class ProviderGain with ChangeNotifier {
  DateTime? _selected = GlobalFunction().dateNow;
  String? _month = '';
  List<ModelHistoryRequest>? listHistoryRequest = [];
  List<ModelHistoryOrder>? listHistoryOrder = [];
  bool? _contListRequest = false;
  bool? _contListOrder = false;
  double? _gainTotal = 0.00;
  int? _totalRequest = 0;
  double? _paymentCash = 0.00;
  double? _paymentElectronic = 0.00;
  double? _paymentRequest = 0.00;
  double? _paymentOrder = 0.00;
  int? _countPaymentCash = 0;
  int? _countPaymentElectronic = 0;
  int? _countRequest = 0;
  int? _countOrder = 0;
  int? _countPaymentService = 0;
  int? _countTip = 0;
  int? _countWait = 0;
  int? _countChallenge = 0;
  int? _countPaymentExtra = 0;
  int? _typeConsult = 0;

  int get typeConsult => _typeConsult!;

  set typeConsult(int value) {
    _typeConsult = value;
    notifyListeners();
  }

  int get countTip => _countTip!;

  set countTip(int value) {
    _countTip = value;
    notifyListeners();
  }

  int get countWait => _countWait!;

  set countWait(int value) {
    _countWait = value;
    notifyListeners();
  }

  int get countChallenge => _countChallenge!;

  set countChallenge(int value) {
    _countChallenge = value;
    notifyListeners();
  }

  int get countPaymentExtra => _countPaymentExtra!;

  set countPaymentExtra(int value) {
    _countPaymentExtra = value;
    notifyListeners();
  }

  int get countPaymentService => _countPaymentService!;

  set countPaymentService(int value) {
    _countPaymentService = value;
    notifyListeners();
  }

  int get countOrder => _countOrder!;

  set countOrder(int value) {
    _countOrder = value;
    notifyListeners();
  }

  int get countRequest => _countRequest!;

  set countRequest(int value) {
    _countRequest = value;
    notifyListeners();
  }

  int get countPaymentElectronic => _countPaymentElectronic!;

  set countPaymentElectronic(int value) {
    _countPaymentElectronic = value;
    notifyListeners();
  }

  int get countPaymentCash => _countPaymentCash!;

  set countPaymentCash(int value) {
    _countPaymentCash = value;
    notifyListeners();
  }

  bool get contListOrder => _contListOrder!;

  set contListOrder(bool value) {
    _contListOrder = value;
    notifyListeners();
  }

  bool get contListRequest => _contListRequest!;

  set contListRequest(bool value) {
    _contListRequest = value;
    notifyListeners();
  }

  double get paymentOrder => _paymentOrder!;

  set paymentOrder(double value) {
    _paymentOrder = value;
    notifyListeners();
  }

  double get paymentRequest => _paymentRequest!;

  set paymentRequest(double value) {
    _paymentRequest = value;
    notifyListeners();
  }

  double get paymentElectronic => _paymentElectronic!;

  set paymentElectronic(double value) {
    _paymentElectronic = value;
    notifyListeners();
  }

  double get paymentCash => _paymentCash!;

  set paymentCash(double value) {
    _paymentCash = value;
    notifyListeners();
  }

  int get totalRequest => _totalRequest!;

  set totalRequest(int value) {
    _totalRequest = value;
    notifyListeners();
  }

  double get gainTotal => _gainTotal!;

  set gainTotal(double value) {
    _gainTotal = value;
    notifyListeners();
  }

  String get month => _month!;

  set month(String value) {
    _month = value;
    notifyListeners();
  }

  DateTime get selected => _selected!;

  set selected(DateTime value) {
    _selected = value;
    notifyListeners();
  }

  /// Add request to the list
  addListHistoryRequest(ResponseHistoryRequest responseHistoryRequest) {
    if (listHistoryRequest!.isNotEmpty) listHistoryRequest!.clear();
    listHistoryRequest!.addAll(responseHistoryRequest.lHS!);
    calculateMontGainTotal();
    if (listHistoryRequest!.isNotEmpty) {
      _contListRequest = false;
    } else {
      _contListRequest = true;
    }
    notifyListeners();
  }

  /// Add request type order to the list
  addListHistoryOrder(ResponseHistoryOrder responseHistoryOrder) {
    if (listHistoryOrder!.isNotEmpty) listHistoryOrder!.clear();
    listHistoryOrder!.addAll(responseHistoryOrder.lHP!);
    if (listHistoryOrder!.isNotEmpty) {
      _contListOrder = false;
    } else {
      _contListOrder = true;
    }
    notifyListeners();
  }

  /// Filter for selected month
  selectMonth(BuildContext context) {
    final prServiceRestRead = context.read<ProviderServiceRest>();
    showMonthPicker(
            headerColor: GlobalColors.colorButton,
            context: context,
            unselectedMonthTextColor: GlobalColors.colorLetterTitle,
            initialDate: GlobalFunction().dateNow,
            roundedCornersRadius: 20,
            locale: const Locale("es"),
            confirmWidget: const Text(
              GlobalLabel.buttonAcceptCalendar,
            ),
            cancelWidget: const Text(
              GlobalLabel.buttonCancelCalendar,
            ),
            selectedMonthBackgroundColor: GlobalColors.colorButton)
        .then((date) {
      if (date == null) return;
      _selected = date;
      prServiceRestRead.consultNumberHistoryRequestGain(context);
      formatMonth();
      notifyListeners();
    });
  }

  /// Reset current date
  resetMonth() {
    _selected = GlobalFunction().dateNow;
  }

  /// Format date for get month and year
  formatMonth() async {
    await Future.delayed(const Duration(milliseconds: 300));
    switch (_selected!.month) {
      case 1:
        _month = '${GlobalLabel.textJanuary} ${_selected!.year}';
        break;
      case 2:
        _month = '${GlobalLabel.textFebruary} ${_selected!.year}';
        break;
      case 3:
        _month = '${GlobalLabel.textMarch} ${_selected!.year}';
        break;
      case 4:
        _month = '${GlobalLabel.textApril} ${_selected!.year}';
        break;
      case 5:
        _month = '${GlobalLabel.textMay} ${_selected!.year}';
        break;
      case 6:
        _month = '${GlobalLabel.textJunie} ${_selected!.year}';
        break;
      case 7:
        _month = '${GlobalLabel.textJuly} ${_selected!.year}';
        break;
      case 8:
        _month = '${GlobalLabel.textAugust} ${_selected!.year}';
        break;
      case 9:
        _month = '${GlobalLabel.textSeptember} ${_selected!.year}';
        break;
      case 10:
        _month = '${GlobalLabel.textOctober} ${_selected!.year}';
        break;
      case 11:
        _month = '${GlobalLabel.textNovember} ${_selected!.year}';
        break;
      case 12:
        _month = '${GlobalLabel.textDecember} ${_selected!.year}';
        break;
    }
    notifyListeners();
  }

  /// Calculate mont total gain of request type travel and order
  calculateMontGainTotal() {
    resetMont();
    for (ModelHistoryRequest historyRequest in listHistoryRequest!) {
      _gainTotal = _gainTotal! + historyRequest.payment!;
      _paymentRequest = _paymentRequest! + historyRequest.payment!;
      _countRequest = _countRequest! + 1;
      if (historyRequest.typePay == 0) {
        _countPaymentCash = _countPaymentCash! + 1;
        _paymentCash = _paymentCash! + historyRequest.payment!;
      } else {
        _paymentElectronic = _paymentElectronic! + historyRequest.payment!;
        _countPaymentElectronic = _countPaymentElectronic! + 1;
      }
    }
    for (ModelHistoryOrder historyOrder in listHistoryOrder!) {
      _gainTotal = _gainTotal! + historyOrder.price!;
      _paymentOrder = _paymentOrder! + historyOrder.price!;
      _countOrder = _countOrder! + 1;
      if (historyOrder.typePay == 0) {
        _paymentCash = _paymentCash! + historyOrder.price!;
      } else {
        _paymentElectronic = _paymentElectronic! + historyOrder.price!;
      }
    }
    _totalRequest = listHistoryRequest!.length + listHistoryOrder!.length;

    notifyListeners();
  }

  /// Reset data
  resetMont() {
    _gainTotal = 0.00;
    _paymentCash = 0.00;
    _paymentElectronic = 0.00;
    _paymentOrder = 0.00;
    _paymentRequest = 0.00;
    _countPaymentCash = 0;
    _countPaymentElectronic = 0;
    _countOrder = 0;
    _countRequest = 0;
    notifyListeners();
  }
}
