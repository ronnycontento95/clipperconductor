import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/model_paymet_hybrid.dart';
import '../../domain/entities/model_request.dart';
import '../../domain/entities/model_user.dart';
import '../util/global_function.dart';
import 'provider_map.dart';
import 'provider_principal.dart';
import 'provider_service/provider_service_rest.dart';
import 'provider_taximeter.dart';

class ProviderPayment with ChangeNotifier {
  String? _paymentPrevious = '0.00';
  int? _initialReviewSlider = 4;
  TextEditingController editPin = TextEditingController();
  TextEditingController editComment = TextEditingController();
  ModelPaymentHybrid? _modelPaymentHybrid;
  String? _costDiscount = '0.00';
  String? _costWallet = '0.00';
  String? _costTip = '0.00';
  String? _costCard = '0.00';
  String? _costCash = '0.00';
  bool? _showDetailHybrid = false;
  bool? _showDetailToll = false;
  bool? _statusErrorCard = false;
  double? _totalCost = 0.00;
  String? _totalDiscount = '0.00';
  String? _subTotal = "0.00";
  String? _totalTravelWithPercentage = '0.00';
  bool? _showPagePayment = false;


  bool get showPagePayment => _showPagePayment!;

  set showPagePayment(bool value) {
    _showPagePayment = value;
  }

  String get totalTravelWithPercentage => _totalTravelWithPercentage!;

  set totalTravelWithPercentage(String value) {
    _totalTravelWithPercentage = value;
  }

  bool get showDetailToll => _showDetailToll!;

  set showDetailToll(bool value) {
    _showDetailToll = value;
    notifyListeners();
  }

  bool get statusErrorCard => _statusErrorCard!;

  set statusErrorCard(bool value) {
    _statusErrorCard = value;
    notifyListeners();
  }

  bool get showDetailHybrid => _showDetailHybrid!;

  set showDetailHybrid(bool value) {
    _showDetailHybrid = value;
    notifyListeners();
  }

  String get subTotal => _subTotal!;

  set subTotal(String value) {
    _subTotal = value;
  }

  String get totalDiscount => _totalDiscount!;

  set totalDiscount(String value) {
    _totalDiscount = value;
  }

  String get costTip => _costTip!;

  set costTip(String value) {
    _costTip = value;
  }

  String get costCard => _costCard!;

  set costCard(String value) {
    _costCard = value;
  }

  String get costCash => _costCash!;

  set costCash(String value) {
    _costCash = value;
  }

  double get totalCost => _totalCost!;

  set totalCost(double value) {
    _totalCost = value;
  }

  String get costDiscount => _costDiscount!;

  set costDiscount(String value) {
    _costDiscount = value;
  }

  String get costWallet => _costWallet!;

  set costWallet(String value) {
    _costWallet = value;
  }

  ModelPaymentHybrid? get modelPaymentHybrid => _modelPaymentHybrid;

  set modelPaymentHybrid(ModelPaymentHybrid? value) {
    if (value != null) {
      _modelPaymentHybrid = value;
    }
  }

  int get initialReviewSlider => _initialReviewSlider!;

  set initialReviewSlider(int value) {
    _initialReviewSlider = value;
    notifyListeners();
  }

  String get paymentPrevious => _paymentPrevious!;

  set paymentPrevious(String value) {
    _paymentPrevious = value;
  }

  /// Cash payment json format
  formatDataPayment(
      BuildContext context,
      ModelUser modelUser,
      ModelRequest modelRequest,
      int numberPassenger,
      double tip,
      double saldoktaxi,
      double cost) {
    final prMapRead = context.read<ProviderMap>();
    final dataRequest = {
      'v': modelUser.idVehicle,
      'u': modelUser.idUser,
      'lt': prMapRead.positionLatitude,
      'lg': prMapRead.positionLongitude,
      'np': numberPassenger,
      'pro': tip,
      'saldo': saldoktaxi,
      's': modelRequest.requestData!.requestId,
      'c': cost
    };

    return dataRequest;
  }

