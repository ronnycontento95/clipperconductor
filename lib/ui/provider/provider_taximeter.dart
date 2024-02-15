import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/model_taximeter.dart';
import '../util/bluetooth/data_taximeter.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import 'provider_map.dart';
import 'provider_payment.dart';
import 'provider_principal.dart';
import 'provider_service/provider_service_rest.dart';
import 'provider_service/provider_service_socket.dart';

class ProviderTaximeter with ChangeNotifier {
  ModelTaximeter? _taximeter = ModelTaximeter();
  String? _unitMeasure = GlobalLabel.textMeter;
  bool? _connectedTaximeterExternal = false;
  bool? _statusRunTaximeter = false;
  Timer? _timerTaximeter;
  bool? _priceUpdate = false;
  List<int>? _listCharacteristic = [];
  bool? _needCombination = true;
  bool? _stateActiveTaximeter = false;
  DataTaximeter? _dataTaximeter = DataTaximeter();
  bool? _statusRecoverTaximeter = false;

  /// Taximeter normal
  String? _priceStart = '0.00';
  String? _priceTotal = '0.00';
  int? _secondWait = 0;
  String? _timeTotalWait = '00:00:00';
  double? _distanceTraveled = 0.0;
  double? _distanceTracking = 0.0;

  double? _costTimeWait = 0.0;
  double? _costDistance = 0.0;
  double? _kilometerTime = 0.0;
  double? _priceTime = 0.0;

  /// Taximeter external
  int? _velocityExternal = 0;
  String? _timeTotalWaitExternal = '00:00:00';
  String? _hourStartExternal = '00:00:00';
  String? _hourEndExternal = '00:00:00';
  String? _timeTotalTravelExternal = '00:00:00';
  int? _distanceTraveledExternal = 0;

  double? _costTimeWaitExternal = 0.0;
  double? _costDistanceExternal = 0.0;

  /// Taximeter street
  String? _priceTotalStreet = '0.00';

  bool get stateActiveTaximeter => _stateActiveTaximeter!;

  set stateActiveTaximeter(bool value) {
    _stateActiveTaximeter = value;
  }

  bool get statusRecoverTaximeter => _statusRecoverTaximeter!;

  set statusRecoverTaximeter(bool value) {
    _statusRecoverTaximeter = value;
  }

  String get timeTotalTravelExternal => _timeTotalTravelExternal!;

  set timeTotalTravelExternal(String value) {
    _timeTotalTravelExternal = value;
  }

  String get hourEndExternal => _hourEndExternal!;

  set hourEndExternal(String value) {
    _hourEndExternal = value;
  }

  String get hourStartExternal => _hourStartExternal!;

  set hourStartExternal(String value) {
    _hourStartExternal = value;
  }

  DataTaximeter get dataTaximeter => _dataTaximeter!;

  set dataTaximeter(DataTaximeter value) {
    _dataTaximeter = value;
  }

  String get priceTotalStreet => _priceTotalStreet!;

  set priceTotalStreet(String value) {
    _priceTotalStreet = value;
    notifyListeners();
  }

  int get velocityExternal => _velocityExternal!;

  set velocityExternal(int value) {
    _velocityExternal = value;
  }

  int get secondWait => _secondWait!;

  set secondWait(int value) {
    _secondWait = value;
  }

  double get costDistance => _costDistance!;

  set costDistance(double value) {
    _costDistance = value;
  }

  double get kilometerTime => _kilometerTime!;

  set kilometerTime(double value) {
    _kilometerTime = value;
  }

  double get priceTime => _priceTime!;

  set priceTime(double value) {
    _priceTime = value;
  }

  String get timeTotalWaitExternal => _timeTotalWaitExternal!;

  set timeTotalWaitExternal(String value) {
    _timeTotalWaitExternal = value;
  }

  int get distanceTraveledExternal => _distanceTraveledExternal!;

  set distanceTraveledExternal(int value) {
    _distanceTraveledExternal = value;
  }

