import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/model_coordinate_direction.dart';
import '../../domain/entities/model_direction_for_coordinate.dart';
import '../../domain/entities/model_login.dart';
import '../../domain/entities/model_recover_distance_taximeter.dart';
import '../../domain/entities/model_request.dart';
import '../../domain/entities/model_user.dart';
import '../../domain/repositories/api_interface.dart';
import '../../ui/util/global_function.dart';
import '../../ui/util/global_label.dart';
import '../response/response_day_statistics.dart';
import '../response/response_heat_map.dart';
import '../response/response_message_chat.dart';
import '../response/response_message_referred.dart';
import '../response/response_payment_hybrid.dart';
import '../response/response_search_direction.dart';
import '../response/response_balance.dart';
import '../response/response_contact_user.dart';
import '../response/response_country.dart';
import '../response/response_debts.dart';
import '../response/response_detail_package.dart';
import '../response/response_eventuality.dart';
import '../response/response_gain_day.dart';
import '../response/response_history_order.dart';
import '../response/response_history_request.dart';
import '../response/response_notification_business.dart';
import '../response/response_package_pending.dart';
import '../response/response_package_recharge.dart';
import '../response/response_package_request.dart';
import '../response/response_point_tracing.dart';
import '../response/response_request.dart';
import '../response/response_request_day.dart';
import '../response/response_service_active.dart';
import '../response/response_suggestion_destination.dart';
import '../response/response_taximeter.dart';
import '../response/response_total_qualification.dart';
import '../response/response_transaction.dart';

class ApiRest implements ApiInterface {
  Dio dio = Dio();

