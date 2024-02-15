import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../data/response/response_eventuality.dart';
import '../../data/response/response_request.dart';
import '../../domain/entities/model_configuration_app.dart';
import '../../domain/entities/model_configuration_driver.dart';
import '../../domain/entities/model_dispositive.dart';
import '../../domain/entities/model_request.dart';
import '../../domain/entities/model_user.dart';
import '../../domain/entities/model_eventuality.dart';
import '../page/page_closing_session.dart';
import '../page/page_progress_postulation.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_preference.dart';
import 'provider_chat_request.dart';
import 'provider_configuration_app.dart';
import 'provider_map.dart';
import 'provider_payment.dart';
import 'provider_service/provider_service_rest.dart';
import 'provider_service/provider_service_socket.dart';
import 'provider_taximeter.dart';
import 'provider_walkies_talkie.dart';

class ProviderPrincipal with ChangeNotifier {
  ModelUser? _modelUser = ModelUser();
  ModelDispositive? _modelDispositive = ModelDispositive();
  ModelRequest? _modelRequestActive = ModelRequest();
  ModelRequest? _modelRequestPostulation = ModelRequest();
  List<ModelConfigurationDriver>? listConfigurationDriver = [];
  String? _timeCurrentPostulation = GlobalLabel.timePostulation;
  bool? _stateService = false;
  bool? _stateTracking = false;
  List<ModelRequest>? listModelRequest = [];
  int? _countNotification = 0;
  String? _nameMoney = '';
  int? _numberRequest = 0;
  double? _gainDay = 0.0;
  String? _dateServer = '';
  double? _qualificationDriver = 0.0;
  Timer? _timePostulation;
  int? _countChat = 0;
  String? _labelNameButtonRequest = '';
  bool? _showNavigatorRoute = false;
  bool? _stateStreetRequest = false;
  bool? _sharedTravel = false;
  String? _messageStateRequest = GlobalLabel.textStranger;
  bool? _stateWalkiesTalkie = false;
  bool? _stateCodeReferred = false;
  bool? _stateVerifyIdentity = false;
  bool? _sendPostulation = false;
  bool? _sendPreviewPostulation = false;
  List<ModelEventuality>? listEventuality = [];
  bool _statusWakelock = true;
  Timer? _timerChronometer;
  String? _chronometer = '0:00';
  bool? _stateInternet = true;
  bool? _stateShowButtonPayment = false;
  bool? _stateShowButtonPaymentHybrid = false;
  bool? _stateShowButtonPaymentStreet = false;
  String? _timeConnection = '00:00';
  double? _distanceConnection = 0.00;
  double? _costBid = 0.00;
  bool? _proximityNotice = false;
  bool? _stateTaximeterStreet = false;
  GoogleMapController? _mapController;
  Map<MarkerId, Marker>? markers = {};
  BitmapDescriptor? iconDetailOrigin;
  BitmapDescriptor? iconDetailVehicle;
  bool? _showListRequest = false;
  bool? _showGainDay = true;
  bool? _showProfile = false;
  bool? _showVerifyVersion = false;
  bool? _statusHasPermissionBubble = false;
  bool? _statusIsGrantedBubble = false;

  bool get statusHasPermissionBubble => _statusHasPermissionBubble!;

  set statusHasPermissionBubble(bool value) {
    _statusHasPermissionBubble = value;
  }

  bool get statusIsGrantedBubble => _statusIsGrantedBubble!;

  set statusIsGrantedBubble(bool value) {
    _statusIsGrantedBubble = value;
  }

  bool get stateVerifyIdentity => _stateVerifyIdentity!;

  set stateVerifyIdentity(bool value) {
    _stateVerifyIdentity = value;
  }

  bool get showVerifyVersion => _showVerifyVersion!;

  set showVerifyVersion(bool value) {
    _showVerifyVersion = value;
  }

  bool get showProfile => _showProfile!;

  set showProfile(bool value) {
    _showProfile = value;
  }

  bool get showGainDay => _showGainDay!;

  set showGainDay(bool value) {
    _showGainDay = value;
  }

  bool get stateCodeReferred => _stateCodeReferred!;

  set stateCodeReferred(bool value) {
    _stateCodeReferred = value;
  }

  bool get showListRequest => _showListRequest!;

  set showListRequest(bool value) {
    _showListRequest = value;
  }

  GoogleMapController get mapController => _mapController!;

  set mapController(GoogleMapController value) {
    _mapController = value;
  }

  bool get stateShowButtonPaymentStreet => _stateShowButtonPaymentStreet!;

  set stateShowButtonPaymentStreet(bool value) {
    _stateShowButtonPaymentStreet = value;
    notifyListeners();
  }

  bool get stateTaximeterStreet => _stateTaximeterStreet!;

