import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';

import '../../data/response/response_transaction.dart';
import '../../domain/entities/model_transaction.dart';
import '../util/global_colors.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import 'provider_service/provider_service_rest.dart';

class ProviderTransaction with ChangeNotifier {
  List<ModelTransaction>? listTransaction = [];
  bool? _contList = false;
  DateTime? _selected = GlobalFunction().dateNow;
  double? _discharge = 0.0;
  double? _income = 0.0;
  String? _month = '';

  String get month => _month!;

  set month(String value) {
    _month = value;
  }

  double get income => _income!;

  set income(double value) {
    _income = value;
  }

  double get discharge => _discharge!;

  set discharge(double value) {
    _discharge = value;
  }

  DateTime get selected => _selected!;

  set selected(DateTime value) {
    _selected = value;
  }

  bool get contList => _contList!;

  set contList(bool value) {
    _contList = value;
  }

  /// Reset selected month
  void resetMonth(BuildContext context) {
    final prServiceRestRead = context.read<ProviderServiceRest>();
    _selected = GlobalFunction().dateNow;
    prServiceRestRead.consultTransaction(context, _selected!);
  }

  /// Add transaction to the list
  void addListTransaction(ResponseTransaction responseTransaction) {
    if (listTransaction!.isNotEmpty) listTransaction!.clear();
    listTransaction!.addAll(responseTransaction.lT!);
    if (listTransaction!.isNotEmpty) {
      _contList = false;
    } else {
      _contList = true;
    }
    notifyListeners();
    calculateDischarge();
    calculateIncome();
  }

  /// Get discharge
  void calculateDischarge() {
    _discharge = 0.0;
    for (int i = 0; i < listTransaction!.length; i++) {
      if (listTransaction![i].iT == 2) {
        _discharge = _discharge! + listTransaction![i].balance!;
      }
    }
    notifyListeners();
  }

  /// Get in come
  void calculateIncome() {
    _income = 0.0;
    for (int i = 0; i < listTransaction!.length; i++) {
      if (listTransaction![i].iT == 1) {
        _income = _income! + listTransaction![i].balance!;
      }
    }
    notifyListeners();
  }

  /// Get date in the format month and year
  void formatMonth() async {
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

  /// Get selected month
  void selectMonth(BuildContext context) {
    final prServiceRestRead = context.read<ProviderServiceRest>();
    showMonthPicker(
            headerColor: GlobalColors.colorButton,
            context: context,
            unselectedMonthTextColor: GlobalColors.colorLetterTitle,
            initialDate: GlobalFunction().dateNow,
            roundedCornersRadius: 20,
            locale: const Locale("es"),
            confirmWidget: const Text(
              GlobalLabel.buttonAccept,
            ),
            selectedMonthBackgroundColor: GlobalColors.colorButton)
        .then((date) {
      if (date != null) {
        _selected = date;
        prServiceRestRead.consultTransaction(context, _selected!);
        formatMonth();
        notifyListeners();
      }
    });
  }
}