  double get costTimeWaitExternal => _costTimeWaitExternal!;

  set costTimeWaitExternal(double value) {
    _costTimeWaitExternal = value;
  }

  double get costDistanceExternal => _costDistanceExternal!;

  set costDistanceExternal(double value) {
    _costDistanceExternal = value;
  }

  Timer get timerTaximeter => _timerTaximeter!;

  set timerTaximeter(Timer value) {
    _timerTaximeter = value;
  }

  bool get connectedTaximeterExternal => _connectedTaximeterExternal!;

  set connectedTaximeterExternal(bool value) {
    _connectedTaximeterExternal = value;
  }

  bool get priceUpdate => _priceUpdate!;

  set priceUpdate(bool value) {
    _priceUpdate = value;
  }

  String get timeTotalWait => _timeTotalWait!;

  set timeTotalWait(String value) {
    _timeTotalWait = value;
  }

  double get costTimeWait => _costTimeWait!;

  set costTimeWait(double value) {
    _costTimeWait = value;
  }

  String get priceTotal => _priceTotal!;

  set priceTotal(String value) {
    _priceTotal = value;
    notifyListeners();
  }

  ModelTaximeter get taximeter => _taximeter!;

  set taximeter(ModelTaximeter value) {
    _taximeter = value;
    notifyListeners();
  }

  String get priceStart => _priceStart!;

  set priceStart(String value) {
    _priceStart = value;
    notifyListeners();
  }

  String get unitMeasure => _unitMeasure!;

  set unitMeasure(String value) {
    _unitMeasure = value;
  }

  double get distanceTraveled => _distanceTraveled!;

  set distanceTraveled(double value) {
    _distanceTraveled = value;
  }

  double get distanceTracking => _distanceTracking!;

  set distanceTracking(double value) {
    _distanceTracking = value;
  }

  bool get statusRunTaximeter => _statusRunTaximeter!;

  set statusRunTaximeter(bool value) {
    _statusRunTaximeter = value;
  }

  /// Reset variable taximeter
  /// The taximeter variables are reset to their initial values
  void resetVariable() async {
    await Future.delayed(const Duration(seconds: 1));
    _statusRecoverTaximeter = false;
    _distanceTraveled = 0.0;
    _distanceTracking = 0.0;
    _priceStart = '0.00';
    _priceTotal = '0.00';
    _secondWait = 0;
    _timeTotalWait = '00:00:00';
    _costDistance = 0.00;
    _costTimeWait = 0.00;
    _unitMeasure = GlobalLabel.textMeter;

    _timeTotalWaitExternal = '00:00:00';
    _distanceTraveledExternal = 0;
    _costTimeWaitExternal = 0.00;
    _costDistanceExternal = 0.00;
  }

