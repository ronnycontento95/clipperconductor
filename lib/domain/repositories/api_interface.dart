import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../entities/model_login.dart';
import '../entities/model_request.dart';
import '../entities/model_user.dart';

abstract class ApiInterface {
  Future responseConsultTracing(LatLng positionInitial, LatLng positionFinal,
      int cityId, VoidCallback? Function(int code, dynamic data) callback);

  Future responseRetrievePassword(String email, int idApplication,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseConsultCountry(int idApplication,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseValidateCodeReferred(int code, int idApplication,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseSendRegister(
      int type,
      int idApplication,
      int idClient,
      int idUser,
      int idClientUser,
      int idPlatformKtaxi,
      int idRequest,
      String person,
      String email,
      String phone,
      String motive,
      String message,
      double latitude,
      double longitude,
      String versionApp,
      String versionSo,
      String brand,
      String model,
      int typeRed,
      int useGps,
      int typeConnection,
      String operator,
      String imei,
      int app,
      String selectedCountry,
      String codeSelectedCountry,
      int idCity,
      String country,
      String city,
      int idReferred,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseGainDay(
      int idUser, VoidCallback? Function(int code, dynamic data) callback);

  Future responseConsultTaximeter(
      int idCity,
      int idApplication,
      int activeServiceId,
      int idTypePay,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseConsultTaximeterStreetRequest(
      int idCity, int idApplication, Function(int code, dynamic data) callback);

  Future responseServiceActive(int idCity, int vehicleId,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseSaveContact(
      int idUser,
      int idApplication,
      int idCity,
      String name,
      String contact,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseEnableContact(int idUser, int idContact,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseRegisterDispositive(
      int idUser,
      String idDispositive,
      String brand,
      String model,
      String versionSystem,
      String versionApplication,
      double latitude,
      double longitude,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseLogOut(int idUser, int idApplication,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseUpdatePassword(
      int idUser,
      String formerPassword,
      String newPassword,
      int idApplication,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseNotification(int idUser, int since, int number,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseQualificationDriver(
      int idUser, VoidCallback? Function(int code, dynamic data) callback);

  Future responseCodeReferredDriver(int type, int idUser, int idAplicative,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseBalanceDriver(int idVehicle, int idUser, int idCity,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseDebts(
      int idUser, VoidCallback? Function(int code, dynamic data) callback);

  Future responsePayDebts(int idUser, int idDebts,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseTransaction(int year, int month, int idVehicle, int idUser,
      int idCity, VoidCallback? Function(int code, dynamic data) callback);

  Future responseNumberHistoryRequest(int idUser, int year, int month, int type,
      VoidCallback? Function(dynamic data) callback);

  Future responseHistoryRequest(
      int idUser,
      int year,
      int month,
      int type,
      int since,
      int number,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseHistoryOrder(
      int idUser,
      int year,
      int month,
      int type,
      int since,
      int number,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseWatchNotification(int idUser, int idBulletin);

  Future responseReplyQuestion(
      int idUser,
      int idBulletin,
      int idBulletinQuestion,
      String reply,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseBuyPackage(
      int idUser,
      String token,
      String key,
      String timeStanD,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responsePackageRecharge(
      int idUser,
      int idVehicle,
      int idCity,
      int idPackageType,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responsePackagePending(
      String timeStanD,
      String token,
      String key,
      int idApplication,
      int idUser,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseDetailPackage(int idPackage, String timeStanD, String key,
      String token, VoidCallback? Function(int code, dynamic data) callback);

  Future responseBuyPackagePending(
      int idPackage,
      int application,
      int idUser,
      int idCity,
      String timeStanD,
      String token,
      String key,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseCanceledPackagePending(
      String timeStanD,
      String token,
      String key,
      int idUser,
      int idPackageUser,
      int idDebt,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseListContact(int idUser, int application, int idCity,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseDisableContact(int idUser, int idContact,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseRequestDay(int idUser, String day, String moth, String year,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseDirectionForCoordinate(double latitude, double longitude,
      VoidCallback? Function(dynamic data) callback);

  Future responseRouteSuggestion(
      double latitudeOrigin,
      double longitudeOrigin,
      double latitudeDestiny,
      double longitudeDestiny,
      int idApplicative,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseLocked(int idUser);

  Future responseUnlock(int idUser, VoidCallback? Function(int code) callback);

  Future responseAcceptCancellation(int idUser, int idConfigurationPenalty);

  Future responseSaveAnomaly(
      int idUser,
      int idVehicle,
      String plate,
      String color,
      String commentary,
      double latitudeOrigin,
      double longitudeOrigin,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseSaveImageAnomaly(String image, String nameFile,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseTrackingDriver(dynamic dataTracking,
      VoidCallback? Function(int code, dynamic data) callback);

  /**
   * NEW REST API
   */

  /// Consult in progress
  Future responseInProgress(int idUser, int idVehicle,
      VoidCallback? Function(int code, dynamic data) callback);

  /// Consult in progressById
  Future responseInProgressById(int idRequest, int idUser, int idVehicle,
      VoidCallback? Function(int code, dynamic data) callback);

  /// Send event
  Future responseSendEvent(
      ModelUser modelUser,
      double latitude,
      double longitude,
      int type,
      int idRequest,
      double distance,
      VoidCallback? Function(int code, dynamic data) callback);

  /// Send postulation
  Future responseSendPostulation(
      ModelUser modelUser,
      int time,
      double distance,
      double cost,
      int idRequest,
      VoidCallback? Function(int code, dynamic data) callback);

  /// Cancelled request before postulation
  Future responseCancelRequestBeforePostulation(
      ModelRequest modelRequest,
      int state,
      int idEventuality,
      int idUser,
      VoidCallback? Function(int code, dynamic data) callback);

  /// Cancelled request street
  Future responseCancelRequestStreet(
      ModelRequest modelRequest,
      int state,
      int idEventuality,
      int idUser,
      VoidCallback? Function(int code, dynamic data) callback);

  /// Send board
  Future responseSendBoard(int requestId, int state, int board, double latitude,
      double longitude, VoidCallback? Function(int code) callback);

  /// Send board call center
  Future responseSendBoardCallCenter(
      int requestId,
      int state,
      int board,
      double latitude,
      double longitude,
      VoidCallback? Function(int code) callback);

  /// Recover distance taximeter
  Future responseDistanceTaximeter(int vehicleId, int requestId,
      VoidCallback? Function(int code, dynamic data) callback);

  /// Get list eventuality cancel
  Future responseEventualityCancel(
      VoidCallback? Function(int code, dynamic data) callback);

  /// LogIn
  Future responseLogIn(ModelLogIn modelLogIn,
      VoidCallback? Function(int code, dynamic data) callback);

  /// LogIn for vehicle
  Future responseLogInForVehicle(ModelUser modelUser, String imei,
      String version, VoidCallback? Function(int code, dynamic data) callback);

  Future responseUpdateStateDriver(int vehicleId, int state,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseSearchDirection(
      int cityId,
      String search,
      double latitude,
      double longitude,
      int distance,
      VoidCallback? Function(dynamic data) callback);

  Future responseCoordinateDirection(int cityId, String placeId,
      VoidCallback? Function(dynamic data) callback);

  Future responseSuggestionDirection(
      double latitudeOrigin,
      double longitudeOrigin,
      double latitudeDestiny,
      double longitudeDestiny,
      int idApplicative,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseRequestStreet(
      dynamic data, VoidCallback? Function(int code) callback);

  Future responseAboardRequestStreet(
      int requestId,
      int state,
      int aboard,
      double latitude,
      double longitude,
      VoidCallback? Function(int code) callback);

  Future responseDeclineRequest(
      int requestId, int userId, VoidCallback? Function(int code) callback);

  Future responseFinalizeStreetRequest(
      double cost,
      double tips,
      double costDistance,
      double costToll,
      int requestId,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseFinalizeRequestCallCenter(
      double cost,
      double tips,
      double costDistance,
      double costToll,
      int requestId,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseSendWaitTime(int requestId, int vehicleId, int deviceId,
      String waitTime, VoidCallback? Function(int code, dynamic data) callback);

  Future responseTotalRating(
      int userId, VoidCallback? Function(int code, dynamic data) callback);

  Future responseLogOutRemote(int userId, int vehicleId,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responsePaymentHybrid(
      int requestId, VoidCallback? Function(int code, dynamic data) callback);

  Future responseSendPaymentHybrid(
      int requestId,
      int userId,
      String toll,
      String careerCost,
      String finalCostWithDiscount,
      String finalCostWithoutDiscount,
      String tip,
      double latitude,
      double longitude,
      bool statusErrorCard,
      dynamic paymentMethods,
      dynamic discount,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseGetDayStatistics(int vehicleId, int deviceId,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseSaveDayStatistics(int vehicleId, int deviceId, double distance,
      String time, VoidCallback? Function(int code, dynamic data) callback);

  Future responseSaveTaximeter(
      int requestId,
      int userId,
      int vehicleId,
      int type,
      double latitudeOrigin,
      double longitudeOrigin,
      double costTaximeter,
      double costPayment,
      double latitudeFinish,
      double longitudeFinish,
      String hourEnd,
      double startRate,
      String totalTime,
      String waitTime,
      double costTime,
      int distanceTravel,
      double costDistance,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseMessageChat(int idCity, int idApplicative, int type,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseQualificationUser(
      int requestId,
      double latitude,
      double longitude,
      int qualify,
      String observation,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseAcceptTravelCallCenter(ModelRequest modelRequest,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseSaveErrorApp(String message, String error, String version,
      int userId, VoidCallback? Function(int code, dynamic data) callback);

  Future responseHeatMap(
      int cityId, VoidCallback? Function(int code, dynamic data) callback);

  Future responseMessageReferred(
      int cityId, VoidCallback? Function(int code, dynamic data) callback);

  Future responseSaveFileRequest(
      String file,
      int requestId,
      int userId,
      int clientId,
      int type,
      VoidCallback? Function(int code, dynamic data) callback);

  Future responseVerifyIdentity(
      String image,
      int identification,
      String name,
      String lastName,
      String businessId,
      String vehicleId,
      String registerId,
      VoidCallback? Function(int code, dynamic data) callback);
}
