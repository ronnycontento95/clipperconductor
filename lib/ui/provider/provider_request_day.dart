import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/response/response_request_day.dart';
import '../../domain/entities/model_history_request_day.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import 'provider_service/provider_service_rest.dart';

class ProviderRequestDay extends ChangeNotifier {
  List<ModelHistoryRequestDay>? listRequestDay = [];
  List<ModelHistoryRequestDay>? listFilterRequestDay = [];
  double? _gainRequest = 0.00;
  DateTime? _selected = GlobalFunction().dateNow;
  String? _dayHistory = '';
  bool? _contList = false;
  int? _numRequest = 0;
  int? _countPaymentCash = 0;
  double? _paymentCash = 0.00;
  int? _countPaymentElectronic = 0;
  double? _paymentElectronic = 0.00;
  int? _countRequest = 0;
  double? _paymentRequest = 0.00;
  int? _countOrder = 0;
  double? _paymentOrder = 0.00;
  int? _typeConsult = 0;
  int? _countTip = 0;
  int? _countWait = 0;
  int? _countChallenge = 0;
  int? _countPaymentExtra = 0;
  int? _countPaymentService = 0;

  double get gainRequest => _gainRequest!;

  set gainRequest(double value) {
    _gainRequest = value;
  }

  String get dayHistory => _dayHistory!;

  set dayHistory(String value) {
    _dayHistory = value;
  }

  DateTime get selected => _selected!;

  set selected(DateTime value) {
    _selected = value;
    notifyListeners();
  }

  bool get contList => _contList!;

  set contList(bool value) {
    _contList = value;
  }

  int get numRequest => _numRequest!;

  set numRequest(int value) {
    _numRequest = value;
  }

  int get countPaymentCash => _countPaymentCash!;

  set countPaymentCash(int value) {
    _countPaymentCash = value;
  }

  double get paymentCash => _paymentCash!;

  set paymentCash(double value) {
    _paymentCash = value;
  }

  int get countPaymentElectronic => _countPaymentElectronic!;

  set countPaymentElectronic(int value) {
    _countPaymentElectronic = value;
  }

  double get paymentElectronic => _paymentElectronic!;

  set paymentElectronic(double value) {
    _paymentElectronic = value;
  }

  int get countRequest => _countRequest!;

  set countRequest(int value) {
    _countRequest = value;
  }

  double get paymentRequest => _paymentRequest!;

  set paymentRequest(double value) {
    _paymentRequest = value;
  }

  int get countOrder => _countOrder!;

  set countOrder(int value) {
    _countOrder = value;
  }

  double get paymentOrder => _paymentOrder!;

  set paymentOrder(double value) {
    _paymentOrder = value;
  }

  int get typeConsult => _typeConsult!;

  set typeConsult(int value) {
    _typeConsult = value;
  }

  int get countTip => _countTip!;

  set countTip(int value) {
    _countTip = value;
  }

  int get countWait => _countWait!;

  set countWait(int value) {
    _countWait = value;
  }

  int get countChallenge => _countChallenge!;

  set countChallenge(int value) {
    _countChallenge = value;
  }

  int get countPaymentExtra => _countPaymentExtra!;

  set countPaymentExtra(int value) {
    _countPaymentExtra = value;
  }

  int get countPaymentService => _countPaymentService!;

  set countPaymentService(int value) {
    _countPaymentService = value;
  }

