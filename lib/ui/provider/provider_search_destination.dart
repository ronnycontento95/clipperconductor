import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../data/response/response_search_direction.dart';
import '../../data/response/response_suggestion_destination.dart';
import '../../domain/entities/model_direction_for_coordinate.dart';
import '../../domain/entities/model_search_direction.dart';

import '../../domain/entities/model_suggestion_destination.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_preference.dart';
import 'provider_map.dart';
import 'provider_principal.dart';
import 'provider_service/provider_service_rest.dart';

class ProviderSearchDestination with ChangeNotifier {
  ModelDirectionForCoordinate directionForCoordinate =
      ModelDirectionForCoordinate();
  TextEditingController editSearch = TextEditingController();
  SpeechToText? speechToText = SpeechToText();
  List<ModelSearchDirection>? listDirectionStreet = [];
  List<ModelSearchDirection>? listDirectionStreetRecent = [];
  ModelSearchDirection? _selectedDirectionStreet = ModelSearchDirection();
  bool? _stateSpeech = false;
  double? _latitudeStreet;
  double? _longitudeStreet;
  bool? _verification = false;
  GoogleMapController? _mapController;
  Map<MarkerId, Marker>? markers = {};
  BitmapDescriptor? iconDestiny;

  GoogleMapController get mapController => _mapController!;

  set mapController(GoogleMapController value) {
    _mapController = value;
  }

  bool get verification => _verification!;

  set verification(bool value) {
    _verification = value;
  }

  double get longitudeStreet => _longitudeStreet!;

  set longitudeStreet(double value) {
    _longitudeStreet = value;
    notifyListeners();
  }

  double get latitudeStreet => _latitudeStreet!;

  set latitudeStreet(double value) {
    _latitudeStreet = value;
    notifyListeners();
  }

  bool get stateSpeech => _stateSpeech!;

  set stateSpeech(bool value) {
    _stateSpeech = value;
    notifyListeners();
  }

  bool? _contList = false;

  bool get contList => _contList!;

  set contList(bool value) {
    _contList = value;
  }

  ModelSearchDirection get selectedDirectionStreet => _selectedDirectionStreet!;

  set selectedDirectionStreet(ModelSearchDirection value) {
    _selectedDirectionStreet = value;
  }

  /// Clean text field search
  void cleanTextFieldSearch() {
    editSearch.clear();
    listDirectionStreet!.clear();
    notifyListeners();
  }

  /// Initial listing speech
  void startListening() async {
    stateSpeech = true;
    await speechToText!.listen(onResult: onSpeechResult);
  }

  /// Stop listing speech
  void stopListening(BuildContext context) async {
    final prServiceRestRead = context.read<ProviderServiceRest>();
    await speechToText!.stop();
    GlobalFunction().hideQuery();
    Timer(const Duration(milliseconds: 800), () {
      if (editSearch.text.isEmpty) return;
      GlobalFunction().showProgress();
      prServiceRestRead.getListSuggestionDirection(context, editSearch.text);
    });
  }

  /// Get result listing
  void onSpeechResult(SpeechRecognitionResult result) {
    editSearch.text = result.recognizedWords;
  }

  /// Add list direction street
  void addListDirectionStreet(
      BuildContext context, ResponseSearchDirection responseSearchDirection) {
    if (listDirectionStreet!.isNotEmpty) listDirectionStreet!.clear();
    if (responseSearchDirection.predictions!.isEmpty) return;
    if (stateSpeech) {
      stateSpeech = false;
      GlobalFunction().hideProgress();
    }
    listDirectionStreet!.addAll(responseSearchDirection.predictions!);
    notifyListeners();
  }

