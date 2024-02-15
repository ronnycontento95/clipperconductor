import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/response/response_point_tracing.dart';
import '../../domain/entities/model_configuration_app.dart';
import '../../domain/entities/model_dispositive.dart';
import '../../domain/entities/model_request.dart';
import '../../domain/entities/model_search_direction.dart';
import '../../domain/entities/model_user.dart';

class GlobalPreference {
  static const String _dataDispositive = 'dataDispositive';
  static const String _dataUser = 'dataUser';
  static const String _stateLogin = 'stateLogin';
  static const String _stateService = 'stateService';
  static const String _dataConfigurationApp = 'dataConfigurationApp';
  static const String _stateTracking = 'stateTracking';
  static const String _tracedRequestOrigin = 'tracedRequestOrigin';
  static const String _tracedRequestDestiny = 'tracedRequestDestiny';
  static const String _streetRequest = 'streetRequest';
  static const String _sharedTravel = 'sharedTravel';
  static const String _saveAudioWalkiesTalkie = 'saveAudioWalkiesTalkie';
  static const String _saveChatRequest = 'saveChatRequest';
  static const String _recentAddress = 'recentAddress';
  static const String _timeTravelUser = 'timeTravelUser';
  static const String _statusHeatMap = 'statusHeatMap';

  Future<ModelDispositive> setDataDispositive(
      ModelDispositive? dispositive) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    const JsonEncoder encoder = JsonEncoder();
    prefs.setString(_dataDispositive, encoder.convert(dispositive!.toMap()));
    return dispositive;
  }

  static Future<ModelDispositive?> getDataDispositive() async {
    const JsonDecoder decoder = JsonDecoder();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dispositive = prefs.getString(_dataDispositive) ?? "";
    if (dispositive.isEmpty) {
      return null;
    }
    return ModelDispositive.fromMap(decoder.convert(dispositive));
  }

  Future<ModelUser> setDataUser(ModelUser? dataUser) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    const JsonEncoder encoder = JsonEncoder();
    prefs.setString(_dataUser, encoder.convert(dataUser!.toMap()));
    return dataUser;
  }

  static Future<ModelUser?> getDataUser() async {
    const JsonDecoder decoder = JsonDecoder();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dispositive = prefs.getString(_dataUser) ?? "";
    if (dispositive.isEmpty) {
      return null;
    }
    return ModelUser.fromMap(decoder.convert(dispositive));
  }

  Future<bool> setStateLogin(bool state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_stateLogin, state);
  }

  static Future<bool> getStateLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_stateLogin) ?? false;
  }

  Future<bool> setStateService(bool state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_stateService, state);
  }

  static Future<bool> getStateService() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_stateService) ?? false;
  }

  Future<ModelConfigurationApp> setDataConfigurationApp(
      ModelConfigurationApp? configurationApp) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    const JsonEncoder encoder = JsonEncoder();
    prefs.setString(
        _dataConfigurationApp, encoder.convert(configurationApp!.toMap()));
    return configurationApp;
  }

  static Future<ModelConfigurationApp?> getDataConfigurationApp() async {
    const JsonDecoder decoder = JsonDecoder();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? configurationApp = prefs.getString(_dataConfigurationApp) ?? "";
    if (configurationApp.isEmpty) {
      return null;
    }
    return ModelConfigurationApp.fromMap(decoder.convert(configurationApp));
  }

  Future<bool> setStateTracking(bool state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_stateTracking, state);
  }

  static Future<bool> getStateTracking() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_stateTracking) ?? false;
  }

  Future<ResponsePointTracing> setRouterRequestOrigin(
      ResponsePointTracing routers) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    const JsonEncoder encoder = JsonEncoder();
    prefs.setString(_tracedRequestOrigin, encoder.convert(routers.toMap()));
    return routers;
  }

  static Future<ResponsePointTracing?> getRouterRequestOrigin() async {
    const JsonDecoder decoder = JsonDecoder();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? routerRequest = prefs.getString(_tracedRequestOrigin) ?? "";
    if (routerRequest.isEmpty) {
      return null;
    }
    return ResponsePointTracing.fromMap(decoder.convert(routerRequest));
  }

  Future<ResponsePointTracing> setRouterRequestDestiny(
      ResponsePointTracing routers) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    const JsonEncoder encoder = JsonEncoder();
    prefs.setString(_tracedRequestDestiny, encoder.convert(routers.toMap()));
    return routers;
  }

  static Future<ResponsePointTracing?> getRouterRequestDestiny() async {
    const JsonDecoder decoder = JsonDecoder();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? routerRequest = prefs.getString(_tracedRequestDestiny) ?? "";
    if (routerRequest.isEmpty) {
      return null;
    }
    return ResponsePointTracing.fromMap(decoder.convert(routerRequest));
  }

  Future<bool> setStreetRequest(bool state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_streetRequest, state);
  }

  static Future<bool> getStreetRequest() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_streetRequest) ?? false;
  }

  Future<bool> setSharedTravel(bool state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_sharedTravel, state);
  }

  static Future<bool> getSharedTravel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_sharedTravel) ?? false;
  }

  Future<void> setWalkiesTalkie(List<Chat> chatAudio) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedList =
        chatAudio.map((item) => jsonEncode(item.toMap())).toList();
    await prefs.setStringList(_saveAudioWalkiesTalkie, encodedList);
  }

  static Future<List<Chat>> getWalkiesTalkie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedList = prefs.getStringList(_saveAudioWalkiesTalkie);
    if (encodedList != null) {
      return encodedList.map((item) => Chat.fromMap(jsonDecode(item))).toList();
    } else {
      return [];
    }
  }

  Future<void> setChatRequest(List<Chat> chatAudio) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedList =
        chatAudio.map((item) => jsonEncode(item.toMap())).toList();
    await prefs.setStringList(_saveChatRequest, encodedList);
  }

  static Future<List<Chat>> getChatRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedList = prefs.getStringList(_saveChatRequest);
    if (encodedList != null) {
      return encodedList.map((item) => Chat.fromMap(jsonDecode(item))).toList();
    } else {
      return [];
    }
  }

  Future<ModelSearchDirection> setRecentAddress(
      ModelSearchDirection? modelSearchDirection) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    const JsonEncoder encoder = JsonEncoder();
    prefs.setString(
        _recentAddress, encoder.convert(modelSearchDirection!.toMap()));
    return modelSearchDirection;
  }

  static Future<ModelSearchDirection?> getRecentAddress() async {
    const JsonDecoder decoder = JsonDecoder();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? modelSearchDirection = prefs.getString(_recentAddress) ?? "";
    if (modelSearchDirection.isEmpty) {
      return null;
    }
    return ModelSearchDirection.fromMap(decoder.convert(modelSearchDirection));
  }

  Future<void> setTimeTravelUser(int time) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_timeTravelUser, time);
  }

  static Future<int> getTimeTravelUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_timeTravelUser) ?? 0;
  }

  Future<bool> setStatusHeatMap(bool state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_statusHeatMap, state);
  }

  static Future<bool> getStatusHeatMap() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_statusHeatMap) ?? false;
  }


  /// Delete preference
  static Future deleteTracedRequestOrigin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_tracedRequestOrigin);
  }

  static Future deleteRouterRequestDestiny() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_tracedRequestDestiny);
  }

  static Future deleteStreetRequest() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_streetRequest);
  }

  static Future deleteSharedTravel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_sharedTravel);
  }

  static Future deleteWalkiesTalkie() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_saveAudioWalkiesTalkie);
  }

  static Future deleteChatRequest() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_saveChatRequest);
  }

}