  /// Voucher payment json format
  formatDataPaymentVoucher(
      BuildContext context,
      ModelUser user,
      ModelRequest modelRequest,
      int numberPassenger,
      double tip,
      double saldoktaxi,
      double cost,
      int pin) {
    final prMapRead = context.read<ProviderMap>();
    final dataRequest = {
      'pin': pin,
      'lt': prMapRead.positionLatitude,
      'lg': prMapRead.positionLongitude,
      'c': cost,
      'u': user.idUser,
      'v': user.idVehicle,
      'idS': modelRequest.requestData!.requestId,
      'np': numberPassenger,
      'pro': tip,
      'sal': saldoktaxi,
    };

    return dataRequest;
  }

  /// Reset payment
  void resetPaymentPrevious() {
    _paymentPrevious = '0.00';
    notifyListeners();
  }

  /// Update payment
  void updatePayment(BuildContext context) {
    final prTaximeterRead = context.read<ProviderTaximeter>();
    if (double.parse(paymentPrevious.toString()) == 0) return;
    // if (prTaximeterRead.connectedTaximeterExternal) {
    //   prTaximeterRead.priceTotalExternal = paymentPrevious;
    // }
    prTaximeterRead.priceTotal = paymentPrevious;
    prTaximeterRead.priceUpdate = true;
    notifyListeners();
    calculatePaymentHybrid();
  }

  void resetVariablePayment() {
    _costDiscount = '0.00';
    _costWallet = '0.00';
    _costTip = '0.00';
    _costCard = '0.00';
    _costCash = '0.00';
    _totalCost = 0.00;
    _statusErrorCard = false;
    _showDetailHybrid = false;
    _showDetailToll = false;
    notifyListeners();
  }