  set stateTaximeterStreet(bool value) {
    _stateTaximeterStreet = value;
    notifyListeners();
  }

  bool get proximityNotice => _proximityNotice!;

  set proximityNotice(bool value) {
    _proximityNotice = value;
    notifyListeners();
  }

  double get costBid => _costBid!;

  set costBid(double value) {
    _costBid = value;
    notifyListeners();
  }

  double get distanceConnection => _distanceConnection!;

  set distanceConnection(double value) {
    _distanceConnection = value;
  }

  String get timeConnection => _timeConnection!;

  set timeConnection(String value) {
    _timeConnection = value;
  }

  bool get stateShowButtonPaymentHybrid => _stateShowButtonPaymentHybrid!;

  set stateShowButtonPaymentHybrid(bool value) {
    _stateShowButtonPaymentHybrid = value;
    notifyListeners();
  }

  bool get stateShowButtonPayment => _stateShowButtonPayment!;

  set stateShowButtonPayment(bool value) {
    _stateShowButtonPayment = value;
    notifyListeners();
  }

  bool get stateInternet => _stateInternet!;

  set stateInternet(bool value) {
    _stateInternet = value;
    notifyListeners();
  }

  String get chronometer => _chronometer!;

  set chronometer(String value) {
    _chronometer = value;
  }

  bool get statusWakelock => _statusWakelock;

  set statusWakelock(bool value) {
    _statusWakelock = value;
    notifyListeners();
  }

  bool get sendPreviewPostulation => _sendPreviewPostulation!;

  set sendPreviewPostulation(bool value) {
    _sendPreviewPostulation = value;
  }

  bool get sendPostulation => _sendPostulation!;

  set sendPostulation(bool value) {
    _sendPostulation = value;
  }

  String get messageStateRequest => _messageStateRequest!;

  set messageStateRequest(String value) {
    _messageStateRequest = value;
  }

  bool get showNavigatorRoute => _showNavigatorRoute!;

  set showNavigatorRoute(bool value) {
    _showNavigatorRoute = value;
  }

  String get labelNameButtonRequest => _labelNameButtonRequest!;

  set labelNameButtonRequest(String value) {
    _labelNameButtonRequest = value;
  }

  int get countChat => _countChat!;

  set countChat(int value) {
    _countChat = value;
  }

  Timer get timePostulation => _timePostulation!;

  set timePostulation(Timer value) {
    _timePostulation = value;
  }

  String get timeCurrentPostulation => _timeCurrentPostulation!;

  set timeCurrentPostulation(String value) {
    _timeCurrentPostulation = value;
  }

  double get gainDay => _gainDay!;

  set gainDay(double value) {
    _gainDay = value;
    notifyListeners();
  }

  String get dateServer => _dateServer!;

  set dateServer(String value) {
    _dateServer = value;
  }

  double get qualificationDriver => _qualificationDriver!;

  set qualificationDriver(double value) {
    _qualificationDriver = value;
  }

  int get numberRequest => _numberRequest!;

  set numberRequest(int value) {
    _numberRequest = value;
  }

  String get nameMoney => _nameMoney!;

  set nameMoney(String value) {
    _nameMoney = value;
  }

  int get countNotification => _countNotification!;

  set countNotification(int value) {
    _countNotification = value;
    notifyListeners();
  }

  bool get stateTracking => _stateTracking!;

  set stateTracking(bool value) {
    _stateTracking = value;
    notifyListeners();
  }

  bool get stateService => _stateService!;

  set stateService(bool value) {
    _stateService = value;
  }

  ModelRequest? get modelRequestActive => _modelRequestActive;

  set modelRequestActive(ModelRequest? value) {
    if (value != null) {
      _modelRequestActive = value;
    }
  }

  ModelRequest? get modelRequestPostulation => _modelRequestPostulation;

  set modelRequestPostulation(ModelRequest? value) {
    if (value != null) {
      _modelRequestPostulation = value;
    }
  }

  ModelDispositive get modelDispositive => _modelDispositive!;

  set modelDispositive(ModelDispositive value) {
    _modelDispositive = value;
  }

  ModelUser get modelUser => _modelUser!;

  set modelUser(ModelUser value) {
    _modelUser = value;
  }

  bool get stateStreetRequest => _stateStreetRequest!;

  set stateStreetRequest(bool value) {
    _stateStreetRequest = value;
  }

  bool get sharedTravel => _sharedTravel!;

  set sharedTravel(bool value) {
    _sharedTravel = value;
  }

  bool get stateWalkiesTalkie => _stateWalkiesTalkie!;

  set stateWalkiesTalkie(bool value) {
    _stateWalkiesTalkie = value;
  }