  /// Initial speech
  void initSpeech() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (speechToText!.isNotListening) {
      await speechToText!.initialize();
    }
  }

  void getDirectionRecent() {
    GlobalPreference.getRecentAddress().then((recentAddress) {
      if (recentAddress == null) return;
      if (listDirectionStreetRecent!.isNotEmpty) {
        listDirectionStreetRecent!.clear();
      }
      listDirectionStreetRecent!.add(recentAddress);
      notifyListeners();
    });
  }

  void addDirectionRecent(ModelSearchDirection modelSearchDirection) {
    if (listDirectionStreetRecent!.isEmpty) {
      GlobalPreference().setRecentAddress(modelSearchDirection);
      listDirectionStreetRecent!.add(modelSearchDirection);
      notifyListeners();
    } else {
      for (int i = 0; i < listDirectionStreetRecent!.length; i++) {
        if (listDirectionStreetRecent![i].placeId ==
            modelSearchDirection.placeId) {
          _verification = true;
          break;
        }
      }
      if (!_verification!) {
        listDirectionStreetRecent!.add(modelSearchDirection);
        GlobalPreference().setRecentAddress(modelSearchDirection);
        notifyListeners();
      }
    }
  }

  void sendConfirmationTravel(
      ResponseSuggestionDestination responseSuggestionDestination,
      BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prMapRead = context.read<ProviderMap>();
    final prServiceRestRead = context.read<ProviderServiceRest>();

    List<Map<String, dynamic>> coordinate = [];
    if (responseSuggestionDestination
        .listSuggestion![0].toll!.listPoint!.isNotEmpty) {
      for (Point point in responseSuggestionDestination
          .listSuggestion![0].toll!.listPoint!) {
        Map<String, dynamic> points = {
          "lat": point.latitude,
          "lng": point.longitude,
          "nombre": point.name,
          "precio": point.price,
          "moneda": point.money,
        };
        coordinate.add(points);
      }
    }
    final data = {
      'userId': prPrincipalRead.modelUser.idUser,
      'vehicleId': prPrincipalRead.modelUser.idVehicle,
      'cityId': prPrincipalRead.modelUser.idCity,
      'companyId': prPrincipalRead.modelUser.idBusiness,
      'origin': {
        'fromLatitude': prMapRead.positionLatitude,
        'fromLongitude': prMapRead.positionLongitude,
        'fromMainStreet': directionForCoordinate.st1,
        'fromSecondaryStreet': directionForCoordinate.st2,
        'fromNeighborhood': directionForCoordinate.nB,
      },
      'destination': {
        'toCost': responseSuggestionDestination.listSuggestion![0].cost!.value,
        'toLatitude': _latitudeStreet,
        'toLongitudeD': _longitudeStreet,
        'toMainStreetD':
            _selectedDirectionStreet!.structuredFormatting!.mainText,
        'toSecondaryStreetD':
            _selectedDirectionStreet!.structuredFormatting!.secondaryText,
        'toDistance':
            responseSuggestionDestination.listSuggestion![0].distance!.value,
        'toTime': responseSuggestionDestination
            .listSuggestion![0].timeApproximate!.value
      },
      'toll': {
        'isToll': responseSuggestionDestination.listSuggestion![0].toll!.isToll,
        'points': coordinate,
        'value': responseSuggestionDestination.listSuggestion![0].toll!.value
      }
    };
    prServiceRestRead.sendRequestStreet(context, data);
  }

  Future<void> loadMap(GoogleMapController controller) async {
    _mapController = controller;
    notifyListeners();
    if (_mapController != null) {
      _mapController!.setMapStyle(await rootBundle
          .loadString('${GlobalLabel.typeMap}style_map_day.json'));
      notifyListeners();
    }
  }

  void markerSearchDirection(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 100));
    deleteMarker();
    GlobalFunction()
        .createMarker('${GlobalLabel.directionImageInternal}bluecircle.png')
        .then((marker) {
      iconDestiny = marker;
      notifyListeners();
    });
  }

  /// Delete marker
  void deleteMarker() {
    markers!.clear();
    notifyListeners();
  }

  void onCameraMove(CameraPosition position) async {}
}
