import 'dart:async';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/model_configuration_app.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_preference.dart';
import 'provider_map.dart';
import 'provider_service/provider_service_rest.dart';
import 'provider_taximeter.dart';

class ProviderConfigurationApp with ChangeNotifier {
  ModelConfigurationApp? _modelConfigurationApp = ModelConfigurationApp();
  List<BluetoothDevice>? _systemDevices = [];
  List<ScanResult>? _scanResults = [];
  List<ScanResult>? _listDispositive = [];
  bool? _stateTaximeterBluetooth = false;
  bool? _statusSearchDispositive = false;
  StreamSubscription<List<ScanResult>>? _scanResultsSubscription;
  StreamSubscription<bool>? _isScanningSubscription;
  StreamSubscription<BluetoothConnectionState>? _connectionStateSubscription;
  StreamSubscription<List<int>>? _lastValueSubscription;
  StreamSubscription<BluetoothAdapterState>? _adapterStateStateSubscription;
  List<BluetoothService>? _services = [];
  BluetoothCharacteristic? _characteristic;
  ScanResult? _taximeterActive;

  ScanResult get taximeterActive => _taximeterActive!;

  set taximeterActive(ScanResult value) {
    _taximeterActive = value;
  }

  StreamSubscription<BluetoothAdapterState> get adapterStateStateSubscription =>
      _adapterStateStateSubscription!;

  set adapterStateStateSubscription(
      StreamSubscription<BluetoothAdapterState> value) {
    _adapterStateStateSubscription = value;
  }

  StreamSubscription<List<int>> get lastValueSubscription =>
      _lastValueSubscription!;

  set lastValueSubscription(StreamSubscription<List<int>> value) {
    _lastValueSubscription = value;
  }

  BluetoothCharacteristic get characteristic => _characteristic!;

  set characteristic(BluetoothCharacteristic value) {
    _characteristic = value;
  }

  List<ScanResult> get listDispositive => _listDispositive!;

  set listDispositive(List<ScanResult> value) {
    _listDispositive = value;
  }

  List<BluetoothService> get services => _services!;

  set services(List<BluetoothService> value) {
    _services = value;
  }

  StreamSubscription<BluetoothConnectionState>
      get connectionStateSubscription => _connectionStateSubscription!;

  set connectionStateSubscription(
      StreamSubscription<BluetoothConnectionState> value) {
    _connectionStateSubscription = value;
  }

  List<ScanResult> get scanResults => _scanResults!;

  set scanResults(List<ScanResult> value) {
    _scanResults = value;
  }

  StreamSubscription<bool> get isScanningSubscription =>
      _isScanningSubscription!;

  set isScanningSubscription(StreamSubscription<bool> value) {
    _isScanningSubscription = value;
  }

  StreamSubscription<List<ScanResult>> get scanResultsSubscription =>
      _scanResultsSubscription!;

  set scanResultsSubscription(StreamSubscription<List<ScanResult>> value) {
    _scanResultsSubscription = value;
  }

  List<BluetoothDevice> get systemDevices => _systemDevices!;

  set systemDevices(List<BluetoothDevice> value) {
    _systemDevices = value;
  }

  bool get statusSearchDispositive => _statusSearchDispositive!;

  set statusSearchDispositive(bool value) {
    _statusSearchDispositive = value;
  }

  bool get stateTaximeterBluetooth => _stateTaximeterBluetooth!;

  set stateTaximeterBluetooth(bool value) {
    _stateTaximeterBluetooth = value;
  }

  ModelConfigurationApp get modelConfigurationApp => _modelConfigurationApp!;

  set modelConfigurationApp(ModelConfigurationApp value) {
    _modelConfigurationApp = value;
  }

  /// Update configuration
  /// Type 1: Route Google
  /// Type 2: Route Waze
  /// Type 3: Route Map
  void updateConfiguration(int type) {
    modelConfigurationApp.routeMap = false;
    modelConfigurationApp.routeWaze = false;
    modelConfigurationApp.routeGoogle = false;
    switch (type) {
      case 1:
        modelConfigurationApp.routeGoogle = true;
        break;
      case 2:
        modelConfigurationApp.routeWaze = true;
        break;
      case 3:
        modelConfigurationApp.routeMap = true;
        break;
    }
    GlobalPreference().setDataConfigurationApp(modelConfigurationApp);
    notifyListeners();
  }

  /// Save play speak chat
  void stateSpeakChat() {
    if (modelConfigurationApp.speakChat!) {
      modelConfigurationApp.speakChat = false;
    } else {
      modelConfigurationApp.speakChat = true;
    }
    GlobalPreference().setDataConfigurationApp(modelConfigurationApp);
    notifyListeners();
  }

  /// Save play speak chat
  void stateHeatMap(BuildContext context) {
    final prMapRead = context.read<ProviderMap>();
    final prServiceRestRead = context.read<ProviderServiceRest>();
    if (modelConfigurationApp.heatMap!) {
      modelConfigurationApp.heatMap = false;
      prMapRead.clearHeatMap();
    } else {
      modelConfigurationApp.heatMap = true;
      prServiceRestRead.consultHeatMap(context);
    }
    GlobalPreference().setDataConfigurationApp(modelConfigurationApp);
    notifyListeners();
  }

  /// Active taximeter external
  void externalTaximeter(BuildContext context) {
    final prTaximeterRead = context.read<ProviderTaximeter>();
    if (modelConfigurationApp.externalTaximeter!) {
      modelConfigurationApp.externalTaximeter = false;
      statusSearchDispositive = false;
      prTaximeterRead.connectedTaximeterExternal = false;
      notifyListeners();
      finishConnection();
      GlobalPreference().setDataConfigurationApp(modelConfigurationApp);
    } else {
      _statusSearchDispositive = true;
      notifyListeners();
      checkBluetooth(context);
    }
  }