  /// Load configuration initial applicative
  void loadDataView(BuildContext context,
      List<ModelConfigurationDriver> configurationDriver, int typeConnected) {
    final prConfigurationApp = context.read<ProviderConfigurationApp>();
    final prServiceSocketRead = context.read<ProviderServiceSocket>();

    GlobalPreference.getDataUser().then((dataUser) {
      _modelUser = dataUser;
    });

    addListConfigurationDriver(configurationDriver);

    GlobalPreference.getDataDispositive().then((dataDispositive) {
      _modelDispositive = dataDispositive;
    });

    GlobalPreference.getStateService().then((stateService) {
      _stateService = stateService;
    });

    GlobalPreference.getDataConfigurationApp().then((configurationApp) {
      if (configurationApp == null) {
        ModelConfigurationApp modelConfigurationApp = ModelConfigurationApp();
        modelConfigurationApp.routeMap = true;
        modelConfigurationApp.routeWaze = false;
        modelConfigurationApp.routeGoogle = false;
        modelConfigurationApp.speakChat = true;
        modelConfigurationApp.externalTaximeter = false;
        modelConfigurationApp.heatMap = false;
        GlobalPreference().setDataConfigurationApp(modelConfigurationApp);
        prConfigurationApp.modelConfigurationApp = modelConfigurationApp;
      } else {
        prConfigurationApp.modelConfigurationApp = configurationApp;
      }
    });

    GlobalPreference.getStateTracking().then((stateTracking) {
      _stateTracking = false;
    });
    prServiceSocketRead.activeListenChat(context);

    context.read<ProviderMap>().checkGPS(typeConnected);
  }

  void addListConfigurationDriver(
      List<ModelConfigurationDriver> configurationDriver) {
    if (listConfigurationDriver!.isNotEmpty) listConfigurationDriver!.clear();
    listConfigurationDriver!.addAll(configurationDriver);
    loadConfigurationDriver();
  }

  /// Method for load configuration driver
  void loadConfigurationDriver() {
    final prWalKieTalkieRead =
        GlobalFunction.context.currentContext!.read<ProviderWalkiesTalkie>();
    final prConfigurationRead =
        GlobalFunction.context.currentContext!.read<ProviderConfigurationApp>();
    if (listConfigurationDriver!.isEmpty) return;
    for (ModelConfigurationDriver configurationDriver
        in listConfigurationDriver!) {
      switch (configurationDriver.id) {
        case 86:
          if (configurationDriver.h == 1) {
            _stateVerifyIdentity = true;
          } else {
            _stateVerifyIdentity = false;
          }
          break;
        case 29:
          if (configurationDriver.h == 1) {
            _stateCodeReferred = true;
          } else {
            _stateCodeReferred = false;
          }
          break;
        case 84:
          if (configurationDriver.h == 1) {
            prConfigurationRead.stateTaximeterBluetooth = true;
          } else {
            prConfigurationRead.stateTaximeterBluetooth = false;
          }
        case 12:
          _nameMoney = configurationDriver.nb!.toUpperCase();
          break;
        case 10:
          if (configurationDriver.h == 1) {
            _stateWalkiesTalkie = true;
            prWalKieTalkieRead.activateAudioWalkiesTalkie();
            GlobalPreference.getWalkiesTalkie().then((chat) {
              prWalKieTalkieRead.listChatAudio = chat;
              prWalKieTalkieRead.deleteListChatAudio();
              prWalKieTalkieRead.chatFilterAudio();
            });
          } else {
            _stateWalkiesTalkie = false;
            // serviceSocket.disableRecordUserAllBusiness();
            // serviceSocket.disableRecordCallCenter();
            // serviceSocket.disableRecordAll();
          }
          break;
      }
    }
  }

  /// Method update state service
  void listeningService(BuildContext context) {
    final prMapRead = context.read<ProviderMap>();
    final prServiceRestRead = context.read<ProviderServiceRest>();
    final prServiceSocketRead = context.read<ProviderServiceSocket>();
    if (_stateService!) {
      GlobalPreference().setStateService(false);
      _stateService = false;
      GlobalFunction()
          .player
          .play(AssetSource(GlobalLabel.identificationService));

      prServiceSocketRead.disableGlobalEvents();
    } else {
      _stateService = true;
      GlobalPreference().setStateService(true);
      GlobalFunction().player.play(AssetSource(GlobalLabel.startService));
      prServiceRestRead.consultInProgress(context, 1);
    }
    prMapRead.updateNotification();
    prServiceRestRead.sendUpdateStateDriver(context);

    notifyListeners();
  }