  void calculatePaymentHybrid() async {
    final prTaximeterRead =
        GlobalFunction.context.currentContext!.read<ProviderTaximeter>();
    final prPrincipalRead =
        GlobalFunction.context.currentContext!.read<ProviderPrincipal>();
    await Future.delayed(const Duration(milliseconds: 300));
    resetVariablePayment();
    _totalCost = double.parse(prTaximeterRead.connectedTaximeterExternal
        ? prTaximeterRead.priceTotalStreet
        : prTaximeterRead.priceTotal);

    if (_modelPaymentHybrid == null) return;
    if (_modelPaymentHybrid!.discount != null &&
        _modelPaymentHybrid!.discount!.isNotEmpty) {
      if (_modelPaymentHybrid!.discount![0].typeDiscount == 30) {
        _costDiscount =
            '${_modelPaymentHybrid!.discount![0].discountPercentage}';

        if (prPrincipalRead.modelRequestActive!.requestData != null) {
          if (prPrincipalRead
              .modelRequestActive!.requestData!.destination!.isNotEmpty) {
            if (prPrincipalRead
                    .modelRequestActive!.requestData!.destination![0].isBid ==
                0) {
              _totalTravelWithPercentage = ((prPrincipalRead.modelRequestActive!
                              .requestData!.destination![0].desC! -
                          prPrincipalRead
                              .modelRequestActive!.requestData!.toll!) *
                      modelPaymentHybrid!.discount![0].discountPercentage! /
                      100)
                  .toStringAsFixed(2);
            } else {
              _totalTravelWithPercentage = ((prPrincipalRead.modelRequestActive!
                              .requestData!.destination![0].cost! -
                          prPrincipalRead
                              .modelRequestActive!.requestData!.toll!) *
                      modelPaymentHybrid!.discount![0].discountPercentage! /
                      100)
                  .toStringAsFixed(2);
            }
          }
        }

        _totalCost = _totalCost! -
            (double.parse(((double.parse(
                            prTaximeterRead.connectedTaximeterExternal
                                ? prTaximeterRead.priceTotalStreet
                                : prTaximeterRead.priceTotal) -
                        prPrincipalRead
                            .modelRequestActive!.requestData!.toll!) *
                    modelPaymentHybrid!.discount![0].discountPercentage! /
                    100)
                .toStringAsFixed(2)));
      } else {
        _costDiscount = '${_modelPaymentHybrid!.discount![0].discountFixed}';
        _totalCost = _totalCost! -
            double.parse(_modelPaymentHybrid!.discount![0].discountFixed!);
      }
      notifyListeners();
    }

    if (_modelPaymentHybrid!.tip != null &&
        double.parse(_modelPaymentHybrid!.tip!.tip!) > 0.00) {
      _totalCost = _totalCost! + double.parse(_modelPaymentHybrid!.tip!.tip!);
      _costTip = _modelPaymentHybrid!.tip!.tip!;
      notifyListeners();
    }

    if (_totalCost! <=
        double.parse(_modelPaymentHybrid!.balance != null
            ? _modelPaymentHybrid!.balance!
            : '0.00')) {
      _costWallet = _totalCost!.toStringAsFixed(2);
    } else {
      _costWallet = _modelPaymentHybrid!.balance;

      if (_modelPaymentHybrid!.card != null) {
        double costCard = double.parse(
            (_totalCost! - double.parse(_modelPaymentHybrid!.balance!))
                .toStringAsFixed(2));
        _costCard = costCard.toString();
        if (costCard < double.parse(_modelPaymentHybrid!.card!.min!)) {
          _costCash = costCard.toString();
        }
      } else {
        _costCash = (_totalCost! - double.parse(_modelPaymentHybrid!.balance!))
            .toStringAsFixed(2);
      }
    }

    if (modelPaymentHybrid!.discount != null &&
        modelPaymentHybrid!.discount!.isNotEmpty &&
        modelPaymentHybrid!.discount![0].typeDiscount == 30) {
      double percent = 0.00;
      percent = double.parse(((double.parse(
                      prTaximeterRead.connectedTaximeterExternal
                          ? prTaximeterRead.priceTotalStreet
                          : prTaximeterRead.priceTotal) -
                  prPrincipalRead.modelRequestActive!.requestData!.toll!) *
              modelPaymentHybrid!.discount![0].discountPercentage! /
              100)
          .toStringAsFixed(2));
      _subTotal = ((double.parse(prTaximeterRead.connectedTaximeterExternal
                      ? prTaximeterRead.priceTotalStreet
                      : prTaximeterRead.priceTotal) +
                  double.parse(costTip)) -
              percent)
          .toStringAsFixed(2);
    } else {
      _subTotal = ((double.parse(prTaximeterRead.connectedTaximeterExternal
                      ? prTaximeterRead.priceTotalStreet
                      : prTaximeterRead.priceTotal) +
                  double.parse(costTip)) -
              double.parse(costDiscount))
          .toStringAsFixed(2);
    }

    if (modelPaymentHybrid!.card != null &&
        (double.parse(costCard) <
            double.parse(modelPaymentHybrid!.card!.min!))) {
      _statusErrorCard = true;
    } else {
      _statusErrorCard = false;
    }

    notifyListeners();
  }

  void saveDayStatistics(BuildContext context) {
    final prServiceRestRead = context.read<ProviderServiceRest>();
    final prTaximeterRead = context.read<ProviderTaximeter>();
    final prPrincipalRead = context.read<ProviderPrincipal>();
    prServiceRestRead.sendSaveDayStatistics(prTaximeterRead.distanceTraveled,
        '${GlobalFunction().differentHour(prPrincipalRead.modelRequestActive!.requestData!.hour!, GlobalFunction().hour.format(GlobalFunction().dateNow))}');
  }

  void updateStateViewPage(bool status) {
    _showPagePayment = status;
  }
}
