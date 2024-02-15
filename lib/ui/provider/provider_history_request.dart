
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
import 'provider_principal.dart';
import 'provider_service/provider_service_rest.dart';

class ProviderHistoryRequest with ChangeNotifier {
  DateTime? _selected = GlobalFunction().dateNow;
  String? _month = '';
  int? _positionSelectedRequest = 1;
  List<ModelHistoryRequest>? listHistoryRequest = [];
  List<ModelHistoryOrder>? listHistoryOrder = [];
  bool? _contListRequest = false;
  bool? _contListOrder = false;
  int? _typeConsult = 0;


  int get typeConsult => _typeConsult!;

  set typeConsult(int value) {
    _typeConsult = value;
    notifyListeners();
  }

  bool get contListOrder => _contListOrder!;

  set contListOrder(bool value) {
    _contListOrder = value;
  }

  bool get contListRequest => _contListRequest!;

  set contListRequest(bool value) {
    _contListRequest = value;
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

  int get positionSelectedRequest => _positionSelectedRequest!;

  set positionSelectedRequest(int value) {
    _positionSelectedRequest = value;
    notifyListeners();
  }

  /// Consult number of request type travel and order
  consultNumberHistoryRequest(ProviderPrincipal providerPrincipal) {
    // apiInterface!.responseNumberHistoryRequest(providerPrincipal.user.idUser!,
    //     _selected!.year, _selected!.month, _positionSelectedRequest!, (data) {
    //   if (data == null) return;
    //   if (_positionSelectedRequest! == 1) {
    //     apiInterface!.responseHistoryRequest(
    //         providerPrincipal.user.idUser!,
    //         _selected!.year,
    //         _selected!.month,
    //         _positionSelectedRequest!,
    //         0,
    //         data, (code, data) {
    //       addListHistoryRequest(data);
    //       return null;
    //     });
    //   } else {
    //     apiInterface!.responseHistoryOrder(
    //         providerPrincipal.user.idUser!,
    //         _selected!.year,
    //         _selected!.month,
    //         _positionSelectedRequest!,
    //         0,
    //         data, (code, data) {
    //       addListHistoryOrder(data);
    //       return null;
    //     });
    //   }
    //
    //   return null;
    // });
  }

  /// Add request to the list
  addListHistoryRequest(ResponseHistoryRequest responseHistoryRequest) {
    if (listHistoryRequest!.isNotEmpty) listHistoryRequest!.clear();
    listHistoryRequest!.addAll(responseHistoryRequest.lHS!);
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

  /// Reset current date
  resetMonth() {
    _selected = GlobalFunction().dateNow;
  }

  /// Reset selection of filter of type request
  resetSelection()async{
    await Future.delayed(const Duration(milliseconds: 300));
    positionSelectedRequest = 1;
    notifyListeners();
  }

  /// Selected moth
  selectMonth(BuildContext context, int type) {
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
        formatMonth();
        prServiceRestRead.consultNumberHistoryRequest(context);
        notifyListeners();
      }
    });
  }

  /// Get to the date in format month
  formatDateHistory() {
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

  /// Get to the date in format month and year
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

  /// Get total gain
  gainHistory() {
    double totalGain = 0.0;
    if (_positionSelectedRequest == 1) {
      for (ModelHistoryRequest historyRequest in listHistoryRequest!) {
        totalGain = totalGain + historyRequest.payment!;
      }
    } else {
      for (ModelHistoryOrder historyOrder in listHistoryOrder!) {
        totalGain = totalGain + historyOrder.price!;
      }
    }
    return totalGain.toStringAsFixed(2);
  }

  /// Get the state current of the request
  getStateHistory(int stateHistory) {
    String state = '';
    switch (stateHistory) {
      case 0:
        state = GlobalLabel.textRequestPending;
        break;
      case 6:
        state = GlobalLabel.textCanceledClient;
        break;
      case 7:
        state = GlobalLabel.textCanceledDriver;
        break;
      case 8:
        state = GlobalLabel.textCanceledOperator;
        break;
      case 9:
        state = GlobalLabel.textStateOnBoard;
        break;
      case 10:
        state = GlobalLabel.textFinalize;
        break;
    }
    return state;
  }

  /// Clear to list request type travel
  clearListHistoryRequest() {
    listHistoryRequest!.clear();
    notifyListeners();
  }

  /// Clear to list request type order
  clearListHistoryOrder() {
    listHistoryOrder!.clear();
    notifyListeners();
  }

  /// Get the icon of state current of the request
  iconStateRequest(int state) {
    Icon? icon;

    /// 0: Request Pending
    /// 3: Mapped drive
    /// 6: Canceled user
    /// 7: Canceled driver
    /// 8: Canceled call center
    /// 9: Taxi boarded
    /// 10: Request finish
    switch (state) {
      case 0:
      case 3:
        icon = const Icon(Icons.pending_outlined,
            color: GlobalColors.colorButton, size: 15);
        break;
      case 6:
      case 7:
      case 8:
        icon = const Icon(Icons.error_outline,
            color: GlobalColors.colorEmergency, size: 15);
        break;
      case 9:
        icon = const Icon(Icons.info_outlined,
            color: GlobalColors.colorButton, size: 15);
        break;
      case 10:
        icon = const Icon(Icons.check_circle_outline,
            color: GlobalColors.colorGreen, size: 15);
        break;
    }
    return icon;
  }
}