  /// Get name type pay
  String nameTypePay(ModelRequest? modelRequest) {
    if (modelRequest == null || modelRequest.requestData == null) {
      return GlobalLabel.textWithCash;
    }
    switch (modelRequest.requestData!.paymentType) {
      case 0:
        return GlobalLabel.textWithCash.toUpperCase();
      case 1:
        return GlobalLabel.textWithVoucher.toUpperCase();
      case 4:
        return GlobalLabel.textWithElectronicBalance.toUpperCase();
      case 7:
        return GlobalLabel.textWithCreditCard.toUpperCase();
      case 9:
        return modelRequest.requestData!.nameHybrid!.toUpperCase();
      default:
        return GlobalLabel.textWithCash.toUpperCase();
    }
  }

  /// Neighborhood origin request
  String neighborhoodOriginRequest(ModelRequest request) {
    if (request.requestData == null) return GlobalLabel.textStranger;
    return request.requestData!.user!.addresses!.isNotEmpty
        ? request.requestData!.user!.addresses![0].description!
                .trim()
                .isNotEmpty
            ? request.requestData!.user!.addresses![0].description!.trim()
            : GlobalLabel.textStranger
        : GlobalLabel.textStranger;
  }

  /// Neighborhood destiny request
  neighborhoodDestinyRequest(ModelRequest request) {
    if (request.requestData == null) return GlobalLabel.textStranger;
    return request.requestData!.destination!.isNotEmpty
        ? request.requestData!.destination![0].desBar!.trim().isNotEmpty
            ? request.requestData!.destination![0].desBar!.trim()
            : GlobalLabel.textStranger
        : GlobalLabel.textStranger;
  }

  /// Street origin request
  String streetOriginRequest(ModelRequest request) {
    if (request.requestData == null) return GlobalLabel.textStranger;
    return request.requestData!.user!.addresses!.isNotEmpty
        ? request.requestData!.user!.addresses![2].description!
                .trim()
                .isNotEmpty
            ? '${request.requestData!.user!.addresses![1].description!.trim()} - ${request.requestData!.user!.addresses![2].description!.trim()}'
            : request.requestData!.user!.addresses![1].description!.trim()
        : GlobalLabel.textStranger;
  }

  /// Reference address
  String referenceAddress(ModelRequest request) {
    if (request.requestData == null) return GlobalLabel.textStranger;
    return request.requestData!.user!.addresses!.isNotEmpty
        ? request.requestData!.user!.addresses![3].description!
                .trim()
                .isNotEmpty
            ? request.requestData!.user!.addresses![3].description!.trim()
            : GlobalLabel.textStranger
        : GlobalLabel.textStranger;
  }

  /// Street destiny request
  String streetDestinyRequest(ModelRequest request) {
    if (request.requestData == null) return GlobalLabel.textStranger;
    return request.requestData!.destination!.isNotEmpty
        ? request.requestData!.destination![0].desCs!.isNotEmpty
            ? '${request.requestData!.destination![0].desCp} - ${request.requestData!.destination![0].desCs}'
            : '${request.requestData!.destination![0].desCp}'
        : GlobalLabel.textStranger;
  }

  /// Calculate distance travel driver - client
  String distanceTravelClient(RequestData modelRequest) {
    String result = '';
    double operation;
    if (modelRequest.distance! >= 1000) {
      operation = modelRequest.distance! / 1000;
      result = '${operation.roundToDouble().toInt()} Km';
    } else {
      result = '${modelRequest.distance!.toInt()} m';
    }
    return result;
  }

  /// Calculate distance travel origin - destiny
  distanceTravelOriginDestiny(RequestData request) {
    String result = '';
    double operation;
    if (request.destination![0].desDis! >= 1) {
      result = '${request.destination![0].desDis!.toInt()} km';
    } else {
      operation = request.destination![0].desDis! * 1000;
      result = '${operation.roundToDouble().toInt()} m';
    }
    return result;
  }

  formatTimeDestiny(String timeEnd) {
    String time = '0';
    if (timeEnd.split(':')[0] == '00') {
      if (double.parse(timeEnd.split(':')[1]) > 10) {
        time = timeEnd.split(':')[1];
      } else if (double.parse(timeEnd.split(':')[1]) == 0) {
        time = '0';
      } else {
        time = timeEnd.split(':')[1].replaceAll('0', '');
      }
    } else {
      if (double.parse(timeEnd.split(':')[0]) > 10) {
        time = '${timeEnd.split(':')[0]}:${timeEnd.split(':')[1]}';
      } else if (double.parse(timeEnd.split(':')[0]) == 0) {
        time = '0';
      } else {
        time =
            '${timeEnd.split(':')[0].replaceAll('0', '')}:${timeEnd.split(':')[1]}';
      }
    }
    return time;
  }

  /// Send time postulation of the request
  timePostulationRequest(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    GlobalPreference.getTimeTravelUser().then((time) {
      GlobalFunction().speakMessage(
          '${GlobalLabel.textStartTravel} ${prPrincipalRead.modelRequestActive!.requestData!.user!.addresses![0].description!}, '
          '${time >= 1 ? '${GlobalLabel.textTimeArrived} $time ${GlobalLabel.textMinutes}' : ''}');
    });
  }