  /// Get date in the format day, month and year
  void formatDay() async {
    await Future.delayed(const Duration(milliseconds: 300));
    switch (_selected!.month) {
      case 1:
        dayHistory =
            '${_selected!.day} ${GlobalLabel.textJanuary} ${_selected!.year}';
        break;
      case 2:
        dayHistory =
            '${_selected!.day} ${GlobalLabel.textFebruary} ${_selected!.year}';
        break;
      case 3:
        dayHistory =
            '${_selected!.day} ${GlobalLabel.textMarch} ${_selected!.year}';
        break;
      case 4:
        dayHistory =
            '${_selected!.day} ${GlobalLabel.textApril} ${_selected!.year}';
        break;
      case 5:
        dayHistory =
            '${_selected!.day} ${GlobalLabel.textMay} ${_selected!.year}';
        break;
      case 6:
        dayHistory =
            '${_selected!.day} ${GlobalLabel.textJunie} ${_selected!.year}';
        break;
      case 7:
        dayHistory =
            '${_selected!.day} ${GlobalLabel.textJuly} ${_selected!.year}';
        break;
      case 8:
        dayHistory =
            '${_selected!.day} ${GlobalLabel.textAugust} ${_selected!.year}';
        break;
      case 9:
        dayHistory =
            '${_selected!.day} ${GlobalLabel.textSeptember} ${_selected!.year}';
        break;
      case 10:
        dayHistory =
            '${_selected!.day} ${GlobalLabel.textOctober} ${_selected!.year}';
        break;
      case 11:
        dayHistory =
            '${_selected!.day} ${GlobalLabel.textNovember} ${_selected!.year}';
        break;
      case 12:
        dayHistory =
            '${_selected!.day} ${GlobalLabel.textDecember} ${_selected!.year}';
        break;
    }
    notifyListeners();
  }

  /// Add to the list request day
  void addListRequestDay(ResponseRequestDay responseRequestDay) {
    if (listRequestDay!.isNotEmpty) listRequestDay!.clear();
    listRequestDay!.addAll(responseRequestDay.lSH!);
    calculateMont();
    if (listRequestDay!.isNotEmpty) {
      _contList = false;
    } else {
      _contList = true;
    }
    _numRequest = listRequestDay!.length;
    notifyListeners();
  }

  /// Calculate gain of day
  void calculateMont() {
    resetMont();
    for (ModelHistoryRequestDay historyRequestDay in listRequestDay!) {
      if (historyRequestDay.typePay == 0) {
        _countPaymentCash = _countPaymentCash! + 1;
        _paymentCash = _paymentCash! +
            historyRequestDay.payment! +
            historyRequestDay.price!;
      } else {
        _countPaymentElectronic = _countPaymentElectronic! + 1;
        _paymentElectronic = _paymentElectronic! +
            historyRequestDay.payment! +
            historyRequestDay.price!;
      }
      if (historyRequestDay.price == 0) {
        _countRequest = _countRequest! + 1;
        _paymentRequest = _paymentRequest! + historyRequestDay.payment!;
      } else {
        _countOrder = _countOrder! + 1;
        _paymentOrder = _paymentOrder! + historyRequestDay.price!;
      }
    }

    _gainRequest = _paymentCash! + _paymentElectronic!;
    notifyListeners();
  }

  /// Reset variable
  void resetMont() {
    _paymentCash = 0.00;
    _paymentElectronic = 0.00;
    _paymentRequest = 0.00;
    _paymentOrder = 0.00;
    _countPaymentCash = 0;
    _countPaymentElectronic = 0;
    _countRequest = 0;
    _countOrder = 0;
    _countPaymentService = 0;
    _countTip = 0;
    _countWait = 0;
    _countChallenge = 0;
    _countPaymentExtra = 0;
    notifyListeners();
  }