  /// Value initial taximeter
  /// Approximate 0: Fixed rate
  /// Approximate 1: Variable rate
  /// The initial values of the taximeter are set
  void activeValueInitialTaximeter(BuildContext context, int typeConsult) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    if (_taximeter!.approximate! > 0) {
      if (typeConsult == 2) return;
      _priceStart = GlobalFunction().checkHourDay()
          ? _taximeter!.aD!.toStringAsFixed(2)
          : _taximeter!.aN!.toStringAsFixed(2);
    } else {
      if (prPrincipalRead
          .modelRequestActive!.requestData!.destination!.isNotEmpty) {
        if (prPrincipalRead
                .modelRequestActive!.requestData!.destination![0].isBid ==
            1) {
          if (prPrincipalRead.modelRequestActive!.requestData!.paymentType ==
              9) {
            _priceStart = prPrincipalRead
                .modelRequestActive!.requestData!.destination![0].cost!
                .toStringAsFixed(2);
          } else {
            _priceStart = (prPrincipalRead.modelRequestActive!.requestData!
                        .destination![0].cost! +
                    prPrincipalRead.modelRequestActive!.requestData!.tip!)
                .toStringAsFixed(2);
          }
        } else {
          if (prPrincipalRead.modelRequestActive!.requestData!.paymentType ==
              9) {
            _priceStart = prPrincipalRead
                .modelRequestActive!.requestData!.destination![0].desC!
                .toStringAsFixed(2);
          } else {
            _priceStart = (prPrincipalRead.modelRequestActive!.requestData!
                        .destination![0].desC! +
                    prPrincipalRead.modelRequestActive!.requestData!.tip!)
                .toStringAsFixed(2);
          }
        }
      } else {
        _priceStart = GlobalFunction().checkHourDay()
            ? _taximeter!.cD!.toStringAsFixed(2)
            : _taximeter!.cN!.toStringAsFixed(2);
      }
    }
  }

  /// Reset timer taximeter
  /// The taximeter timer is reset
  void resetTaximeter() {
    if (_timerTaximeter != null) {
      _timerTaximeter!.cancel();
      _timerTaximeter = null;
    }
  }

  /// Active taximeter
  /// TypeConsult 1: Accepted request
  /// TypeConsult 2: Recovered taximeter
  /// The taximeter is initialized depending on the type entered. Whether it is an initialization or a recovery
  void startTaximeter(BuildContext context, double totalDistanceTravel) {
    final prMapWatch = context.read<ProviderMap>();
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prServiceRestRead =
        GlobalFunction.context.currentContext!.read<ProviderServiceRest>();
    final prTaximeterRead =
        GlobalFunction.context.currentContext!.read<ProviderTaximeter>();

    double priceStartTime =
        GlobalFunction().checkHourDay() ? _taximeter!.aD! : _taximeter!.aN!;
    double priceMinimumTime =
        GlobalFunction().checkHourDay() ? _taximeter!.minD! : _taximeter!.minN!;
    _priceTime =
        GlobalFunction().checkHourDay() ? _taximeter!.cD! : _taximeter!.cN!;

    _kilometerTime =
        GlobalFunction().checkHourDay() ? _taximeter!.kmD! : _taximeter!.kmN!;
    double latitudeOnBoard = 0.0;
    double longitudeOnBoard = 0.0;
    double totalDistance = 0.0;
    if (!_statusRecoverTaximeter!) {
      latitudeOnBoard =
          prPrincipalRead.modelRequestActive!.requestData!.latitudeOnBoard!;
      longitudeOnBoard =
          prPrincipalRead.modelRequestActive!.requestData!.longitudeOnBoard!;
    } else {
      latitudeOnBoard = prMapWatch.positionLatitude;
      longitudeOnBoard = prMapWatch.positionLongitude;
    }
    totalDistance = totalDistanceTravel;
    resetTaximeter();

    if (_taximeter!.approximate! > 0) {
      _timerTaximeter =
          Timer.periodic(const Duration(seconds: 1), (timer) async {
        if ((prMapWatch.positionLatitude == 0.0 &&
                prMapWatch.positionLongitude == 0.0) ||
            latitudeOnBoard == 0.0 && longitudeOnBoard == 0.0) return;

        double newDistance = 0.00;
        if (prMapWatch.positionSpeed > 2) {
          newDistance = GlobalFunction().calculateDistance(
            latitudeOnBoard,
            longitudeOnBoard,
            prMapWatch.positionLatitude,
            prMapWatch.positionLongitude,
          );
        }
        totalDistance += newDistance;
        if (prMapWatch.positionSpeed < 1) {
          _secondWait = _secondWait! + 1;
          convertSecond(_secondWait!);
          _costTimeWait = (_secondWait! * priceMinimumTime) / 60;
          if (prPrincipalRead.modelRequestActive!.requestData != null &&
              prPrincipalRead.modelRequestActive!.statusDriver! == 5) {
            prServiceRestRead.sendWaitTime(prTaximeterRead.timeTotalWait);
          }
        }
        _timeTotalWait = convertSecond(_secondWait!);
        calculateCostDistance(1, priceStartTime, totalDistance, _kilometerTime!,
            _costTimeWait!, 0.0);

        latitudeOnBoard = prMapWatch.positionLatitude;
        longitudeOnBoard = prMapWatch.positionLongitude;
      });
    } else {
      if (prPrincipalRead
          .modelRequestActive!.requestData!.destination!.isNotEmpty) {
        if (prPrincipalRead
                .modelRequestActive!.requestData!.destination![0].isBid ==
            0) {
          _priceTotal = (prPrincipalRead.modelRequestActive!.requestData!
                              .destination![0].desC! +
                          prPrincipalRead.modelRequestActive!.requestType! !=
                      9
                  ? prPrincipalRead.modelRequestActive!.requestData!.tip!
                  : 0)
              .toStringAsFixed(2);
        } else {
          _priceTotal = (prPrincipalRead.modelRequestActive!.requestData!
                              .destination![0].cost! +
                          prPrincipalRead.modelRequestActive!.requestType! !=
                      9
                  ? prPrincipalRead.modelRequestActive!.requestData!.tip!
                  : 0)
              .toStringAsFixed(2);
        }
      } else {
        _priceTotal = GlobalFunction().checkHourDay()
            ? _taximeter!.cD!.toStringAsFixed(2)
            : _taximeter!.cN!.toStringAsFixed(2);
      }
    }
  }

  /// Calculate cost distance
  /// Calculates the value to be charged and displayed on the taximeter depending on the distance traveled and the value per distance
  /// TypeConsult 1: Active taximeter
  /// TypeConsult 2: Recovery taximeter
  void calculateCostDistance(
      int typeConsult,
      double priceStartTime,
      double distance,
      double kilometerTime,
      double costTimeWait,
      double recoverValueTaximeter) {
    _distanceTracking = distance;
    if (distance > 1000) {
      _unitMeasure = GlobalLabel.textKilometer;
      _distanceTraveled =
          double.parse((distance / 1000).toStringAsFixed(2).toString());
    } else {
      _unitMeasure = GlobalLabel.textMeter;
      _distanceTraveled = double.parse(distance.toStringAsFixed(2));
    }
    _costDistance = ((distance * kilometerTime) / 1000);

    if (connectedTaximeterExternal) {
      _costDistanceExternal =
          ((_distanceTraveledExternal! * kilometerTime) / 1000);
    }

    if (!connectedTaximeterExternal) {
      _priceStart =
          (priceStartTime + costTimeWait + _costDistance!).toStringAsFixed(2);
    }
    notifyListeners();
  }

  /// Set price total
  /// Type Edit 0: No edit
  /// Type Edit 1: Yes edit
  /// Set the value to be charged in the variable to display in the payment view
  void setPriceTotal(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    if (!_priceUpdate!) {
      if (double.parse(_priceStart!) >= _priceTime!) {
        if (prPrincipalRead.modelRequestActive!.requestData != null) {
          if (prPrincipalRead.modelRequestActive!.requestData!.paymentType ==
              9) {
            _priceTotal = double.parse(_priceStart!).toStringAsFixed(2);
          } else {
            _priceTotal = (double.parse(_priceStart!) +
                    prPrincipalRead.modelRequestActive!.requestData!.tip!)
                .toStringAsFixed(2);
          }
        } else {
          _priceTotal = _priceStart;
        }
      } else {
        if (prPrincipalRead.modelRequestActive!.requestData != null) {
          if (prPrincipalRead.modelRequestActive!.requestData!.paymentType ==
              9) {
            _priceTotal = _priceTime!.toStringAsFixed(2);
          } else {
            _priceTotal = (_priceTime! +
                    prPrincipalRead.modelRequestActive!.requestData!.tip!)
                .toStringAsFixed(2);
          }
        } else {
          _priceTotal = _priceTime!.toStringAsFixed(2);
        }
      }
    }
    notifyListeners();
  }

  /// Convert second to hour and minute
  /// Convert hours to minutes and seconds
  String convertSecond(int totalSecond) {
    int hour = totalSecond ~/ 3600;
    int min = (totalSecond % 3600) ~/ 60;
    int sec = totalSecond % 60;
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    String hours = hour.toString().length <= 1 ? "0$hour" : "$hour";
    return '$hours:$minute:$second';
  }

  /// Get distance total
  /// Reset the taximeter values after recovering the taximeter values
  void loadDistance(BuildContext context, double distance, String waitTime,
      double recoverValueTaximeter) {
    double priceMinimumTime =
        GlobalFunction().checkHourDay() ? _taximeter!.minD! : _taximeter!.minN!;

    _secondWait = int.parse(waitTime.split(':')[0]) * 3600 +
        int.parse(waitTime.split(':')[1]) * 60 +
        int.parse(waitTime.split(':')[2]);
    // convertSecond(_secondWait!);
    _costTimeWait = (_secondWait! * priceMinimumTime) / 60;
    _timeTotalWait = convertSecond(_secondWait!);
    _statusRecoverTaximeter = true;
    notifyListeners();

    calculateCostDistance(
        2,
        GlobalFunction().checkHourDay() ? _taximeter!.aD! : _taximeter!.aN!,
        double.parse(distance.toStringAsFixed(2)),
        GlobalFunction().checkHourDay() ? _taximeter!.kmD! : _taximeter!.kmN!,
        _costTimeWait!,
        recoverValueTaximeter);
    startTaximeter(context, distance);
  }

  void setPaymentRequest(BuildContext context) {
    final prPaymentRead = context.read<ProviderPayment>();
    _priceUpdate = false;
    setPriceTotal(context);
    prPaymentRead.paymentPrevious = '0.00';
    prPaymentRead.calculatePaymentHybrid();
    notifyListeners();
  }

  /// Taximeter external
  readDispositive(List<int> data, String result) async {
    final prServiceSocketRead =
        GlobalFunction.context.currentContext!.read<ProviderServiceSocket>();
    final prPrincipalRead =
        GlobalFunction.context.currentContext!.read<ProviderPrincipal>();

    if (result.startsWith("02c1") ||
        result.startsWith("02b4") ||
        result.startsWith("02c2")) {
      if (result.endsWith("0310")) {
        _listCharacteristic = data;
        _needCombination = false;
      } else {
        _listCharacteristic = data;
        return;
      }
    } else if (_listCharacteristic == null) {
      return;
    }

    try {
      if (_needCombination!) {
        _listCharacteristic = [...?_listCharacteristic, ...data];
      }
      String? dataHexStr = GlobalFunction().byteListToHex(_listCharacteristic!);

      if ((dataHexStr.startsWith("02c1") || dataHexStr.startsWith("02b4")) &&
          dataHexStr.endsWith("0310")) {
        _dataTaximeter = parseCh1B4hData(_listCharacteristic!);
        _statusRunTaximeter = false;
        _listCharacteristic!.clear();
        _dataTaximeter!.mode =
            dataHexStr.startsWith("02c1") ? "VACANT" : "STOP";
        if (_stateActiveTaximeter! && prPrincipalRead.stateTaximeterStreet) {
          prServiceSocketRead
              .activePayment(GlobalFunction.context.currentContext!);
        }
        updateStateActiveTaximeter(false);
        notifyListeners();
      } else if (dataHexStr.startsWith("02c2") && dataHexStr.endsWith("0310")) {
        _dataTaximeter = parseC2hData(_listCharacteristic!);
        _dataTaximeter!.mode = 'OCCUPIED';
        _statusRunTaximeter = true;

        if (!_stateActiveTaximeter! &&
            prPrincipalRead.modelRequestActive!.requestData != null) {
          if (prPrincipalRead.modelRequestActive!.statusDriver != 5) {
            if (prPrincipalRead.modelRequestActive!.requestData!.advice! == 0) {
              prServiceSocketRead
                  .sendArrived(GlobalFunction.context.currentContext!);
              prPrincipalRead.modelRequestActive!.requestData!.advice = 1;
            }

            prServiceSocketRead
                .actionButtonRequest(GlobalFunction.context.currentContext!);
          }
          prPrincipalRead.stateTaximeterStreet = true;
          updateStateActiveTaximeter(true);
        } else if (!_stateActiveTaximeter!) {
          prPrincipalRead.stateTaximeterStreet = true;
          updateStateActiveTaximeter(true);
        }
        _listCharacteristic!.clear();
        notifyListeners();
      }
    } catch (error) {
      if (kDebugMode) {
        print('ERROR READ DISPOSITIVE >>> ${error.toString()}');
      }
    }
  }

  void updateStateActiveTaximeter(bool state) {
    _stateActiveTaximeter = state;
    notifyListeners();
  }

  parseCh1B4hData(List<int> data) {
    Uint8List codeCharacteristics = Uint8List.fromList(data);
    ByteData buffer = ByteData.view(codeCharacteristics.buffer);
    DataTaximeter vo = DataTaximeter();
    final prPrincipalRead =
        GlobalFunction.context.currentContext!.read<ProviderPrincipal>();
    try {
      int offset = 6;

      vo.dateTime = buffer.getInt32(offset);
      offset += 4;

      vo.meterSerial = String.fromCharCodes(data.sublist(offset, offset + 4));
      offset += 4;

      vo.passengerOnBoardTime = buffer.getInt32(offset);
      offset += 4;

      vo.passengerExitTime = buffer.getInt32(offset);
      offset += 4;

      vo.passengerTravelDistance = buffer.getInt32(offset);
      offset += 4;

      vo.passengerTravelTime = buffer.getInt16(offset).toUnsigned(16);
      offset += 2;

      vo.passengerWaitTime = buffer.getInt16(offset).toUnsigned(16);
      offset += 2;

      vo.totalFare = buffer.getInt16(offset).toUnsigned(16);
      offset += 2;

      vo.lastReceivedTime = DateTime.now().millisecondsSinceEpoch;

      _velocityExternal = vo.carSpeed;
      _priceTotalStreet = (int.parse(codeCharacteristics[35].toString()) / 100)
          .toStringAsFixed(2);

      _hourStartExternal = convertSecond(vo.passengerOnBoardTime!);
      _hourEndExternal = convertSecond(vo.passengerExitTime!);
      notifyListeners();
      if (prPrincipalRead.modelRequestActive!.requestData != null &&
          prPrincipalRead.modelRequestActive!.statusDriver == 5 &&
          !statusRunTaximeter) {
        _priceStart = priceTotalStreet;
      }
    } catch (e) {
      rethrow;
    }
    return vo;
  }

  parseC2hData(List<int> data) {
    Uint8List codeCharacteristics = Uint8List.fromList(data);
    ByteData buffer = ByteData.view(codeCharacteristics.buffer);

    DataTaximeter vo = DataTaximeter();

    try {
      int offset = 6;

      vo.dateTime = buffer.getInt32(offset);
      offset += 4;

      vo.meterSerial = String.fromCharCodes(data.sublist(offset, offset + 4));
      offset += 4;

      offset = 26;
      vo.passengerTravelDistance = buffer.getInt32(offset);
      offset += 4;

      vo.passengerTravelTime = buffer.getInt16(offset).toUnsigned(16);
      offset += 2;

      vo.passengerWaitTime = buffer.getInt16(offset).toUnsigned(16);
      offset += 2;

      vo.totalFare = buffer.getInt16(offset).toUnsigned(16);
      offset += 2;

      vo.lastReceivedTime = DateTime.now().millisecondsSinceEpoch;
    } catch (e) {
      rethrow;
    }
    _velocityExternal = vo.carSpeed;
    _priceStart = (vo.totalFare! / 100).toStringAsFixed(2);
    _timeTotalWaitExternal = convertSecond(vo.passengerWaitTime!);
    _timeTotalTravelExternal = convertSecond(vo.passengerTravelTime!);
    _distanceTraveledExternal = vo.passengerTravelDistance;
    notifyListeners();
    return vo;
  }
}