  /// Audio new request
  void audioNewRequest(ModelRequest request) {
    if (request.requestType == 1) {
      GlobalFunction()
          .player
          .play(AssetSource(GlobalLabel.identificationNotification));
      GlobalFunction().speakMessage(
          '${GlobalLabel.textNewTravel} ${request.requestData!.user!.addresses![0].description}');
    } else {
      GlobalFunction()
          .player
          .play(AssetSource(GlobalLabel.identificationNotification));
    }
  }

  /// Delete request to list
  void deleteRequest(int idRequest) {
    if (listModelRequest!.isEmpty) return;
    listModelRequest!
        .removeWhere((element) => element.requestData!.requestId == idRequest);
    notifyListeners();
    if (listModelRequest!.isEmpty) {
      updateShowListRequest(false);
    }
  }

  /// Clean request list
  void clearRequestList() {
    if (listModelRequest!.isEmpty) return;
    listModelRequest!.clear();
    _showListRequest = false;
    notifyListeners();
  }

  void declineRequest(BuildContext context, int requestId) {
    final prServiceRestRead = context.read<ProviderServiceRest>();
    prServiceRestRead.sendDeclineRequest(context, requestId);
    deleteRequest(requestId);
  }

  /// Activate time wait acceptance of the request
  void activeWaitAcceptance(BuildContext context, int second, int idRequest) {
    if (_timePostulation != null) {
      _timePostulation!.cancel();
      _timePostulation = null;
    }
    _timePostulation =
        Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (second > 0) {
        second--;
      }
      _timeCurrentPostulation = '${(second < 10) ? '0$second' : second}';
      if (second == 0) {
        _timePostulation!.cancel();
        GlobalFunction().speakMessage(GlobalLabel.textTimePostulationFinish);
        cancelRequest(1);
      }
      notifyListeners();
    });
  }

  /// Cancel request
  /// type 1: Finish time wait postulation
  /// type 2: Cancel driver postulation
  /// type 3: Request already attended
  void cancelRequest(int type) {
    final prServiceRestRead =
        GlobalFunction.context.currentContext!.read<ProviderServiceRest>();
    if (type != 3) {
      prServiceRestRead.cancelRequestBeforePostulation(
          GlobalFunction.context.currentContext!,
          modelRequestPostulation!,
          7,
          11);
    }
  }

  /// Get request id
  getRequestId() {
    if (_modelRequestActive == null ||
        _modelRequestActive!.requestData == null) {
      return GlobalLabel.textStranger;
    }
    return _modelRequestActive!.requestData!.requestId;
  }

  /// Get description state request
  void getDescriptionStateRequest() {
    if (modelRequestActive!.requestData == null) {
      _messageStateRequest = GlobalLabel.textStranger;
    } else {
      if (modelRequestActive!.statusDriver == 3 &&
          modelRequestActive!.requestData!.advice == 0) {
        _messageStateRequest = GlobalLabel.textMeetingPoint;
      } else {
        switch (modelRequestActive!.statusDriver) {
          case 3:
            _messageStateRequest = GlobalLabel.textWaitUser;
          case 5:
            if (modelRequestActive!.requestData!.paymentType == 9) {
              _messageStateRequest = nameTypePay(modelRequestActive);
            } else {
              _messageStateRequest = '${GlobalLabel.txtPayment} '
                  '${nameTypePay(modelRequestActive)}';
            }
        }
      }
    }
    notifyListeners();
  }

  /// Get name button request active
  void getNameButtonRequestActive() {
    if (modelRequestActive!.requestData == null) {
      _labelNameButtonRequest = GlobalLabel.textStranger;
    } else {
      if (modelRequestActive!.requestData!.requestId! > 0) {
        if (modelRequestActive!.statusDriver == 3 &&
            modelRequestActive!.requestData!.advice == 0) {
          _labelNameButtonRequest = GlobalLabel.buttonImHere;
        } else {
          switch (modelRequestActive!.statusDriver) {
            case 3:
              _labelNameButtonRequest = GlobalLabel.buttonStartService;
            case 5:
              _labelNameButtonRequest = GlobalLabel.buttonEndService;
          }
        }
      }
    }
    notifyListeners();
  }

  /// Check tracking type
  /// State Tracking 0: Libre
  /// State Tracking 1: Occupied
  /// State Tracking 2: Wait confirmation
  /// State Tracking 3: Travel
  /// State Tracking 4: On board user
  /// State Tracking 5: On board driver
  /// State Tracking 6: On board user and driver
  /// State Tracking 7: Call to user
  verifyStateTracking() {
    int stateTracking = _stateService! ? 0 : 1;
    if (_sendPostulation!) {
      stateTracking = 2;
    } else {
      if (_modelRequestActive!.requestData != null) {
        stateTracking = _modelRequestActive!.statusDriver!;
      }
    }
    return stateTracking;
  }

  /// Get type pay history
  getTypePayHistory(int typePay) {
    switch (typePay) {
      case 0:
        return GlobalLabel.textCash;
      case 1:
        return GlobalLabel.textVoucher;
      case 4:
        return GlobalLabel.textPayElectronic;
      case 7:
        return GlobalLabel.textCreditCard;
      case 9:
        return GlobalLabel.textWithHybrid;
      default:
        return GlobalLabel.textWithCash;
    }
  }

  /// Button cancel timer
  void buttonStreetRequest(BuildContext context) {
    final prTaximeterWatch = context.read<ProviderTaximeter>();
    GlobalFunction()
        .messageConfirmation(GlobalLabel.textMessageDeleteStreetRequest, () {
      _stateStreetRequest = false;
      GlobalPreference().setStreetRequest(false);
      prTaximeterWatch.resetTaximeter();
      prTaximeterWatch.resetVariable();
    });
  }

  /// Finalize request
  /// Type 1: Finalize request
  /// Type 2: Canceled request user
  finalizeRequest(int type) {
    Future.delayed(const Duration(seconds: 2), () {
      final prMapRead =
          GlobalFunction.context.currentContext!.read<ProviderMap>();
      final prTaximeterRead =
          GlobalFunction.context.currentContext!.read<ProviderTaximeter>();
      final prServiceRestRead =
          GlobalFunction.context.currentContext!.read<ProviderServiceRest>();
      final prPaymentRead =
          GlobalFunction.context.currentContext!.read<ProviderPayment>();
      final prChatRequestRead =
          GlobalFunction.context.currentContext!.read<ProviderChatRequest>();
      if (modelRequestActive!.requestData != null) {
        prPaymentRead.saveDayStatistics(GlobalFunction.context.currentContext!);
      }
      if (type == 1) {
        prServiceRestRead.saveTaximeter(
            GlobalFunction.context.currentContext!,
            _modelRequestActive!.requestData != null
                ? !_stateTaximeterStreet!
                    ? 1
                    : 2
                : 3);
      }

      _proximityNotice = false;
      prMapRead.deleteMarker(GlobalLabel.textDestinyMarker);
      prMapRead.deleteMarker(GlobalLabel.textOriginMarker);
      prMapRead.deleteTracingRouteMap();
      _labelNameButtonRequest = '';
      _showNavigatorRoute = false;
      _stateTaximeterStreet = false;
      if (_timerChronometer != null) {
        _timerChronometer!.cancel();
      }
      prTaximeterRead.resetTaximeter();
      prServiceRestRead
          .consultGainQualificationUser(GlobalFunction.context.currentContext!);
      prServiceRestRead
          .consultDayStatics(GlobalFunction.context.currentContext!);
      GlobalPreference.deleteChatRequest();
      prChatRequestRead.deleteListChat();
      prTaximeterRead.resetVariable();
      prPaymentRead.initialReviewSlider = 4;
      prPaymentRead.editComment.clear();
      if (prPaymentRead.editPin.text.isNotEmpty) {
        prPaymentRead.editPin.clear();
        GlobalFunction().hideQuery();
      }
      GlobalPreference().setTimeTravelUser(0);
      _modelRequestActive = ModelRequest();
      _modelRequestPostulation = ModelRequest();
      notifyListeners();
      prServiceRestRead
          .sendUpdateStateDriver(GlobalFunction.context.currentContext!);
      prServiceRestRead.consultHeatMap(GlobalFunction.context.currentContext!);
      prPaymentRead.updateStateViewPage(false);
    });
  }

  /// Save shared travel
  void saveSharedTravel() {
    if (_sharedTravel!) {
      _sharedTravel = false;
    } else {
      _sharedTravel = true;
    }
    GlobalPreference().setSharedTravel(_sharedTravel!);
  }

  /**
   * New method
   */

  /// Add new request to the list
  void addNewRequestList(
      BuildContext context, ResponseRequest responseRequest, int type) async {
    final prMapRead =
        GlobalFunction.context.currentContext!.read<ProviderMap>();
    final prPrincipalRead =
        GlobalFunction.context.currentContext!.read<ProviderPrincipal>();
    listModelRequest!.clear();
    if (responseRequest.listRequest!.isEmpty) return;
    for (ModelRequest modelRequest in responseRequest.listRequest!) {
      if (modelRequest.statusDriver! > 0) {
        if (modelRequest.statusDriver! != 2) {
          if (type == 2) {
            GlobalPreference()
                .setTimeTravelUser(modelRequest.requestData!.times!);
          }
          activeRequest(modelRequest, 2);
          _stateTracking = true;
          GlobalPreference().setStateTracking(true);
          prMapRead.moveMapButton();
          if (_timePostulation != null) {
            _timePostulation!.cancel();
          }
          prPrincipalRead.markerDetailRequest();
        } else {
          prPrincipalRead.modelRequestPostulation = modelRequest;
          prPrincipalRead.activeWaitAcceptance(
              context,
              modelRequest.requestData!.timePost! == 0
                  ? 3
                  : modelRequest.requestData!.timePost!,
              modelRequest.requestData!.requestId!);
          await Future.delayed(const Duration(seconds: 1));
          if (modelRequest.requestData!.statusAssigned == 1) {
            prPrincipalRead.sendPostulation = true;
            prPrincipalRead.sendPreviewPostulation = true;
          }
          GlobalFunction()
              .nextPageViewTransition(const PageProgressPostulation());
        }
        notifyListeners();
        break;
      } else if (prPrincipalRead.modelRequestActive!.requestData == null) {
        listModelRequest!.clear();
        listModelRequest!.addAll(responseRequest.listRequest!);
        updateShowListRequest(true);
      }
    }
    notifyListeners();
  }

  void addNewRequest(ResponseRequest request) async {
    final prServiceRestRead =
        GlobalFunction.context.currentContext!.read<ProviderServiceRest>();
    final prConfigurationAppRead =
        GlobalFunction.context.currentContext!.read<ProviderConfigurationApp>();
    if (request.listRequest!.isEmpty) return;
    audioNewRequest(request.listRequest![0]);
    if (listModelRequest!.isNotEmpty) {
      listModelRequest!.removeWhere((element) =>
          element.requestData!.requestId ==
          request.listRequest![0].requestData!.requestId);
    }
    if (prConfigurationAppRead.modelConfigurationApp.heatMap!) {
      prServiceRestRead.consultHeatMap(GlobalFunction.context.currentContext!);
    }
    listModelRequest!.insert(0, request.listRequest![0]);
    notifyListeners();
    if (listModelRequest!.isEmpty) return;
    updateShowListRequest(true);
  }

  /// Type 1: Get progress by Id
  /// Type 2: Get in progress
  void activeRequest(ModelRequest modelRequest, int type) {
    final prMapRead =
        GlobalFunction.context.currentContext!.read<ProviderMap>();
    final prConfigurationAppRead =
        GlobalFunction.context.currentContext!.read<ProviderConfigurationApp>();
    final prServiceRestRead =
        GlobalFunction.context.currentContext!.read<ProviderServiceRest>();
    _modelRequestActive = modelRequest;
    getNameButtonRequestActive();
    getDescriptionStateRequest();
    prServiceRestRead
        .listEventualityCancel(GlobalFunction.context.currentContext!);
    prServiceRestRead.listMessageChat(GlobalFunction.context.currentContext!);
    switch (_modelRequestActive!.statusDriver) {
      case 3:
        _showNavigatorRoute = true;
        if (prConfigurationAppRead.modelConfigurationApp.routeMap!) {
          _stateTracking = true;
          prMapRead.moveMapButton();
          prMapRead.tracingRouteMap(GlobalFunction.context.currentContext!);
        } else {
          prMapRead.markerOrigin(
              GlobalFunction.context.currentContext!,
              LatLng(modelRequest.requestData!.latitude!,
                  modelRequest.requestData!.longitude!),
              GlobalLabel.textOriginMarker,
              modelRequest.requestData!.user!.addresses![0].description!,
              modelRequest.requestData!.distance!);
        }
        updateTimeRequest();
        break;
      case 5:
        if (modelRequest.requestType == 3) {
          prServiceRestRead.consultTaximeterStreet(
              GlobalFunction.context.currentContext!, 2);
        } else if (modelRequest.requestType == 1 ||
            modelRequest.requestType == 4) {
          prServiceRestRead.consultTaximeterRequest(
              GlobalFunction.context.currentContext!, modelRequest);
        }
        break;
    }
  }

  /// Stop postulation request
  void stopPostulation() {
    if (_timePostulation != null) {
      _timePostulation!.cancel();
    }
    _sendPreviewPostulation = false;
    GlobalFunction().closeView();
    if (_sendPostulation!) {
      _sendPostulation = false;
      _timeCurrentPostulation = GlobalLabel.timePostulation;
    }
    notifyListeners();
  }

  void activeGlobalEvent(BuildContext context) {
    final prServiceSocketRead = context.read<ProviderServiceSocket>();
    prServiceSocketRead.activeGlobalEvents(context);
  }

  /// Status emit global
  /// 2: Presentation view page closing session
  /// 4: Presentation lock view
  /// 6: Presentation of cancellation alert
  void statusResponseEmit() {
    final prChatRequestRead =
        GlobalFunction.context.currentContext!.read<ProviderChatRequest>();
    switch (prChatRequestRead.dataEmit.state) {
      case 2:
        GlobalFunction().nextPageViewTransition(PageClosingSession(
            message: ' ${prChatRequestRead.dataEmit.message} '));
        break;
      case 4:
        GlobalPreference().setStateService(false);
        _stateService = false;
        // serviceSocket.disableNewRequest();
        // getPageLocked();
        break;
      case 6:
        GlobalFunction()
            .messageConfirmation(prChatRequestRead.dataEmit.message!, () {
          // apiInterface.responseAcceptCancellation(_user!.idUser!, _dataEmit!.idConfigurationPenalty!);
        },
                title: prChatRequestRead.dataEmit.title!,
                activeButtonCancel: false,
                onWillPop: true);
        break;
    }
  }

  void listEventualityCancel(ResponseEventuality responseEventuality) {
    if (listEventuality!.isNotEmpty) listEventuality!.clear();
    listEventuality!.addAll(responseEventuality.eventuality!);
    notifyListeners();
  }

  int updateTimeRequest() {
    int hour = 0;
    int totalTime = 0;
    int second = 0;
    int minute = 0;
    GlobalPreference.getTimeTravelUser().then((time) {
      minute = time;
      resetChronometer();
      _timerChronometer =
          Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (second > 0) {
          second--;
        } else {
          if (minute > 0) {
            second = second + 59;
            minute--;
          } else {
            if (hour > 0) {
              minute = minute + 59;
              hour--;
            }
          }
        }
        if (minute == 0 && second == 0) {
          resetChronometer();
          if (GlobalFunction().checkDistance() > 20) {
            GlobalFunction().player.play(AssetSource(GlobalLabel.startAlert));
            GlobalFunction()
                .sendMoreTime(GlobalFunction.context.currentContext!);
          }
        }
        GlobalPreference().setTimeTravelUser(minute);
        _chronometer =
            '${minute < 10 ? '0$minute' : minute}:${second < 10 ? '0$second' : second}';
        notifyListeners();
      });
    });

    return totalTime;
  }

  void resetChronometer() {
    if (_timerChronometer != null) {
      _timerChronometer!.cancel();
      _timerChronometer = null;
      _chronometer = '00:00';
      notifyListeners();
    }
  }

  void addPrice(ModelRequest modelRequest) {
    double lastPrice = modelRequest.requestData!.prices!.first;
    double increment = modelRequest.requestData!.destination![0].fraction!;
    if ((lastPrice + increment) <
        modelRequest.requestData!.destination![0].moreBid!) {
      modelRequest.requestData!.prices!.insert(0, (lastPrice + increment));
      notifyListeners();
    } else {
      GlobalFunction().speakMessage(GlobalLabel.textMaximumValueAllowed);
      GlobalFunction().messageAlert(GlobalFunction.context.currentContext!,
          GlobalLabel.textMaximumValueAllowed);
    }
  }

  Future<void> loadMapDetailRequest(GoogleMapController controller) async {
    _mapController = controller;
    notifyListeners();
    if (_mapController != null) {
      _mapController!.setMapStyle(await rootBundle
          .loadString('${GlobalLabel.typeMap}style_map_day.json'));
      notifyListeners();
    }
  }

  void markerDetailRequest() async {
    await Future.delayed(const Duration(milliseconds: 100));
    deleteMarker();
    GlobalFunction()
        .createMarker('${GlobalLabel.directionImageInternal}pinuser.png')
        .then((marker) {
      iconDetailOrigin = marker;
      notifyListeners();
    });

    GlobalFunction()
        .createMarker('${GlobalLabel.directionImageInternal}blackcircle.png')
        .then((marker) {
      iconDetailVehicle = marker;
      notifyListeners();
    });
  }

  /// Delete marker
  void deleteMarker() {
    markers!.clear();
    notifyListeners();
  }

  void onCameraMove(CameraPosition position) async {}

  void updateShowListRequest(bool status) {
    _showListRequest = status;
    notifyListeners();
  }

  void reconnectedTaximeter(BuildContext context) {
    final prConfigurationAppRead = context.read<ProviderConfigurationApp>();
    if (prConfigurationAppRead.modelConfigurationApp.externalTaximeter!) {
      prConfigurationAppRead.checkBluetooth(context);
    }
  }

  void updateStateShowGainDay() {
    if (_showGainDay!) {
      _showGainDay = false;
    } else {
      _showGainDay = true;
    }
    notifyListeners();
  }

  void updateStateShowProfile(bool state) {
    _showProfile = state;
  }
}