  @override
  Future responseRetrievePassword(String email, int idApplication,
      VoidCallback? Function(int t, dynamic data) callback) async {
    const url =
        "${GlobalLabel.ipConnection}ktaxi-driver/recuperar-contrasenia-driver";
    final data = {
      'usuario': email,
      'idAplicativo': idApplication,
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT RETRIEVE PASSWORD >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['estado'], response.data['mensaje']);
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseConsultCountry(int idApplication,
      VoidCallback? Function(int t, dynamic data) callback) async {
    const url =
        "${GlobalLabel.ipConnectionOld}u/pre-registro/consultar-paises/";
    final data = {
      'idAplicativo': idApplication,
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT LIST COUNTRY >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['en'], ResponseCountry.fromMap(response.data));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseValidateCodeReferred(int code, int idApplication,
      VoidCallback? Function(int t, dynamic data) callback) async {
    const url = "${GlobalLabel.ipConnection}referidos/consultar-codigo";
    final data = {
      'codigo': code,
      'idAplicativo': idApplication,
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT CODE REFERRED >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['en'], response.data['m']);
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
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
      VoidCallback? Function(int t, dynamic data) callback) async {
    const url = "${GlobalLabel.ipConnectionOld}feedback/enviar-contactenos";
    final data = {
      'tipo': type,
      'idAplicativo': idApplication,
      'idCliente': idClient,
      'idUsuario': idUser,
      'idClienteUsuario': idClientUser,
      'idPlataformaKtaxi': idPlatformKtaxi,
      'idSolicitud': idRequest,
      'persona': person,
      'correo': email,
      'telefono': phone,
      'motivo': motive,
      'mensaje': message,
      'latitud': latitude,
      'longitud': longitude,
      'versionApp': versionApp,
      'versionSo': versionSo,
      'marca': brand,
      'modelo': model,
      'tipoRed': typeRed,
      'usandoGps': useGps,
      'tipoConexion': typeConnection,
      'operadora': operator,
      'imei': imei,
      'app': app,
      'paisSeleccionado': selectedCountry,
      'codigoPaisSeleccionado': codeSelectedCountry,
      'idCiudad': idCity,
      'pais': country,
      'ciudad': city,
      'idReferido': idReferred,
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT PRE REGISTER >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['estado'], response.data['mensaje']);
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseGainDay(
      int idUser, VoidCallback? Function(int t, dynamic data) callback) async {
    const url = "${GlobalLabel.ipConnectionOld}u/ganancias/gananciasDiarias";
    final data = {
      'idUsuario': idUser,
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT GAIN DAY >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['en'], ResponseGainDay.fromMap(response.data));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseConsultTaximeterStreetRequest(int idCity, int idApplication,
      Function(int t, dynamic data) callback) async {
    const url = "${GlobalLabel.ipConnectionOld}API/taximetro/consultar-tarifas";
    final data = {
      'idCiudad': idCity,
      'idAplicativo': idApplication,
    };
    try {
      final response = await dio.put(url, data: data);
      if (kDebugMode) {
        print('RESULT CONSULT TAXIMETER STREET >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['en'], ResponseTaximeter.fromMap(response.data));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseSaveContact(
      int idUser,
      int idApplication,
      int idCity,
      String name,
      String contact,
      VoidCallback? Function(int t, dynamic data) callback) async {
    const url = "${GlobalLabel.ipConnection}u/contactos/createContacto";
    final data = {
      'idUsuario': idUser,
      'idAplicativo': idApplication,
      'idCiudad': idCity,
      'nombre': name,
      'numero': contact,
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT SAVE CONTACT >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['en'], response.data['m']);
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseEnableContact(int idUser, int idContact,
      VoidCallback? Function(int t, dynamic data) callback) async {
    const url = "${GlobalLabel.ipConnection}u/contactos/enableContacto";
    final data = {
      'idUsuario': idUser,
      'idContacto': idContact,
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT ENABLE CONTACT >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['en'], response.data['m']);
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseUpdatePassword(
      int idUser,
      String formerPassword,
      String newPassword,
      int idApplication,
      VoidCallback? Function(int t, dynamic data) callback) async {
    const url = "${GlobalLabel.ipConnection}ktaxi-driver/cambiar-clave-driver";
    final data = {
      'idUsuario': idUser,
      'claveAnterior': formerPassword,
      'claveNueva': newPassword,
      'idAplicativo': idApplication,
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT UPDATE PASSWORD >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['estado'], response.data['mensaje']);
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseQualificationDriver(int idUser,
      VoidCallback? Function(int code, dynamic data) callback) async {
    final url =
        "${GlobalLabel.ipConnectionOld}ktaxi-driver/valoracion/usuario/promedio/$idUser";
    try {
      final response = await dio.get(url);
      if (kDebugMode) {
        print('RESULT QUALIFICATION DRIVER >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['estado'], response.data['valoracion']);
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseCodeReferredDriver(int type, int idUser, int idAplicative,
      VoidCallback? Function(int code, dynamic data) callback) async {
    const url = "${GlobalLabel.ipConnection}referidos/listar-codigos";
    final data = {
      'tipo': type,
      'idUsuario': idUser,
      'idAplicativo': idAplicative,
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT CODE REFERRED DRIVER >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseBalanceDriver(int idVehicle, int idUser, int idCity,
      VoidCallback? Function(int code, dynamic data) callback) async {
    const url = "${GlobalLabel.ipConnectionOld}u/saldo/consultar";
    final data = {
      'idVehiculo': idVehicle,
      'idUsuario': idUser,
      'idCiudad': idCity,
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT BALANCE DRIVER >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['en'], ResponseBalance.fromMap(response.data));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseDebts(int idUser,
      VoidCallback? Function(int code, dynamic data) callback) async {
    const url =
        "${GlobalLabel.ipConnectionOld}pagosElectonicos/consultarDeudas";
    final data = {'idUsuario': idUser};
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT DEBTS >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['en'], ResponseDebts.fromMap(response.data));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responsePayDebts(int idUser, int idDebts,
      VoidCallback? Function(int code, dynamic data) callback) async {
    const url = "${GlobalLabel.ipConnection}pagosElectonicos/pagarDeudas";
    final data = {'idUsuario': idUser, 'idDeuda': idDebts};
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT PAY DEBTS >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['en'], response.data['m']);
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseTransaction(
      int year,
      int month,
      int idVehicle,
      int idUser,
      int idCity,
      VoidCallback? Function(int code, dynamic data) callback) async {
    const url = "${GlobalLabel.ipConnectionOld}u/saldo/consultar-transacciones";
    final data = {
      'anio': year,
      'mes': month,
      'idVehiculo': idVehicle,
      'idUsuario': idUser,
      'idCity': idCity
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT TRANSACTION >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['en'], ResponseTransaction.fromMap(response.data));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseNumberHistoryRequest(int idUser, int year, int month, int type,
      VoidCallback? Function(dynamic data) callback) async {
    final url =
        "${GlobalLabel.ipConnectionOld}ktaxi-driver/historial/anio-mes/$idUser/$year/$month/$type";
    try {
      final response = await dio.get(url);
      if (kDebugMode) {
        print('RESULT NUMBER HISTORY REQUEST >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['registros']);
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseHistoryRequest(
      int idUser,
      int year,
      int month,
      int type,
      int since,
      int number,
      VoidCallback? Function(int code, dynamic data) callback) async {
    const url =
        "${GlobalLabel.ipConnectionOld}ktaxi-driver/historial/anio-mes/driver";
    final data = {
      'idUsuario': idUser,
      'anio': year,
      'mes': month,
      'tipo': type,
      'desde': since,
      'cuantos': number
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT HISTORY REQUEST >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(
          response.data['en'], ResponseHistoryRequest.fromMap(response.data));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseHistoryOrder(
      int idUser,
      int year,
      int month,
      int type,
      int since,
      int number,
      VoidCallback? Function(int code, dynamic data) callback) async {
    const url =
        "${GlobalLabel.ipConnectionOld}ktaxi-driver/historial/anio-mes-pedidos/driver";
    final data = {
      'idUsuario': idUser,
      'anio': year,
      'mes': month,
      'tipo': type,
      'desde': since,
      'cuantos': number
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT HISTORY ORDER >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(
          response.data['en'], ResponseHistoryOrder.fromMap(response.data));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseWatchNotification(int idUser, int idBulletin) async {
    const url = "${GlobalLabel.ipConnectionOld}boletines_usuarios";
    final data = {'idUsuario': idUser, 'idBoletin': idBulletin};
    try {
      final response = await dio.put(url, data: data);
      if (kDebugMode) {
        print('RESULT WATCH NOTIFICATION >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseReplyQuestion(
      int idUser,
      int idBulletin,
      int idBulletinQuestion,
      String reply,
      VoidCallback? Function(int code, dynamic data) callback) async {
    const url = "${GlobalLabel.ipConnection}boletines_usuarios/responder";
    final data = {
      'idUsuario': idUser,
      'idBoletin': idBulletin,
      'idBoletinPregunta': idBulletinQuestion,
      'respuesta': reply
    };
    try {
      final response = await dio.put(url, data: data);
      if (kDebugMode) {
        print('RESULT REPLY QUESTION >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['en'], response.data['m']);
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseBuyPackage(
      int idUser,
      String token,
      String key,
      String timeStanD,
      VoidCallback? Function(int code, dynamic data) callback) async {
    const url = "${GlobalLabel.ipConnectionOld}c/paquetes/obtener";
    final data = {
      'idUsuario': idUser.toString(),
      'token': token,
      'key': key,
      'timeStanD': timeStanD,
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT PACKAGE REQUEST >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(
          response.data['en'], ResponsePackageRequest.fromMap(response.data));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responsePackagePending(
      String timeStanD,
      String token,
      String key,
      int idApplication,
      int idUser,
      VoidCallback? Function(int code, dynamic data) callback) async {
    const url = "${GlobalLabel.ipConnectionOld}c/paquetes/paquetePendiente";
    final data = {
      'timeStanD': timeStanD,
      'token': token,
      'key': key,
      'idAplicativo': idApplication.toString(),
      'idUsuario': idUser.toString(),
    };
    try {
      final response = await dio.post(url,
          data: data, options: Options(headers: {'version': '1.0.0'}));
      if (kDebugMode) {
        print('RESULT PACKAGE PENDING >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(
          response.data['en'], ResponsePackagePending.fromMap(response.data));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseDetailPackage(
      int idPackage,
      String timeStanD,
      String key,
      String token,
      VoidCallback? Function(int code, dynamic data) callback) async {
    const url = "${GlobalLabel.ipConnection}c/paquetes/detallePaquete";
    final data = {
      'idPaquete': idPackage.toString(),
      'timeStanD': timeStanD,
      'key': key,
      'token': token,
    };
    try {
      final response = await dio.post(url,
          data: data, options: Options(headers: {'version': '1.0.0'}));
      if (kDebugMode) {
        print('RESULT DETAIL PACKAGE >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(
          response.data['en'], ResponseDetailPackage.fromMap(response.data));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseBuyPackagePending(
      int idPackage,
      int application,
      int idUser,
      int idCity,
      String timeStanD,
      String token,
      String key,
      VoidCallback? Function(int code, dynamic data) callback) async {
    const url = "${GlobalLabel.ipConnection}c/paquetes/comprarPaquete";
    final data = {
      'idPaquete': idPackage.toString(),
      'idAplicativo': application.toString(),
      'idUsuario': idUser.toString(),
      'idCiudad': idCity.toString(),
      'timeStanD': timeStanD.toString(),
      'token': token,
      'key': key,
    };
    try {
      final response = await dio.post(url,
          data: data, options: Options(headers: {'version': '1.0.0'}));
      if (kDebugMode) {
        print('RESULT BUY PACKAGE >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['en'], response.data['m']);
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseCanceledPackagePending(
      String timeStanD,
      String token,
      String key,
      int idUser,
      int idPackageUser,
      int idDebt,
      VoidCallback? Function(int code, dynamic data) callback) async {
    const url = "${GlobalLabel.ipConnection}c/paquetes/cancelarPaquete";
    final data = {
      'timeStanD': timeStanD,
      'token': token,
      'key': key,
      'idUsuario': idUser.toString(),
      'idPaqueteUsuario': idPackageUser.toString(),
      'idDeuda': idDebt.toString(),
    };
    try {
      final response = await dio.post(url,
          data: data, options: Options(headers: {'version': '1.0.0'}));
      if (kDebugMode) {
        print('RESULT CANCELED PACKAGE PENDING >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['en'], response.data['m']);
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseListContact(int idUser, int idApplication, int idCity,
      VoidCallback? Function(int t, dynamic data) callback) async {
    const url = "${GlobalLabel.ipConnection}u/contactos/listaContacto";
    final data = {
      'idUsuario': idUser,
      'idAplicativo': idApplication,
      'idCiudad': idCity,
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT LIST CONTACT >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['en'], ResponseContactUser.fromMap(response.data));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseDisableContact(int idUser, int idContact,
      VoidCallback? Function(int t, dynamic data) callback) async {
    const url = "${GlobalLabel.ipConnection}u/contactos/disableContacto";
    final data = {
      'idUsuario': idUser,
      'idContacto': idContact,
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT DISABLE CONTACT >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['en'], response.data['m']);
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseRequestDay(int idUser, String day, String month, String year,
      VoidCallback? Function(int t, dynamic data) callback) async {
    const url = "${GlobalLabel.ipConnectionOld}u/ganancias/solicitudesHoy";
    final data = {'idUsuario': idUser, 'dia': day, 'mes': month, 'anio': year};
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT REQUEST DAY >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['en'], ResponseRequestDay.fromMap(response.data));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseRouteSuggestion(
      double latitudeOrigin,
      double longitudeOrigin,
      double latitudeDestiny,
      double longitudeDestiny,
      int idApplicative,
      VoidCallback? Function(int code, dynamic data) callback) async {
    final url =
        "${GlobalLabel.ipConnection}servicioActivo/getDestinationRoute/route/$latitudeOrigin/$longitudeOrigin/$latitudeDestiny/$longitudeDestiny/$idApplicative";
    try {
      final response =
          await dio.get(url, options: Options(headers: {'version': '2.0.0'}));
      if (kDebugMode) {
        print('RESULT ROUTE SUGGESTION >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['en'],
          ResponseSuggestionDestination.fromMap(response.data));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseLocked(int idUser) async {
    const url = "${GlobalLabel.ipConnection}API/bloqueo/verificar";
    final data = {
      'idUsuario': idUser,
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT LOCKED >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseUnlock(
      int idUser, VoidCallback? Function(int code) callback) async {
    const url = "${GlobalLabel.ipConnection}API/bloqueo/estado";
    final data = {
      'idUsuario': idUser,
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT UNLOCK >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['en']);
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseAcceptCancellation(
      int idUser, int idConfigurationPenalty) async {
    const url = "${GlobalLabel.ipConnection}API/bloqueo/aceptar_cancelacion";
    final data = {
      'idUsuario': idUser,
      'idConfiguracionPenalizacion': idConfigurationPenalty
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT SEND VIEW CANCELED >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseSaveAnomaly(
      int idUser,
      int idVehicle,
      String plate,
      String color,
      String commentary,
      double latitudeOrigin,
      double longitudeOrigin,
      VoidCallback? Function(int code, dynamic data) callback) async {
    const url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}${GlobalLabel.versionRest}/reporte-piratas/reportar";
    final data = {
      "idUsuario": idUser,
      "idVehiculo": idVehicle,
      "placa": plate,
      "color": color,
      "denuncia": commentary,
      "latitud": latitudeOrigin,
      "longitud": longitudeOrigin,
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT ANOMALY >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['en'], response.data['id'].toString());
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseSaveImageAnomaly(String image, String nameFile,
      VoidCallback? Function(int code, dynamic data) callback) async {
    const url = "${GlobalLabel.urlUploadImage}archivos/piratas/subir-pirata";
    FormData data = FormData.fromMap({
      "imagen": await MultipartFile.fromFile(image, filename: nameFile),
      'name': 'upload_test',
    });
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT IMAGE ANOMALY >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data["en"], response.data["m"]);
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  /**
   * NEW REST API
   */

  /// Send LogIn
  @override
  Future responseLogIn(ModelLogIn modelLogIn,
      VoidCallback? Function(int t, dynamic data) callback) async {
    const url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}${GlobalLabel.versionRest}/user/login";
    final data = {
      'user': modelLogIn.user,
      'password': modelLogIn.password,
      'applicationId': modelLogIn.applicationId,
      'deviceId': modelLogIn.deviceId,
      'version': modelLogIn.version,
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT LOGIN >>> $response');
      }
      if (response.data == null ||
          !response.data.toString().contains('statusCode')) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['statusCode'], response.data);
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  /// Send LogIn for vehicle
  @override
  Future responseLogInForVehicle(
      ModelUser modelUser,
      String imei,
      String version,
      VoidCallback? Function(int t, dynamic data) callback) async {
    const url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}${GlobalLabel.versionRest}/user/loginForVehicle";
    final data = {
      'vehicleId': modelUser.idVehicle,
      'userId': modelUser.idUser,
      'version': version,
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT LOGIN FOR VEHICLE >>> $response');
      }
      if (response.data == null ||
          !response.data.toString().contains('statusCode')) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['statusCode'], response.data);
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  /// Send tracking driver
  @override
  Future responseTrackingDriver(dynamic dataTracking,
      VoidCallback? Function(int t, dynamic data) callback) async {
    const url = "${GlobalLabel.ipConnectionTracking}tracking";
    try {
      final response = await dio.post(url, data: dataTracking);
      if (kDebugMode) {
        print('RESULT TRACKING DRIVER >>> $response');
      }
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  /// Consult in progress
  @override
  Future responseInProgress(int idUser, int idVehicle,
      VoidCallback? Function(int code, dynamic data) callback) async {
    final url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}${GlobalLabel.versionRest}/request/inProgress/$idUser/$idVehicle";
    try {
      final response = await dio.get(url);
      if (kDebugMode) {
        GlobalFunction().printWrapped('RESULT IN PROGRESS >>> $response');
      }
      if (response.data == null ||
          !response.data.toString().contains('statusCode')) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }

      callback(
          response.data['statusCode'], ResponseRequest.fromMap(response.data));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  /// Send event
  @override
  Future responseSendEvent(
      ModelUser modelUser,
      double latitude,
      double longitude,
      int typeEvent,
      int idRequest,
      double distance,
      VoidCallback? Function(int code, dynamic data) callback) async {
    const url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}/${GlobalLabel.versionRest}/user/notification/event";
    final data = {
      'userId': modelUser.idUser!,
      'vehicleId': modelUser.idVehicle!,
      'cityId': modelUser.idCity!,
      'data': {
        'latitude': latitude,
        'longitude': longitude,
        'distance': distance,
        'type': typeEvent,
        'requestId': idRequest
      }
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT SEND EVENT >>> $response');
      }
      if (response.data == null &&
          !response.data.toString().contains("statusCode")) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      if (response.toString().contains('statusCode')) {
        callback(response.data["statusCode"], response.data["message"]);
      }
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  /// Send postulation request
  @override
  Future responseSendPostulation(
      ModelUser modelUser,
      int time,
      double distance,
      double cost,
      int idRequest,
      VoidCallback? Function(int code, dynamic data) callback) async {
    const url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}${GlobalLabel.versionRest}/request/assignedTime";

    final data = {
      'requestId': idRequest,
      'userId': modelUser.idUser!,
      'data': {
        'attendedFrom': 1,
        'companyId': modelUser.idBusiness!,
        'vehicleId': modelUser.idVehicle!,
        'name': modelUser.name,
        'lastName': modelUser.lastName,
        'image': modelUser.imageDriver,
        'plate': modelUser.vehiclePlate,
        'municipalRegistry': modelUser.regMunVehicle,
        'company': modelUser.business,
        'phone': modelUser.phone,
        'vehicle': modelUser.unitVehicle,
        'time': time,
        'distance': distance,
        'cost': cost,
        'state': 4,
        'unit': modelUser.unitVehicle,
      }
    };

    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT SEND POSTULATION >>> $response');
      }

      if (response.data == null &&
          !response.data.toString().contains("statusCode")) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      if (response.toString().contains('statusCode')) {
        callback(response.data["statusCode"], response.data["message"]);
      }
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  /// Cancelled request before postulation
  @override
  Future responseCancelRequestBeforePostulation(
      ModelRequest modelRequest,
      int state,
      int idEventuality,
      int idUser,
      VoidCallback? Function(int t, dynamic data) callback) async {
    const url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}${GlobalLabel.versionRest}/cancel";
    final data = {
      'requestId': modelRequest.requestData!.requestId,
      'state': state,
      'eventualityId': idEventuality,
      'userId': idUser
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT CANCEL REQUEST >>> $response');
      }
      if (response.data == null &&
          !response.data.toString().contains("statusCode")) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      if (response.toString().contains('statusCode')) {
        callback(response.data["statusCode"], response.data["message"]);
      }
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseConsultTracing(
      LatLng positionInitial,
      LatLng positionFinal,
      int cityId,
      VoidCallback? Function(int code, dynamic data) callback) async {
    final coordinate =
        '${positionInitial.latitude}/${positionInitial.longitude}/'
        '${positionFinal.latitude}/${positionFinal.longitude}';

    final url = "${GlobalLabel.ipConnection}${GlobalLabel.server}"
        "${GlobalLabel.versionRest}/maps/route/$coordinate";
    try {
      final response = await dio.get(url);
      if (kDebugMode) {
        print('RESULT CONSULT TRACING >>> $response');
      }
      if (response.data == null &&
          !response.data.toString().contains("statusCode")) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['statusCode'],
          ResponsePointTracing.fromMap(response.data['data']));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseSendBoard(int requestId, int state, int board, double latitude,
      double longitude, VoidCallback? Function(int t) callback) async {
    const url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}${GlobalLabel.versionRest}/board";
    final data = {
      'requestId': requestId,
      'state': state,
      'board': board,
      'latitude': latitude,
      'longitude': longitude,
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT SEND BOARD >>> $response');
      }

      if (response.data == null &&
          !response.data.toString().contains("statusCode")) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data["statusCode"]);
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseSendBoardCallCenter(
      int requestId,
      int state,
      int board,
      double latitude,
      double longitude,
      VoidCallback? Function(int t) callback) async {
    const url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}${GlobalLabel.versionRest}/board/call";
    final data = {
      'requestId': requestId,
      'state': state,
      'board': board,
      'latitude': latitude,
      'longitude': longitude,
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT SEND BOARD >>> $response');
      }

      if (response.data == null &&
          !response.data.toString().contains("statusCode")) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data["statusCode"]);
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  /// Recover distance taximeter
  @override
  Future responseDistanceTaximeter(int vehicleId, int requestId,
      VoidCallback? Function(int code, dynamic data) callback) async {
    final url =
        "${GlobalLabel.ipConnectionTracking}tracking/board/$vehicleId/$requestId";
    try {
      final response = await dio.get(url);
      if (kDebugMode) {
        print('RESULT RECOVER DISTANCE TAXIMETER >>> $response');
      }
      if (response.data == null ||
          !response.data.toString().contains('statusCode')) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }

      callback(response.data['statusCode'],
          ModelRecoverDistanceTaximeter.fromMap(response.data['data']));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  /// Get list eventuality cancel
  @override
  Future responseEventualityCancel(
      VoidCallback? Function(int code, dynamic data) callback) async {
    const url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}${GlobalLabel.versionRest}/request/eventuality";

    try {
      final response = await dio.get(url);
      if (kDebugMode) {
        print('RESULT EVENTUALITY CANCEL >>> $response');
      }
      if (response.data == null ||
          !response.data.toString().contains('statusCode')) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }

      callback(response.data['statusCode'],
          ResponseEventuality.fromMap(response.data['data']));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseRegisterDispositive(
      int idUser,
      String idDispositive,
      String brand,
      String model,
      String versionSystem,
      String versionApplication,
      double latitude,
      double longitude,
      VoidCallback? Function(int t, dynamic data) callback) async {
    const url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}${GlobalLabel.versionRest}/user/imeiDriverRegister";
    final data = {
      'userId': idUser,
      'deviceId': idDispositive,
      'brand': brand,
      'model': model,
      'versionSo': versionSystem,
      'versionApplication': versionApplication,
      'latitude': latitude,
      'longitude': longitude,
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT REGISTER DISPOSITIVE >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['statusCode'], response.data['message']);
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseConsultTaximeter(
      int idCity,
      int idApplication,
      int activeServiceId,
      int idTypePay,
      VoidCallback? Function(int t, dynamic data) callback) async {
    const url = "${GlobalLabel.ipConnectionOld}API/taximetro/consultar-tarifas";
    final data = {
      'idCiudad': idCity,
      'idAplicativo': idApplication,
      'idServicioActivo': activeServiceId,
      'idFormaPago': idTypePay
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT CONSULT TAXIMETER >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['en'], ResponseTaximeter.fromMap(response.data));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseLogOut(int idUser, int idApplication,
      VoidCallback? Function(int t, dynamic data) callback) async {
    const url =
        "${GlobalLabel.ipConnectionOld}ktaxi-driver/cerrar-session-driver";
    final data = {
      'idUsuario': idUser,
      'idAplicativo': idApplication,
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT LOG OUT >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['estado'], response.data['mensaje']);
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseUpdateStateDriver(int vehicleId, int state,
      VoidCallback? Function(int t, dynamic data) callback) async {
    const url = "${GlobalLabel.ipConnectionTracking}tracking/changeState";
    final data = {
      'vehicleId': vehicleId,
      'state': state,
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT UPDATE STATE DRIVER >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseSearchDirection(
      int cityId,
      String search,
      double latitude,
      double longitude,
      int distance,
      VoidCallback? Function(dynamic data) callback) async {
    final url =
        "https://investigacion.kradac.com/rocket/autocomplete/$cityId/$search/$latitude/$longitude/$distance";

    try {
      final response = await dio.get(url);
      if (kDebugMode) {
        print('RESULT SEARCH DIRECTION >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(ResponseSearchDirection.fromMap(response.data));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseCoordinateDirection(int cityId, String placeId,
      VoidCallback? Function(dynamic data) callback) async {
    final url =
        "https://investigacion.kradac.com/rocket/geocode/$cityId/$placeId";

    try {
      final response = await dio.get(url);
      if (kDebugMode) {
        print('RESULT COORDINATE DIRECTION >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(ModelCoordinateDirection.fromMap(response.data));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseSuggestionDirection(
      double latitudeOrigin,
      double longitudeOrigin,
      double latitudeDestiny,
      double longitudeDestiny,
      int idApplicative,
      VoidCallback? Function(int code, dynamic data) callback) async {
    final url =
        "${GlobalLabel.ipConnectionOld}servicioActivo/getDestinationRoute/route/$latitudeOrigin/$longitudeOrigin/$latitudeDestiny/$longitudeDestiny/$idApplicative";

    try {
      final response = await dio.get(url);
      if (kDebugMode) {
        print('RESULT SUGGESTION DIRECTION >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['en'],
          ResponseSuggestionDestination.fromMap(response.data));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseDirectionForCoordinate(double latitude, double longitude,
      VoidCallback? Function(dynamic data) callback) async {
    final url =
        "http://investigacion.kradac.com:3000/direccion?username=frsisalimao&lat=$latitude&lng=$longitude";
    try {
      final response = await dio.get(url);
      if (kDebugMode) {
        print('RESULT DIRECTION FOR COORDINATE >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(ModelDirectionForCoordinate.fromMap(response.data));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseRequestStreet(
      dynamic data, VoidCallback? Function(int t) callback) async {
    const url = "${GlobalLabel.ipConnectionOld}API/chile/solicitar";
    try {
      final response = await dio.post(url,
          data: data, options: Options(headers: {'version': '2'}));
      if (kDebugMode) {
        print('RESULT REQUEST STREET >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['en']);
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseAboardRequestStreet(
      int requestId,
      int state,
      int aboard,
      double latitude,
      double longitude,
      VoidCallback? Function(int t) callback) async {
    const url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}${GlobalLabel.versionRest}/board/street";
    final data = {
      'requestId': requestId,
      'state': state,
      'board': aboard,
      'latitude': latitude,
      'longitude': longitude
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT SEND BOARD REQUEST STREET >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseDeclineRequest(
      int requestId, int userId, VoidCallback? Function(int t) callback) async {
    const url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}${GlobalLabel.versionRest}/request/declineRequest";
    final data = {
      'requestId': requestId,
      'userId': userId,
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT DECLINE REQUEST >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseFinalizeStreetRequest(
      double cost,
      double tips,
      double costDistance,
      double costToll,
      int requestId,
      VoidCallback? Function(int t, dynamic data) callback) async {
    const url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}${GlobalLabel.versionRest}/request/street/finalize";
    final data = {'cost': cost, 'tip': tips, 'requestId': requestId};
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT FINALIZE STREET REQUEST >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['statusCode'], response.data['message']);
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseFinalizeRequestCallCenter(
      double cost,
      double tips,
      double costDistance,
      double costToll,
      int requestId,
      VoidCallback? Function(int t, dynamic data) callback) async {
    const url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}${GlobalLabel.versionRest}/request/call/finalize";
    final data = {'cost': cost, 'tip': tips, 'requestId': requestId};
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT FINALIZE REQUEST CALL CENTER >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['statusCode'], response.data['message']);
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseNotification(int idUser, int since, int number,
      VoidCallback? Function(int code, dynamic data) callback) async {
    const url = "${GlobalLabel.ipConnectionOld}boletines_usuarios/driver";
    final data = {
      'idUsuario': idUser,
      'desde': since,
      'cuantos': number,
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT NOTIFICATION >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['en'],
          ResponseNotificationBusiness.fromMap(response.data));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseSendWaitTime(
      int requestId,
      int vehicleId,
      int deviceId,
      String waitTime,
      VoidCallback? Function(int code, dynamic data) callback) async {
    const url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}${GlobalLabel.versionRest}/request/waitTime";
    final data = {
      'requestId': requestId,
      'vehicleId': vehicleId,
      'deviceId': deviceId,
      'waitTime': waitTime,
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT SEND WAIT TIME >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseInProgressById(int idRequest, int idUser, int idVehicle,
      VoidCallback? Function(int code, dynamic data) callback) async {
    final url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}${GlobalLabel.versionRest}/request/inprogressbyId/$idRequest/$idVehicle/$idUser";
    try {
      final response = await dio.get(url);
      if (kDebugMode) {
        GlobalFunction().printWrapped('RESULT PROGRESS BY ID >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(
          response.data['statusCode'], ResponseRequest.fromMap(response.data));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseTotalRating(int userId,
      VoidCallback? Function(int code, dynamic data) callback) async {
    final url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}${GlobalLabel.versionRest}/user/ratings/$userId";
    try {
      final response = await dio.get(url);
      if (kDebugMode) {
        print('RESULT TOTAL RATINGS >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['statusCode'],
          ResponseTotalQualification.fromMap(response.data));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseLogOutRemote(int userId, int vehicleId,
      VoidCallback? Function(int code, dynamic data) callback) async {
    const url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}${GlobalLabel.versionRest}/user/disconnect";
    final data = {
      'userId': userId,
      'vehicleId': vehicleId,
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT LOG OUT REMOTE >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['statusCode'], response.data['message']);
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responsePaymentHybrid(int requestId,
      VoidCallback? Function(int code, dynamic data) callback) async {
    final url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}${GlobalLabel.versionRest}/pay/consult/balance/$requestId";
    try {
      final response = await dio.get(url);
      if (kDebugMode) {
        print('RESULT PAYMENT HYBRID >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['statusCode'],
          ResponsePaymentHybrid.fromMap(response.data));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
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
      VoidCallback? Function(int code, dynamic data) callback) async {
    const url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}${GlobalLabel.versionRest}/pay/request";
    final data = {
      'requestId': requestId,
      'userId': userId,
      'toll': toll,
      'careerCost': careerCost,
      'finalCostWithDiscout': finalCostWithDiscount,
      'finalCostWithoutDiscount': finalCostWithoutDiscount,
      'tip': tip,
      'cash': statusErrorCard,
      'latD': latitude,
      'longD': longitude,
      'paymentMethods': paymentMethods,
      'discount': discount,
    };

    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT SEND PAYMENT HYBRID >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['statusCode'], response.data['message']);
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseGetDayStatistics(int vehicleId, int deviceId,
      VoidCallback? Function(int code, dynamic data) callback) async {
    final url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}${GlobalLabel.versionRest}/user/dailyStatistics/$vehicleId/$deviceId";
    try {
      final response = await dio.get(url);
      if (kDebugMode) {
        print('RESULT GET DAY STATISTICS >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['statusCode'],
          ResponseDayStatistics.fromMap(response.data));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseSaveDayStatistics(
      int vehicleId,
      int deviceId,
      double distance,
      String time,
      VoidCallback? Function(int code, dynamic data) callback) async {
    const url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}${GlobalLabel.versionRest}/user/dailyStatistics";
    final data = {
      'vehicleId': vehicleId,
      'deviceId': deviceId,
      'distance': distance,
      'time': time,
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT SAVE DAY STATISTICS >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  /// Cancelled request before postulation
  @override
  Future responseCancelRequestStreet(
      ModelRequest modelRequest,
      int state,
      int idEventuality,
      int idUser,
      VoidCallback? Function(int t, dynamic data) callback) async {
    const url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}${GlobalLabel.versionRest}/cancel/street";
    final data = {
      'requestId': modelRequest.requestData!.requestId,
      'state': state,
      'eventualityId': idEventuality,
      'userId': idUser
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT CANCEL REQUEST STREET>>> $response');
      }
      if (response.data == null &&
          !response.data.toString().contains("statusCode")) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      if (response.toString().contains('statusCode')) {
        callback(response.data["statusCode"], response.data["message"]);
      }
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
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
      VoidCallback? Function(int t, dynamic data) callback) async {
    const url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}${GlobalLabel.versionRest}/taximeter/finish";
    final data = {
      'requestId': requestId,
      'userId': userId,
      'vehicleId': vehicleId,
      "type": type,
      'latitude': latitudeOrigin,
      'longitude': longitudeOrigin,
      'costTaximeter': costTaximeter,
      'costPayment': costPayment,
      'latitudeFinish': latitudeFinish,
      'longitudeFinish': longitudeFinish,
      'endTime': hourEnd,
      'startRate': startRate,
      'totalTime': totalTime,
      'standbyTime': waitTime,
      'valueTime': costTime,
      'distanceTraveled': distanceTravel,
      'valueDistance': costDistance,
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT SAVE TAXIMETER >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(
          response.data['statusCode'], ResponseGainDay.fromMap(response.data));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseMessageChat(int idCity, int idApplicative, int type,
      VoidCallback? Function(int code, dynamic data) callback) async {
    final url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}${GlobalLabel.versionRest}/chat/$idCity/$idApplicative/$type";
    try {
      final response = await dio.get(url);
      if (kDebugMode) {
        print('RESULT MESSAGE CHAT >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['statusCode'],
          ResponseMessageChat.fromMap(response.data));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseQualificationUser(
      int requestId,
      double latitude,
      double longitude,
      int qualify,
      String observation,
      VoidCallback? Function(int code, dynamic data) callback) async {
    const url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}${GlobalLabel.versionRest}/request/qualify/user";
    final data = {
      'requestId': requestId,
      'latitude': latitude,
      'longitude': longitude,
      'qualify': qualify,
      'observation': observation,
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT QUALIFICATION USER >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['statusCode'], response.data['message']);
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseAcceptTravelCallCenter(ModelRequest modelRequest,
      VoidCallback? Function(int code, dynamic data) callback) async {
    const url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}${GlobalLabel.versionRest}/request/saveRequestsCall";
    try {
      final response = await dio.post(url, data: modelRequest.toMap());
      if (kDebugMode) {
        print('RESULT ACCEPT TRAVEL CALL CENTER >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['statusCode'], response.data['m']);
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseSaveErrorApp(
      String message,
      String error,
      String version,
      int userId,
      VoidCallback? Function(int code, dynamic data) callback) async {
    const url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}${GlobalLabel.versionRest}/error/application/down";
    final dataError = {
      'error': error,
      'applicativeId': GlobalLabel.idApplication,
      'version': version,
      'userId': userId
    };
    final data = {
      'message': message,
      'error': dataError,
    };
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT SAVE ERROR APP >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseHeatMap(int idCity,
      VoidCallback? Function(int code, dynamic data) callback) async {
    final url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}${GlobalLabel.versionRest}/maps/map/heatMap/$idCity";
    try {
      final response = await dio.get(url);
      if (kDebugMode) {
        print('RESULT HEAT MAP >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(
          response.data['statusCode'], ResponseHeatMap.fromMap(response.data));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseServiceActive(int idCity, int vehicleId,
      VoidCallback? Function(int t, dynamic data) callback) async {
    final url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}${GlobalLabel.versionRest}/user/activeService/$vehicleId/$idCity/";
    try {
      final response = await dio.get(url);
      if (kDebugMode) {
        print('RESULT SERVICE ACTIVE >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['statusCode'],
          ResponseServiceActive.fromMap(response.data));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responsePackageRecharge(
      int idUser,
      int idVehicle,
      int idCity,
      int idPackageType,
      VoidCallback? Function(int code, dynamic data) callback) async {
    final url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}${GlobalLabel.versionRest}/package/$idUser/$idVehicle/$idPackageType/$idCity";
    try {
      final response = await dio.get(url);
      if (kDebugMode) {
        print('RESULT PACKAGE RECHARGE REQUEST >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['statusCode'],
          ResponsePackageRecharge.fromMap(response.data));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseMessageReferred(int idCity,
      VoidCallback? Function(int code, dynamic data) callback) async {
    final url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}${GlobalLabel.versionRest}/user/referrals/$idCity";
    try {
      final response = await dio.get(url);
      if (kDebugMode) {
        print('RESULT MESSAGE REFERRED >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['statusCode'],
          ResponseMessageReferred.fromMap(response.data));
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseSaveFileRequest(
      String file,
      int requestId,
      int userId,
      int clientId,
      int type,
      VoidCallback? Function(int code, dynamic data) callback) async {
    const url =
        "${GlobalLabel.ipConnection}${GlobalLabel.server}${GlobalLabel.versionRest}/chat/sendChatFile";
    FormData data = FormData.fromMap({
      "file": await MultipartFile.fromFile(file),
      "requestId": requestId,
      "userId": userId,
      "clientId": clientId,
      "type": type
    });
    try {
      final response = await dio.post(url, data: data);
      if (kDebugMode) {
        print('RESULT SAVE FILE REQUEST >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data["statusCode"], response.data["data"]['url']);
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }

  @override
  Future responseVerifyIdentity(
      String image,
      int identification,
      String name,
      String lastName,
      String businessId,
      String vehicleId,
      String registerId,
      VoidCallback? Function(int code, dynamic data) callback) async {
    const url = "http://209.97.181.190:9092/recaudo/face/comparar-face";
    final data = {
      "imgBase64": image,
      "identificacion": identification.toString(),
      "nombres": name.toString(),
      "apellidos": lastName.toString(),
      "idEmpresa": businessId.toString(),
      "idVehiculo": vehicleId.toString(),
      "idAdministradorRegistro": registerId.toString(),
    };
    try {
      final response = await dio.post(url,
          data: data, options: Options(headers: {'version': '1.0.0'}));
      if (kDebugMode) {
        print('RESULT VERIFY IDENTITY >>> $response');
      }
      if (response.data == null) {
        // return GlobalFunction().messageAlert(GlobalLabel.textMessageError);
      }
      callback(response.data['en'], response.data['m']);
    } on DioError catch (e) {
      GlobalFunction().messageErrorDio(e, url);
    }
  }
}