  /// Filter request day
  /// Type consult 0: All request day
  /// Type consult 1: Request type travel
  /// Type consult 2: Request type order
  /// Type consult 3: Payment cash
  /// Type consult 4: Payment electronic
  void filterRequestDay() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (listFilterRequestDay!.isNotEmpty) listFilterRequestDay!.clear();
    for (ModelHistoryRequestDay historyRequestDay in listRequestDay!) {
      if (_typeConsult == 1) {
        if (historyRequestDay.price == 0) {
          listFilterRequestDay!.add(historyRequestDay);
        }
      } else if (_typeConsult == 2) {
        if (historyRequestDay.price! > 0) {
          listFilterRequestDay!.add(historyRequestDay);
        }
      } else if (_typeConsult == 3) {
        if (historyRequestDay.typePay! == 0) {
          listFilterRequestDay!.add(historyRequestDay);
        }
      } else if (_typeConsult == 4) {
        if (historyRequestDay.typePay! != 0) {
          listFilterRequestDay!.add(historyRequestDay);
        }
      }
    }
    if (listFilterRequestDay!.isNotEmpty) {
      _contList = false;
    } else {
      _contList = true;
    }
    notifyListeners();
  }

  /// Selected date
  Future selectDate(BuildContext context) async {
    final prServiceRestRead = context.read<ProviderServiceRest>();
    await showDatePicker(
            context: GlobalFunction.context.currentContext!,
            locale: const Locale("es"),
            cancelText: GlobalLabel.buttonCancelCalendar,
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: ThemeData(
                  dialogTheme: DialogTheme(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20.0), // this is the border radius of the picker
                    ),
                  ),
                  dialogBackgroundColor: Colors.white,
                ),
                child: child ?? const Text(''),
              );
            },
            // initialDate: selectedDate,
            firstDate:
                GlobalFunction().dateNow.subtract(const Duration(days: 30)),
            lastDate: GlobalFunction().dateNow,
            initialDate: GlobalFunction().dateNow)
        .then((date) {
      if (date == null) return;
      _selected = date;
      prServiceRestRead.filterCalendarRequestDay(date, context);
      formatDay();
    });
  }

  /// Get total gain of day
  gainHistory() {
    double totalGain = 0.0;
    if (_typeConsult == 0) {
      for (ModelHistoryRequestDay historyRequestDay in listRequestDay!) {
        totalGain = totalGain + historyRequestDay.payment!;
      }
    } else {
      for (ModelHistoryRequestDay historyRequestDay in listFilterRequestDay!) {
        totalGain = totalGain + historyRequestDay.payment!;
      }
    }

    return totalGain.toStringAsFixed(2);
  }

  /// Get date in the format month
  String formatDateHistory() {
    String monthHistory = '';
    switch (_selected!.month) {
      case 1:
        monthHistory = GlobalLabel.textJanuary;
        break;
      case 2:
        monthHistory = GlobalLabel.textFebruary;
        break;
      case 3:
        monthHistory = GlobalLabel.textMarch;
        break;
      case 4:
        monthHistory = GlobalLabel.textApril;
        break;
      case 5:
        monthHistory = GlobalLabel.textMay;
        break;
      case 6:
        monthHistory = GlobalLabel.textJunie;
        break;
      case 7:
        monthHistory = GlobalLabel.textJuly;
        break;
      case 8:
        monthHistory = GlobalLabel.textAugust;
        break;
      case 9:
        monthHistory = GlobalLabel.textSeptember;
        break;
      case 10:
        monthHistory = GlobalLabel.textOctober;
        break;
      case 11:
        monthHistory = GlobalLabel.textNovember;
        break;
      case 12:
        monthHistory = GlobalLabel.textDecember;
        break;
    }
    return monthHistory;
  }

  /// Get icon for request state
  iconStateRequest(int state) {
    Icon? icon;
    switch (state) {
      case 0:
        icon = const Icon(Icons.pending_rounded,
            color: GlobalColors.colorButton, size: 15);
        break;
      case 6:
      case 7:
      case 8:
        icon = const Icon(Icons.error_rounded,
            color: GlobalColors.colorEmergency, size: 15);
        break;
      case 9:
        icon = const Icon(Icons.info_rounded,
            color: GlobalColors.colorButton, size: 15);
        break;
      case 10:
        icon = const Icon(Icons.check_circle_rounded,
            color: GlobalColors.colorGreen, size: 15);
        break;
    }
    return icon;
  }
}