  Future<bool> checkBluetooth(BuildContext context) async {
    bool status = false;
    FlutterBluePlus.isSupported.then((state) {
      if (state) {
        _adapterStateStateSubscription =
            FlutterBluePlus.adapterState.listen((state) async {
          if (state == BluetoothAdapterState.on) {
            GlobalFunction().messageAlert(
                context, GlobalLabel.textAlertWaitConnectedTaximeter);
            startScanDispositive(context);
            notifyListeners();
          } else {
            statusSearchDispositive = false;
            finishConnection();
            AppSettings.openAppSettings(type: AppSettingsType.bluetooth);
            notifyListeners();
          }
        });
      } else {
        GlobalFunction().messageAlert(context, GlobalLabel.textNoBluetooth);
        notifyListeners();
      }
    });
    return status;
  }

  void finishConnection() {
    if (_adapterStateStateSubscription != null) {
      _adapterStateStateSubscription!.cancel();
    }
    if (_connectionStateSubscription != null) {
      _connectionStateSubscription!.cancel();
    }
    if (_scanResultsSubscription != null) {
      _scanResultsSubscription!.cancel();
    }
    if (_isScanningSubscription != null) {
      _isScanningSubscription!.cancel();
    }
    if (_lastValueSubscription != null) {
      _lastValueSubscription!.cancel();
    }
    if (_taximeterActive != null) {
      _taximeterActive!.device.disconnect();
    }
    _listDispositive!.clear();
    _modelConfigurationApp!.externalTaximeter = false;
    GlobalPreference().setDataConfigurationApp(modelConfigurationApp);
    notifyListeners();
  }

  void startScanDispositive(BuildContext context) async {
    final prConfigurationAppRead =
        GlobalFunction.context.currentContext!.read<ProviderConfigurationApp>();
    final prTaximeterRead =
        GlobalFunction.context.currentContext!.read<ProviderTaximeter>();
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 3));
      _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
        _scanResults = results;
        notifyListeners();
      }, onError: (error) {
        GlobalFunction().messageAlert(GlobalFunction.context.currentContext!,
            'ERROR SCAN DISPOSITIVE >>>> $error');
      });
      Timer(const Duration(seconds: 4), () async {
        statusSearchDispositive = false;
        _listDispositive!.clear();
        for (ScanResult dispositive in _scanResults!) {
          if (dispositive.device.advName == 'TAXI_METER') {
            _statusSearchDispositive = false;
            _listDispositive!.add(dispositive);
            connectedDispositive(context, dispositive);
            prTaximeterRead.connectedTaximeterExternal = true;
            notifyListeners();
            break;
          }
        }
        if (_listDispositive!.isEmpty &&
            !modelConfigurationApp.externalTaximeter!) {
          GlobalFunction().messageAlert(GlobalFunction.context.currentContext!,
              GlobalLabel.textAlertNotFound);
          _statusSearchDispositive = false;
          prConfigurationAppRead.modelConfigurationApp.externalTaximeter =
              false;
          notifyListeners();
        }
      });
    } catch (e) {
      statusSearchDispositive = false;
      GlobalFunction().messageAlert(
          GlobalFunction.context.currentContext!, 'ERROR START SCAN >>>> $e');
    }
  }

  void connectedDispositive(BuildContext context, ScanResult scanResult) {
    final prTaximeterRead =
        GlobalFunction.context.currentContext!.read<ProviderTaximeter>();
    modelConfigurationApp.externalTaximeter = true;
    GlobalPreference().setDataConfigurationApp(modelConfigurationApp);
    scanResult.device.connect(timeout: const Duration(seconds: 5));
    activeListeningDispositive(scanResult);
    _taximeterActive = scanResult;
    notifyListeners();

    Timer(const Duration(seconds: 2), () async {
      _connectionStateSubscription =
          scanResult.device.connectionState.listen((state) async {
        if (state == BluetoothConnectionState.disconnected) {
          _taximeterActive!.device
              .cancelWhenDisconnected(_lastValueSubscription!);
          finishConnection();
          prTaximeterRead.connectedTaximeterExternal = false;

          GlobalFunction()
              .messageConfirmation(GlobalLabel.textQuestionTaximeter, () {
            GlobalFunction().messageAlert(
                GlobalFunction.context.currentContext!,
                GlobalLabel.textAlertWaitConnectedTaximeter);
            _statusSearchDispositive = true;
            notifyListeners();
            checkBluetooth(context);
          });
        }
      });
    });
  }

  void activeListeningDispositive(ScanResult scanResult) async {
    final prTaximeterRead =
        GlobalFunction.context.currentContext!.read<ProviderTaximeter>();
    Timer(const Duration(seconds: 3), () async {
      try {
        services = await scanResult.device.discoverServices();
        for (var service in services) {
          for (var characteristic in service.characteristics) {
            await characteristic.setNotifyValue(true);
            _lastValueSubscription =
                characteristic.lastValueStream.listen((value) {
              if (value.isEmpty) return;
              prTaximeterRead.readDispositive(
                  value, GlobalFunction().byteListToHex(value));
            });
          }
        }
      } catch (error) {
        if (kDebugMode) {
          print('ERROR LISTENING DISPOSITIVE >>> $error');
        }
      }
    });
  }
}
