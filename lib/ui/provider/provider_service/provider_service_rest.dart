import 'dart:async';

import 'package:clipp_conductor/ui/provider/provider_verify_identity.dart';
import 'package:clipp_conductor/ui/util/widget_check_verify_identity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../data/response/response_day_statistics.dart';
import '../../../data/response/response_gain_day.dart';
import '../../../data/response/response_heat_map.dart';
import '../../../data/response/response_message_referred.dart';
import '../../../data/response/response_operator_vehicle.dart';
import '../../../data/response/response_payment_hybrid.dart';
import '../../../data/response/response_suggestion_destination.dart';
import '../../../data/response/response_user.dart';
import '../../../data/response/response_user_operator.dart';
import '../../../domain/entities/model_coordinate_direction.dart';
import '../../../domain/entities/model_login.dart';
import '../../../domain/entities/model_recover_distance_taximeter.dart';
import '../../../domain/entities/model_request.dart';
import '../../../domain/entities/model_user.dart';
import '../../../domain/repositories/api_interface.dart';
import '../../page/page_block_user.dart';
import '../../page/page_detail_destination.dart';
import '../../page/page_gain.dart';
import '../../page/page_history_request.dart';
import '../../page/page_log_out_remote.dart';
import '../../page/page_login.dart';
import '../../page/page_no_result.dart';
import '../../page/page_payment.dart';
import '../../page/page_progress_postulation.dart';
import '../../page/page_qualification.dart';
import '../../page/page_register_dispositive.dart';
import '../../page/page_statistics_gain.dart';
import '../../page/page_vehicle_operator.dart';
import '../../page/page_welcome.dart';
import '../../util/global_function.dart';
import '../../util/global_label.dart';
import '../../util/global_preference.dart';
import '../../util/global_widgets/widget_check.dart';
import '../provider_balance.dart';
import '../provider_buy_package.dart';
import '../provider_canceled_user.dart';
import '../provider_chat_request.dart';
import '../provider_configuration_app.dart';
import '../provider_contact.dart';
import '../provider_gain.dart';
import '../provider_history_request.dart';
import '../provider_login.dart';
import '../provider_map.dart';
import '../provider_notification.dart';
import '../provider_payment.dart';
import '../provider_pre_register.dart';
import '../provider_principal.dart';
import '../provider_referred.dart';
import '../provider_register_dispositive.dart';
import '../provider_report_anomaly.dart';
import '../provider_request_day.dart';
import '../provider_retrieve_password.dart';
import '../provider_search_destination.dart';
import '../provider_service_active.dart';
import '../provider_splash.dart';
import '../provider_taximeter.dart';
import '../provider_total_qualification.dart';
import '../provider_transaction.dart';
import '../provider_update_password.dart';
import '../provider_vehicle_operator.dart';
import 'provider_service_socket.dart';

class ProviderServiceRest with ChangeNotifier {
  ApiInterface apiInterface;

  ProviderServiceRest(this.apiInterface);

  /// Get route active request
  /// Type 1: Route origin
  /// Type 2: Route destiny
  void getRouteActiveRequest(
      BuildContext context, LatLng positionFinal, int type) {
    final prMapRead = context.read<ProviderMap>();
    final prPrincipalRead = context.read<ProviderPrincipal>();
    if (type == 1) {
      GlobalPreference.getRouterRequestOrigin().then((point) {
        if (point == null) {
          apiInterface.responseConsultTracing(
              LatLng(prMapRead.positionLatitude, prMapRead.positionLongitude),
              positionFinal,
              prPrincipalRead.modelUser.idCity!, (code, response) {
            if (response == null) return;
            prMapRead.getPolylineRoute(
                context, response, prPrincipalRead.modelRequestActive!, type);
            GlobalPreference().setRouterRequestOrigin(response);
            return null;
          });
        } else {
          prMapRead.getPolylineRoute(
              context, point, prPrincipalRead.modelRequestActive!, type);
        }
      });
    } else {
      GlobalPreference.getRouterRequestDestiny().then((point) {
        if (point == null) {
          apiInterface.responseConsultTracing(
              LatLng(prMapRead.positionLatitude, prMapRead.positionLongitude),
              positionFinal,
              prPrincipalRead.modelUser.idCity!, (code, response) {
            if (response == null) return;
            prMapRead.getPolylineRoute(
                context, response, prPrincipalRead.modelRequestActive!, type);
            GlobalPreference().setRouterRequestDestiny(response);
            return null;
          });
        } else {
          prMapRead.getPolylineRoute(
              context, point, prPrincipalRead.modelRequestActive!, type);
        }
      });
    }
  }

  void consultGainQualificationUser(BuildContext context) async {
    final prPrincipalRead =
        GlobalFunction.context.currentContext!.read<ProviderPrincipal>();
    await Future.delayed(const Duration(milliseconds: 300));
    apiInterface.responseGainDay(prPrincipalRead.modelUser.idUser!, (t, data) {
      ResponseGainDay responseGainDay = data;
      prPrincipalRead.gainDay =
          responseGainDay.g!.mont! + responseGainDay.p!.mont!;
      prPrincipalRead.numberRequest =
          responseGainDay.g!.numRequest! + responseGainDay.p!.numRequest!;
      prPrincipalRead.dateServer = responseGainDay.g!.date!;
      return null;
    });
    apiInterface.responseQualificationDriver(prPrincipalRead.modelUser.idUser!,
        (code, data) {
      prPrincipalRead.qualificationDriver = 6 - double.parse(data.toString());
      notifyListeners();
      return null;
    });
  }

  void consultTotalRating(BuildContext context) {
    final prTotalQualification = context.read<ProviderTotalQualification>();
    final prPrincipalRead =
        GlobalFunction.context.currentContext!.read<ProviderPrincipal>();
    GlobalFunction().showProgress();
    apiInterface.responseTotalRating(prPrincipalRead.modelUser.idUser!,
        (code, data) {
      GlobalFunction().hideProgress();
      if (code != 0) {
        GlobalFunction().nextPageViewTransition(
            const PageNoResult(message: GlobalLabel.textNoResult));
        return;
      }
      prTotalQualification.addTotalQualification(data);
      GlobalFunction().nextPageViewTransition(const PageQualification());
      return;
    });
  }

  void logOutRemote(BuildContext context) {
    final prServiceSocketRead = context.read<ProviderServiceSocket>();
    final prSpashRead = context.read<ProviderSplash>();
    GlobalFunction().showProgress();
    GlobalPreference.getDataUser().then((dataUser) {
      apiInterface.responseLogOutRemote(dataUser!.idUser!, dataUser.idVehicle!,
          (code, data) {
        if (code != 0) {
          GlobalFunction().messageAlert(context, data);
          return;
        }
        prSpashRead.statusPage = true;
        GlobalPreference().setStateLogin(true);
        prServiceSocketRead.startConnectionServer(1);
        GlobalFunction().hideProgress();
        GlobalFunction().nextPageUntilView(const PageLogin());
        return;
      });
    });
  }

  /// Consult notification
  consultNotification(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prNotifications = context.read<ProviderNotification>();
    apiInterface.responseNotification(prPrincipalRead.modelUser.idUser!, 0, 10,
        (code, data) {
      prNotifications.addListNotification(data);
      return null;
    });
  }

  /// Consult notification
  consultDayStatics(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    apiInterface.responseGetDayStatistics(prPrincipalRead.modelUser.idVehicle!,
        prPrincipalRead.modelUser.idEquipment!, (code, data) {
      ResponseDayStatistics responseDayStatistics = data;
      prPrincipalRead.timeConnection =
          '${responseDayStatistics.data!.time!.split(':')[0]}:${responseDayStatistics.data!.time!.split(':')[0]}';
      prPrincipalRead.distanceConnection =
          responseDayStatistics.data!.distance!;
      return;
    });
  }

  void sendRegisterDispositive(BuildContext context) {
    final prMapRead = context.read<ProviderMap>();
    final prRegisterDispositive = context.read<ProviderRegisterDispositive>();
    GlobalPreference.getDataDispositive().then((modelDispositive) {
      apiInterface.responseRegisterDispositive(
          prRegisterDispositive.iU,
          GlobalFunction().generatedSHA256(modelDispositive!.imei),
          modelDispositive.brand!,
          modelDispositive.model!,
          modelDispositive.versionSystem!,
          modelDispositive.version!,
          prMapRead.positionLatitude,
          prMapRead.positionLongitude, (code, data) {
        switch (code) {
          case 0:
            GlobalFunction().messageAlert(context, data);
            GlobalFunction().closeView();
            break;
        }
        return null;
      });
    });
  }

  /// Consult request of day
  void consultRequestDay(BuildContext context) async {
    final prPrincipal = context.read<ProviderPrincipal>();
    final prRequestDayRead = context.read<ProviderRequestDay>();
    GlobalFunction().showProgress();
    prRequestDayRead.selected = GlobalFunction().dateNow;
    prRequestDayRead.formatDay();
    apiInterface.responseRequestDay(
        prPrincipal.modelUser.idUser!,
        prRequestDayRead.selected.day.toString(),
        prRequestDayRead.selected.month.toString(),
        prRequestDayRead.selected.year.toString(), (code, data) {
      GlobalFunction().hideProgress();
      if (code != 1) {
        GlobalFunction().nextPageViewTransition(
            const PageNoResult(message: GlobalLabel.textNoResult));
        return;
      }
      prRequestDayRead.addListRequestDay(data);
      GlobalFunction().nextPageViewTransition(const PageStatisticsGain());
      return null;
    });
  }

  /// Filter for get to the request day
  void filterCalendarRequestDay(DateTime date, BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prRequestDayRead = context.read<ProviderRequestDay>();
    apiInterface.responseRequestDay(
        prPrincipalRead.modelUser.idUser!,
        date.toString().split(' ')[0].split('-')[2],
        date.toString().split(' ')[0].split('-')[1],
        date.toString().split(' ')[0].split('-')[0], (code, data) {
      prRequestDayRead.addListRequestDay(data);
      return null;
    });
  }

  void sendTrackingDriver(data) {
    final prPrincipalRead =
        GlobalFunction.context.currentContext!.read<ProviderPrincipal>();
    final dataDriver = {
      "idVehiculo": prPrincipalRead.modelUser.idVehicle,
      "fecha": GlobalFunction().date.format(GlobalFunction().dateNow),
      "data": data,
    };
    apiInterface.responseTrackingDriver(dataDriver, (code, data) {
      return null;
    });
  }

  /// Get taximeter street
  /// Type 1: Taximeter street
  /// Type 2: Taximeter street with destiny
  consultTaximeterStreet(BuildContext context, int type) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prTaximeterRead = context.read<ProviderTaximeter>();
    final prMapRead = context.read<ProviderMap>();
    GlobalFunction().showProgress();
    apiInterface.responseConsultTaximeterStreetRequest(
        prPrincipalRead.modelUser.idCity!, GlobalLabel.idApplication,
        (code, data) {
      GlobalFunction().hideProgress();
      if (code != 1) {
        GlobalFunction().messageAlert(context, data);
        return;
      }
      prPrincipalRead.stateStreetRequest = true;
      GlobalPreference().setStreetRequest(true);
      prTaximeterRead.taximeter = data.r;
      if (prPrincipalRead.modelRequestActive != null ||
          prPrincipalRead.modelRequestActive!.requestData != null) {
        if (prPrincipalRead.modelRequestActive!.requestType == 3) {
          prPrincipalRead.modelRequestActive!.requestData!.latitudeOnBoard =
              prMapRead.positionLatitude;
          prPrincipalRead.modelRequestActive!.requestData!.longitudeOnBoard =
              prMapRead.positionLongitude;
          prPrincipalRead.modelRequestActive!.statusDriver = 5;
          if (prPrincipalRead
              .modelRequestActive!.requestData!.destination!.isNotEmpty) {
            GlobalFunction().speakMessage(
                "${GlobalLabel.textNextDestiny} ${prPrincipalRead.modelRequestActive!.requestData!.destination![0].desBar}, ${GlobalLabel.textDriveCarefully}");
            prMapRead.tracingRouteMap(context);
          } else {
            prPrincipalRead.showNavigatorRoute = false;
          }
        }
      }
      prTaximeterRead.activeValueInitialTaximeter(context, 1);
      prTaximeterRead.startTaximeter(context, 0.0);
      // if (prPrincipalRead.stateService) {
      //   prPrincipalRead.listeningService(context);
      // }
      prPrincipalRead.getNameButtonRequestActive();
      prPrincipalRead.getDescriptionStateRequest();
      notifyListeners();
    });
  }

  /// Consult taximeter
  consultTaximeterRequest(BuildContext context, ModelRequest modelRequest) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prTaximeterRead = context.read<ProviderTaximeter>();
    final prMapRead = context.read<ProviderMap>();
    GlobalFunction().showProgress();
    apiInterface.responseConsultTaximeter(
        prPrincipalRead.modelUser.idCity!,
        GlobalLabel.idApplication,
        modelRequest.requestData!.activeServiceId!,
        modelRequest.requestData!.paymentType!, (code, data) {
      GlobalFunction().hideProgress();
      if (code != 1) {
        GlobalFunction().messageAlert(context, data);
        return;
      }
      prTaximeterRead.taximeter = data.r!;
      if (modelRequest.statusDriver != 5) {
        prPrincipalRead.modelRequestActive!.requestData!.latitudeOnBoard =
            prMapRead.positionLatitude;
        prPrincipalRead.modelRequestActive!.requestData!.longitudeOnBoard =
            prMapRead.positionLongitude;
        prPrincipalRead.modelRequestActive!.statusDriver = 5;
        prTaximeterRead.startTaximeter(context, 0.0);
        if (prPrincipalRead
            .modelRequestActive!.requestData!.destination!.isNotEmpty) {
          GlobalFunction().speakMessage(
              "${GlobalLabel.textNextDestiny} ${modelRequest.requestData!.destination![0].desBar}, ${GlobalLabel.textDriveCarefully}");
          prMapRead.tracingRouteMap(context);
        } else {
          prPrincipalRead.showNavigatorRoute = false;
        }
        prTaximeterRead.activeValueInitialTaximeter(context, 1);
      } else {
        apiInterface.responseDistanceTaximeter(
            prPrincipalRead.modelUser.idVehicle!,
            modelRequest.requestData!.requestId!, (code, data) {
          if (code != 0) return;
          ModelRecoverDistanceTaximeter modelRecoverDistanceTaximeter = data;
          prPrincipalRead.modelRequestActive!.requestData!.latitudeOnBoard =
              modelRecoverDistanceTaximeter.latitude;
          prPrincipalRead.modelRequestActive!.requestData!.longitudeOnBoard =
              modelRecoverDistanceTaximeter.longitude;
          prTaximeterRead.loadDistance(
              context,
              modelRecoverDistanceTaximeter.distance!,
              modelRecoverDistanceTaximeter.waitTime!,
              modelRecoverDistanceTaximeter.valueRecover!);
          if (prPrincipalRead
              .modelRequestActive!.requestData!.destination!.isNotEmpty) {
            GlobalFunction().speakMessage(
                "${GlobalLabel.textNextDestiny} ${modelRequest.requestData!.destination![0].desBar}, ${GlobalLabel.textDriveCarefully}");
            prMapRead.tracingRouteMap(context);
          } else {
            prPrincipalRead.showNavigatorRoute = false;
          }
          prTaximeterRead.activeValueInitialTaximeter(context, 2);
          return null;
        });
      }
      prPrincipalRead.getNameButtonRequestActive();
      prPrincipalRead.getDescriptionStateRequest();
      notifyListeners();
      return null;
    });
  }

  /// Consult list contact
  consultListContact(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prContactRead = context.read<ProviderContact>();

    apiInterface.responseListContact(
        prPrincipalRead.modelUser.idUser!,
        GlobalLabel.idApplication,
        prPrincipalRead.modelUser.idCity!, (code, data) {
      if (code != 1) return;
      prContactRead.addListContact(data);
      return null;
    });
  }

  /// Send contact
  sendContact(BuildContext context) {
    final prContactRead = context.read<ProviderContact>();
    final prPrincipalRead = context.read<ProviderPrincipal>();

    if (prContactRead.editName.text.trim().isEmpty) {
      GlobalFunction().messageAlert(context, GlobalLabel.textNameContact);
      return;
    }

    if (prContactRead.editContact.text.trim().isEmpty) {
      GlobalFunction().messageAlert(context, GlobalLabel.textNumberContact);
    }

    apiInterface.responseSaveContact(
        prPrincipalRead.modelUser.idUser!,
        GlobalLabel.idApplication,
        prPrincipalRead.modelUser.idCity!,
        prContactRead.editName.text.trim(),
        prContactRead.editContact.text.trim(), (code, data) {
      if (code == 1) {
        consultListContact(context);
        prContactRead.clearAllEdit();
        return;
      }
      GlobalFunction().messageAlert(context, data);
      return null;
    });
  }

  /// Disable contact active of the list
  disableContact(BuildContext context, int idContact) {
    final prContactRead = context.read<ProviderContact>();
    final prPrincipalRead = context.read<ProviderPrincipal>();
    apiInterface.responseDisableContact(
        prPrincipalRead.modelUser.idUser!, idContact, (code, data) {
      if (code != 1) {
        GlobalFunction().messageAlert(context, data);
        return;
      }
      GlobalFunction().messageAlert(context, data);
      prContactRead.updateStateListContact(2, idContact);
      return null;
    });
  }

  /// Active contact active of the list
  enableContact(BuildContext context, int idContact) {
    final prContactRead = context.read<ProviderContact>();
    final prPrincipalRead = context.read<ProviderPrincipal>();
    apiInterface.responseEnableContact(
        prPrincipalRead.modelUser.idUser!, idContact, (code, data) {
      if (code != 1) {
        GlobalFunction().messageAlert(context, data);
      }
      GlobalFunction().messageAlert(context, data);
      prContactRead.updateStateListContact(1, idContact);
      return null;
    });
  }

  /// Send Anomaly
  sendAnomaly(BuildContext context) async {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prReportAnomalyRead = context.read<ProviderReportAnomaly>();
    final prMapRead = context.read<ProviderMap>();

    if (prReportAnomalyRead.editLate.text.trim().isEmpty) {
      GlobalFunction().messageAlert(context, GlobalLabel.textNumberPlate);
      return;
    }
    if (prReportAnomalyRead.editColor.text.trim().isEmpty) {
      GlobalFunction().messageAlert(context, GlobalLabel.textColorVehicle);
      return;
    }
    if (prReportAnomalyRead.editCommentary.text.trim().isEmpty) {
      GlobalFunction().messageAlert(context, GlobalLabel.textComment);
      return;
    }
    apiInterface.responseSaveAnomaly(
        prPrincipalRead.modelUser.idUser!,
        prPrincipalRead.modelUser.idVehicle!,
        prReportAnomalyRead.editLate.text,
        prReportAnomalyRead.editColor.text,
        prReportAnomalyRead.editCommentary.text,
        prMapRead.positionLatitude,
        prMapRead.positionLongitude, (code, data) {
      if (code == 1) {
        apiInterface.responseSaveImageAnomaly(
            prReportAnomalyRead.listImage![0].path, data, (code, data) {
          if (code == 1) {
            prReportAnomalyRead.deleteImage();
            prReportAnomalyRead.cleanTextEditCommentary();
            prReportAnomalyRead.cleanTextEditColor();
            prReportAnomalyRead.cleanTextFieldEditLate();
            GlobalFunction().messageAlert(context, data);
            GlobalFunction().hideQuery();
          } else {
            GlobalFunction().messageAlert(context, data);
          }
          return null;
        });
      }
      return null;
    });
  }

  /// Get direction origin for coordinate
  getDirectionForCoordinate(
    BuildContext context,
  ) {
    final prSearchDestinationRead = context.read<ProviderSearchDestination>();
    final prMapRead = context.read<ProviderMap>();
    apiInterface.responseDirectionForCoordinate(
        prMapRead.positionLatitude, prMapRead.positionLongitude, (data) {
      prSearchDestinationRead.directionForCoordinate = data;
      return null;
    });
  }

  /// Get list suggestion direction
  getListSuggestionDirection(BuildContext context, String direction) {
    final prSearchDestinationRead = context.read<ProviderSearchDestination>();
    final prMapRead = context.read<ProviderMap>();
    GlobalPreference.getDataUser().then((user) {
      if (user == null) return;
      apiInterface.responseSearchDirection(user.idCity!, direction,
          prMapRead.positionLatitude, prMapRead.positionLongitude, 500, (data) {
        prSearchDestinationRead.addListDirectionStreet(context, data);
        return null;
      });
    });
  }

  /// Send update password
  sendUpdatePassword(BuildContext context) {
    final prProviderUpdatePasswordRead = context.read<ProviderUpdatePassword>();
    final prPrincipalRead = context.read<ProviderPrincipal>();

    if (prProviderUpdatePasswordRead.editFormerPassword.text.trim().isEmpty) {
      return GlobalFunction()
          .messageAlert(context, GlobalLabel.textWriteFormerPassword);
    }
    if (prProviderUpdatePasswordRead.editNewPassword.text.trim().isEmpty) {
      return GlobalFunction()
          .messageAlert(context, GlobalLabel.textWriteNewPassword);
    }
    if (prProviderUpdatePasswordRead.editNewPassword.text.trim().length < 4) {
      return GlobalFunction()
          .messageAlert(context, GlobalLabel.textPasswordShort);
    }

    if (prProviderUpdatePasswordRead.editNewPassword.text.trim() ==
        prProviderUpdatePasswordRead.editFormerPassword.text.trim()) {
      return GlobalFunction().messageAlert(context, GlobalLabel.textEquals);
    }
    GlobalFunction().hideQuery();
    GlobalFunction().deleteFocusForm();
    apiInterface.responseUpdatePassword(
        prPrincipalRead.modelUser.idUser!,
        GlobalFunction().generatedMd5(
            prProviderUpdatePasswordRead.editFormerPassword.text.trim()),
        GlobalFunction().generatedMd5(
            prProviderUpdatePasswordRead.editNewPassword.text.trim()),
        GlobalLabel.idApplication, (code, data) {
      if (code != 1) {
        GlobalFunction().messageAlert(context, data);
        return;
      }
      logOut(GlobalFunction.context.currentContext!);
      return null;
    });
  }

  /// Send log out application
  logOut(BuildContext context) {
    final prUpdatePasswordRead = context.read<ProviderUpdatePassword>();
    final prPrincipalRead = context.read<ProviderPrincipal>();
    if (prPrincipalRead.modelRequestActive!.requestData != null) {
      GlobalFunction().speakMessage(GlobalLabel.textRequestNowActive);
      GlobalFunction().messageAlert(context, GlobalLabel.textRequestNowActive);
      Navigator.pop(context);
    } else {
      GlobalPreference.getDataUser().then((user) {
        GlobalFunction().showProgress();
        apiInterface.responseLogOut(user!.idUser!, GlobalLabel.idApplication,
            (code, data) {
          GlobalFunction().hideProgress();
          if (code != 1) {
            GlobalFunction().messageAlert(context, data);
            return;
          }
          prUpdatePasswordRead.logOutSession();
          return null;
        });
      });
    }
  }

  /// Get service available of driver
  getServiceActive(BuildContext context) async {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prServiceActiveRead = context.read<ProviderServiceActive>();
    apiInterface.responseServiceActive(
        prPrincipalRead.modelUser.idCity!, prPrincipalRead.modelUser.idVehicle!,
        (code, data) {
      if (code != 0) return;
      prServiceActiveRead.addListServiceActive(data);
      return null;
    });
  }

  /// Get buy package
  consultBuyPackage(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prBuyPackageRead = context.read<ProviderBuyPackage>();
    String timeStanD =
        GlobalFunction().dateNow.millisecondsSinceEpoch.toString();
    String token = GlobalFunction().generatedSHA256(
        '$timeStanD${GlobalFunction().generatedMd5(prPrincipalRead.modelUser.idUser!.toString())}');
    String key = GlobalFunction().generatedMd5(
        '${GlobalFunction().generatedSHA256(prPrincipalRead.modelUser.idUser!.toString())}$timeStanD');
    String keyPackageRecharge = GlobalFunction().generatedMd5(
        '${prPrincipalRead.modelUser.idUser!.toString()}${GlobalFunction().generatedSHA256(GlobalLabel.idApplication.toString())}$timeStanD');

    apiInterface.responsePackagePending(
        timeStanD,
        token,
        keyPackageRecharge,
        GlobalLabel.idApplication,
        prPrincipalRead.modelUser.idUser!, (code, data) {
      if (code != 1) {
        return;
      }
      prBuyPackageRead.addListPackagePending(data);
      return null;
    });

    apiInterface.responseBuyPackage(
        prPrincipalRead.modelUser.idUser!, token, key, timeStanD, (code, data) {
      if (code != 1) {
        return;
      }

      prBuyPackageRead.addListPackageRequest(data);
      return null;
    });

    apiInterface.responsePackageRecharge(
        prPrincipalRead.modelUser.idUser!,
        prPrincipalRead.modelUser.idVehicle!,
        prPrincipalRead.modelUser.idCity!,
        1, (code, data) {
      if (code != 0) return;
      prBuyPackageRead.addListPackageRechargeRequest(data);
      return null;
    });
  }

  /// Consult balance user
  consultBalance(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prBalanceRead = context.read<ProviderBalance>();
    apiInterface.responseBalanceDriver(
        prPrincipalRead.modelUser.idVehicle!,
        prPrincipalRead.modelUser.idUser!,
        prPrincipalRead.modelUser.idCity!, (code, data) {
      if (code != 1) return;
      prBalanceRead.addListBalance(data);
      return null;
    });
    apiInterface.responseDebts(prPrincipalRead.modelUser.idUser!, (code, data) {
      if (code != 1) return;
      prBalanceRead.addListDebts(data);
      return null;
    });
  }

  /// Pay debts driver
  payDebts(BuildContext context, double mont, int idDebts) {
    final prBalanceRead = context.read<ProviderBalance>();
    final prPrincipalRead = context.read<ProviderPrincipal>();

    if (prBalanceRead.balanceTotal < mont) {
      return GlobalFunction().messageAlert(context,
          '${GlobalLabel.textYourBalance} ${prBalanceRead.balanceTotal.toStringAsFixed(2)} ${prPrincipalRead.nameMoney} ${GlobalLabel.textInsufficientBalance}');
    }
    GlobalFunction().messageConfirmation(GlobalLabel.textSurePayDebts, () {
      apiInterface.responsePayDebts(prPrincipalRead.modelUser.idUser!, idDebts,
          (code, data) {
        if (code != 1) {
          GlobalFunction().messageAlert(context, data);
          return;
        }
        GlobalFunction().messageAlert(context, data);
        prBalanceRead.listDebts!
            .removeWhere((element) => element.idDebts == idDebts);
        consultBalance(context);
        return null;
      });
    });
  }

  /// Get transactions
  consultTransaction(BuildContext context, DateTime date) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prTransactionRead = context.read<ProviderTransaction>();
    apiInterface.responseTransaction(
        date.year,
        date.month,
        prPrincipalRead.modelUser.idVehicle!,
        prPrincipalRead.modelUser.idUser!,
        prPrincipalRead.modelUser.idCity!, (code, data) {
      if (code != 1) return;
      prTransactionRead.addListTransaction(data);
      return null;
    });
  }

  /**
   * New REST API
   */

  /// LogIn applicative
  /// Response -1: User and Password incorrect
  /// Response -2: User locked
  /// Response -3: Dispositive pre register
  /// Response -4: User active other dispositive
  /// Response  0: LogIn correct
  /// Response  1: Dispositive no register
  /// Response  2: User multiple vehicle

  void initLogInApp(BuildContext context, ModelLogIn modelLogIn) {
    final prRegisterDispositiveRead =
        context.read<ProviderRegisterDispositive>();
    final prVehicleOperatorRead = context.read<ProviderVehicleOperator>();
    final prLoginRead = context.read<ProviderLogin>();
    final prServiceSocketRead = context.read<ProviderServiceSocket>();
    GlobalFunction().showProgress();
    apiInterface.responseLogIn(modelLogIn, (code, data) {
      switch (code) {
        case -1:
        case -2:
          GlobalFunction().hideProgress();
          GlobalFunction().messageAlert(context, data['message']);
          break;
        case -3:
          GlobalFunction().hideProgress();
          prRegisterDispositiveRead.typeRegisterDispositive = 2;
          prRegisterDispositiveRead.addListUserOperator(
              ResponseUserOperator.fromMap(data), data['message']);
          GlobalFunction()
              .nextPageViewTransition(const PageRegisterDispositive());
          break;
        case -4:
          prLoginRead.cleanTextField();
          GlobalFunction().hideProgress();
          ResponseUser responseUser = ResponseUser.fromMap(data['data']);
          GlobalPreference().setDataUser(responseUser.user);
          GlobalFunction().nextPageViewTransition(const PageLogOutRemote());
          break;
        case 0:
          prLoginRead.cleanTextField();
          ResponseUser responseUser = ResponseUser.fromMap(data['data']);
          GlobalPreference().setDataUser(responseUser.user);
          prServiceSocketRead.startConnectionServer(1);
          break;
        case 1:
          GlobalFunction().hideProgress();
          prRegisterDispositiveRead.typeRegisterDispositive = 1;
          prRegisterDispositiveRead.iU = data['data']['iU'];
          GlobalFunction()
              .nextPageViewTransition(const PageRegisterDispositive());
          break;
        case 2:
          GlobalFunction().hideProgress();
          ResponseOperatorVehicle responseOperatorVehicle =
              ResponseOperatorVehicle.fromMap(data['data']);
          prVehicleOperatorRead.addListUser(responseOperatorVehicle.lUser!);
          GlobalFunction().nextPageViewTransition(const PageVehicleOperator());
          break;
      }
      return null;
    });
  }

  /// Send events
  void sendEvent(
      BuildContext context, int type, int idRequest, double distance) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prMapRead = context.read<ProviderMap>();
    apiInterface.responseSendEvent(
        prPrincipalRead.modelUser,
        prMapRead.positionLatitude,
        prMapRead.positionLongitude,
        type,
        idRequest,
        distance, (code, data) {
      if (code != 0) return;
      if (prPrincipalRead.stateService) {
        consultInProgressById(context, idRequest);
      }
      return;
    });
  }

  /// Method consult in progress
  /// Type 1: Consult from reset applicative
  /// Type 2: Consult from request call center
  /// Status true: Active global
  void consultInProgress(BuildContext context, int type) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    apiInterface.responseInProgress(
        prPrincipalRead.modelUser.idUser!, prPrincipalRead.modelUser.idVehicle!,
        (code, data) {
      if (code != 0) return;
      prPrincipalRead.activeGlobalEvent(GlobalFunction.context.currentContext!);
      GlobalFunction().stopBubble();
      prPrincipalRead.addNewRequestList(context, data, type);
      return null;
    });
  }

  /// Consult In Progress By Id
  void consultInProgressById(BuildContext context, int idRequest) {
    final prPrincipalRead = context.read<ProviderPrincipal>();

    apiInterface.responseInProgressById(
        idRequest,
        prPrincipalRead.modelUser.idUser!,
        prPrincipalRead.modelUser.idVehicle!, (code, data) {
      if (code != 0) return;
      FlutterForegroundTask.launchApp();
      GlobalFunction().stopBubble();
      FlutterForegroundTask.wakeUpScreen();
      prPrincipalRead.addNewRequest(data);
      return null;
    });
  }

  /// Send postulation
  /// Type -1: Request already attended.
  /// Type -1: Not credits
  void sendPostulation(
      BuildContext context, ModelRequest modelRequest, double coast) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prServiceRestRead = context.read<ProviderServiceRest>();
    prPrincipalRead.sendPreviewPostulation = true;
    GlobalFunction().nextPageViewTransition(const PageProgressPostulation());
    prPrincipalRead.modelRequestPostulation = modelRequest;
    notifyListeners();
    if (prPrincipalRead
        .modelRequestPostulation!.requestData!.destination!.isNotEmpty) {
      prPrincipalRead
          .modelRequestPostulation!.requestData!.destination![0].cost = coast;
    }
    apiInterface.responseSendPostulation(
        prPrincipalRead.modelUser,
        modelRequest.requestData!.times!,
        modelRequest.requestData!.distance!,
        coast,
        modelRequest.requestData!.requestId!, (code, data) {
      switch (code) {
        case -1:
          GlobalFunction().speakMessage(data);
          prPrincipalRead.deleteRequest(modelRequest.requestData!.requestId!);
          break;
        case -2:
          GlobalFunction().speakMessage(data);
          GlobalFunction().closeView();
          prPrincipalRead.sendPostulation = false;
          prPrincipalRead.sendPreviewPostulation = false;
          prServiceRestRead.sendUpdateStateDriver(context);
          break;
        case 0:
          prPrincipalRead.sendPostulation = true;
          prPrincipalRead.sendPreviewPostulation = false;
          prPrincipalRead.activeWaitAcceptance(
              context, 30, modelRequest.requestData!.requestId!);
          break;
      }
      return null;
    });
    notifyListeners();
  }

  /// Canceled request before postulation
  /// Type 7: Cancel driver before accepting client
  /// Eventuality  11 : Cancel driver before accepting client
  void cancelRequestBeforePostulation(BuildContext context,
      ModelRequest modelRequest, int state, int idEventuality) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prServiceRestRead = context.read<ProviderServiceRest>();
    GlobalFunction().showProgress();
    if (modelRequest.requestType! == 3) {
      apiInterface.responseCancelRequestStreet(
          modelRequest, state, idEventuality, prPrincipalRead.modelUser.idUser!,
          (code, data) {
        GlobalFunction().hideProgress();
        if (prPrincipalRead.modelRequestActive!.requestData == null) {
          prPrincipalRead.timeCurrentPostulation = GlobalLabel.timePostulation;
          prPrincipalRead.deleteRequest(modelRequest.requestData!.requestId!);
          prPrincipalRead.stopPostulation();
        } else {
          prPrincipalRead.modelRequestPostulation = ModelRequest();
          prPrincipalRead.sendPostulation = false;
          if (prPrincipalRead.sendPreviewPostulation) {
            GlobalFunction().closeView();
          }
          prPrincipalRead.finalizeRequest(2);
          GlobalFunction().nextPageViewTransition(PageBlockUser(message: data));
          prPrincipalRead.resetChronometer();
        }
        prServiceRestRead.sendUpdateStateDriver(context);
        return null;
      });
    } else {
      apiInterface.responseCancelRequestBeforePostulation(
          modelRequest, state, idEventuality, prPrincipalRead.modelUser.idUser!,
          (code, data) {
        GlobalFunction().hideProgress();
        if (code == -1) {
          prPrincipalRead.timeCurrentPostulation = GlobalLabel.timePostulation;
          prPrincipalRead.modelRequestPostulation = ModelRequest();
          prPrincipalRead.deleteRequest(modelRequest.requestData!.requestId!);
          prPrincipalRead.stopPostulation();
          notifyListeners();
        } else {
          if (prPrincipalRead.modelRequestActive!.requestData == null) {
            prPrincipalRead.timeCurrentPostulation =
                GlobalLabel.timePostulation;
            prPrincipalRead.modelRequestPostulation = ModelRequest();
            prPrincipalRead.deleteRequest(modelRequest.requestData!.requestId!);
            prPrincipalRead.stopPostulation();
            notifyListeners();
          } else {
            prPrincipalRead.modelRequestPostulation = ModelRequest();
            prPrincipalRead.sendPostulation = false;
            if (prPrincipalRead.sendPreviewPostulation) {
              GlobalFunction().closeView();
            }
            prPrincipalRead.finalizeRequest(2);
            prPrincipalRead.resetChronometer();
            GlobalFunction()
                .nextPageViewTransition(PageBlockUser(message: data));
            notifyListeners();
          }
        }

        prServiceRestRead.sendUpdateStateDriver(context);
        return null;
      });
    }
  }

  /// Send state watching of the notification
  void sendWatchNotification(BuildContext context, int idBulletin) async {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    await Future.delayed(const Duration(milliseconds: 300));
    apiInterface.responseWatchNotification(
        prPrincipalRead.modelUser.idUser!, idBulletin);
    prPrincipalRead.countNotification = 0;
    notifyListeners();
  }

  /// Send board request
  /// Type 1: Request normal
  /// Type 4: Request call center
  void sendBoardRequest(
      BuildContext context, int requestId, int state, int board, int type) {
    final prMapRead = context.read<ProviderMap>();
    final prServiceRestRead = context.read<ProviderServiceRest>();
    if (type == 1) {
      apiInterface.responseSendBoard(requestId, state, board,
          prMapRead.positionLatitude, prMapRead.positionLongitude, (code) {
        if (code != 0) return;
        prServiceRestRead.sendUpdateStateDriver(context);
        return null;
      });
    } else {
      apiInterface.responseSendBoardCallCenter(requestId, state, board,
          prMapRead.positionLatitude, prMapRead.positionLongitude, (code) {
        if (code != 0) return;
        prServiceRestRead.sendUpdateStateDriver(context);
        return null;
      });
    }
  }

  /// Send answer notification
  void sendAnswerNotification(BuildContext context, int idQuestion) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prNotificationRead = context.read<ProviderNotification>();

    apiInterface.responseReplyQuestion(
        prPrincipalRead.modelUser.idUser!,
        prNotificationRead.notificationBusiness!.idBulletin!,
        idQuestion,
        prNotificationRead.notificationBusiness!.type == 2
            ? '-1'
            : prNotificationRead.editReply.text.trim(), (code, data) {
      if (code != 1) {
        GlobalFunction().messageAlert(context, data);
        return;
      }
      prNotificationRead.listNotification!.removeWhere((element) =>
          element.idBulletin ==
          prNotificationRead.notificationBusiness!.idBulletin);
      if (prNotificationRead.listNotification!.isEmpty) {
        prNotificationRead.contList = true;
      }
      idQuestion = 0;
      GlobalFunction().closeView();
      return null;
    });
  }

  /// Get list eventuality cancel
  void listEventualityCancel(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    apiInterface.responseEventualityCancel((code, data) {
      if (code != 0) return;
      prPrincipalRead.listEventualityCancel(data);
      return null;
    });
  }

  /// Get list eventuality cancel
  void listMessageChat(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prChatRequestRead = context.read<ProviderChatRequest>();
    apiInterface.responseMessageChat(
        prPrincipalRead.modelUser.idCity!,
        GlobalLabel.idApplication,
        prPrincipalRead.modelRequestActive!.requestType!, (code, data) {
      if (code != 0) return;
      prChatRequestRead.listMessageChat(data);
      return null;
    });
  }

  /// Consult the total of requests
  consultNumberHistoryRequestGain(BuildContext context) async {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prGainRead = context.read<ProviderGain>();
    await Future.delayed(const Duration(milliseconds: 10));
    GlobalFunction().showProgress();
    apiInterface.responseNumberHistoryRequest(prPrincipalRead.modelUser.idUser!,
        prGainRead.selected.year, prGainRead.selected.month, 1, (data) {
      if (data == null) return;
      apiInterface.responseHistoryRequest(
          prPrincipalRead.modelUser.idUser!,
          prGainRead.selected.year,
          prGainRead.selected.month,
          1,
          0,
          data, (code, data) {
        GlobalFunction().hideProgress();
        GlobalFunction().nextPageViewTransition(const PageGain());
        prGainRead.addListHistoryRequest(data);
        return null;
      });

      return null;
    });

    apiInterface.responseNumberHistoryRequest(prPrincipalRead.modelUser.idUser!,
        prGainRead.selected.year, prGainRead.selected.month, 2, (data) {
      apiInterface.responseHistoryOrder(
          prPrincipalRead.modelUser.idUser!,
          prGainRead.selected.year,
          prGainRead.selected.month,
          2,
          0,
          data, (code, data) {
        prGainRead.addListHistoryOrder(data);
        return null;
      });
      return null;
    });
  }

  /// Consult number of request type travel and order
  consultNumberHistoryRequest(BuildContext context) async {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prHistoryRead = context.read<ProviderHistoryRequest>();
    await Future.delayed(const Duration(milliseconds: 5));
    GlobalFunction().showProgress();
    apiInterface.responseNumberHistoryRequest(
        prPrincipalRead.modelUser.idUser!,
        prHistoryRead.selected.year,
        prHistoryRead.selected.month,
        prHistoryRead.positionSelectedRequest, (data) {
      if (data == null) return;
      if (prHistoryRead.positionSelectedRequest == 1) {
        apiInterface.responseHistoryRequest(
            prPrincipalRead.modelUser.idUser!,
            prHistoryRead.selected.year,
            prHistoryRead.selected.month,
            prHistoryRead.positionSelectedRequest,
            0,
            data, (code, data) {
          GlobalFunction().hideProgress();
          GlobalFunction().nextPageViewTransition(const PageHistoryDay());
          prHistoryRead.addListHistoryRequest(data);
          return null;
        });
      } else {
        apiInterface.responseHistoryOrder(
            prPrincipalRead.modelUser.idUser!,
            prHistoryRead.selected.year,
            prHistoryRead.selected.month,
            prHistoryRead.positionSelectedRequest,
            0,
            data, (code, data) {
          GlobalFunction().hideProgress();
          prHistoryRead.addListHistoryOrder(data);
          return null;
        });
      }

      return null;
    });
  }

  /// Send petition
  sendRetrievePassword(BuildContext context) {
    final prRetrievePasswordRead = context.read<ProviderRetrievePassword>();
    if (prRetrievePasswordRead.editPhone.text.trim().isEmpty) {
      GlobalFunction().messageAlert(context, GlobalLabel.textEmptyDni);
      return;
    }
    GlobalFunction().deleteFocusForm();
    // GlobalFunction().showProgress();
    apiInterface.responseRetrievePassword(
        prRetrievePasswordRead.editPhone.text.trim(), GlobalLabel.idApplication,
        (t, data) {
      if (t == 1) {
        // GlobalFunction().hideProgress();
        prRetrievePasswordRead.cleanTextField();
        GlobalFunction().messageAlert(context, data);
        GlobalFunction().closeView();
      } else {
        GlobalFunction().deleteFocusForm();
        // GlobalFunction().hideProgress();
        GlobalFunction().messageAlert(context, data);
      }
      return null;
    });
  }

  /// Validate code referred
  validateCodeReferred(BuildContext context) {
    final prPreRegisterRead = context.read<ProviderPreRegister>();
    if (!prPreRegisterRead.optionRegisterOne &&
        !prPreRegisterRead.optionRegisterTwo) {
      GlobalFunction().messageAlert(context, GlobalLabel.textMotivePreRegister);
      return;
    }
    GlobalFunction().showProgress();
    if (prPreRegisterRead.editReferred.text.trim().isEmpty) {
      sendPreRegister(context, 0);
    } else {
      apiInterface.responseValidateCodeReferred(
          int.parse(prPreRegisterRead.editReferred.text.trim()),
          GlobalLabel.idApplication, (t, data) {
        if (t != 1) {
          GlobalFunction().messageAlert(context, GlobalLabel.textMessageError);
          return;
        }
        sendPreRegister(context, data);
        return;
      });
    }
  }

  /// Consult country
  consultCountry(BuildContext context) {
    final prPreRegisterRead = context.read<ProviderPreRegister>();
    apiInterface.responseConsultCountry(GlobalLabel.idApplication, (t, data) {
      if (t != 1) return;
      prPreRegisterRead.addListCity(data);
      return;
    });
  }

  /// Send pre register user
  sendPreRegister(BuildContext context, int idReferred) {
    final prPreRegisterRead = context.read<ProviderPreRegister>();

    GlobalPreference.getDataDispositive().then((dispositive) {
      apiInterface.responseSendRegister(
          10,
          GlobalLabel.idApplication,
          0,
          0,
          0,
          1,
          0,
          '${prPreRegisterRead.editName.text} ${prPreRegisterRead.editLastName.text}',
          prPreRegisterRead.preRegistration.email!.trim(),
          prPreRegisterRead.editNumber.text,
          'Pre-registro',
          GlobalFunction().reasonRegister(
              prPreRegisterRead.preRegistration.selectedCountry!,
              prPreRegisterRead.preRegistration.selectedCity!,
              prPreRegisterRead.editReferred.text.trim(),
              prPreRegisterRead.hashtag,
              prPreRegisterRead.editCommentary.text.trim()),
          0.00,
          0.00,
          dispositive!.version!,
          dispositive.versionSystem!,
          dispositive.brand!,
          dispositive.model!,
          0,
          1,
          0,
          'SN',
          dispositive.imei!,
          2,
          prPreRegisterRead.codeCountry.isoCode!,
          prPreRegisterRead.codeCountry.dialCode ?? '+593',
          2,
          prPreRegisterRead.preRegistration.selectedCountry!,
          prPreRegisterRead.preRegistration.selectedCity!,
          idReferred, (t, data) {
        if (t == 1) {
          GlobalFunction().deleteFocusForm();
          GlobalFunction().hideProgress();
          prPreRegisterRead.cleanAllTextField();
          GlobalFunction().nextPageViewTransition(const PageWelcome());
        } else {
          GlobalFunction().deleteFocusForm();
          GlobalFunction().hideProgress();
          GlobalFunction().messageAlert(context, data);
        }
        return;
      });
    });
  }

  /// Response 5: Session active other dispositive
  /// Response 7: LogIn correct
  void initLogInOperator(BuildContext context, ModelUser modelUser) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prServiceSocketRead = context.read<ProviderServiceSocket>();
    GlobalPreference.getDataDispositive().then((dataDispositive) {
      GlobalFunction().showProgress();
      apiInterface.responseLogInForVehicle(
          modelUser, dataDispositive!.imei!, dataDispositive.version!,
          (code, data) {
        switch (code) {
          case 0:
            GlobalPreference().setDataUser(modelUser);
            prServiceSocketRead.startConnectionServer(1);
            break;
          case -4:
            GlobalFunction().hideProgress();
            GlobalPreference().setDataUser(modelUser);
            prPrincipalRead.addListConfigurationDriver(
                prPrincipalRead.listConfigurationDriver!);
            GlobalFunction().nextPageViewTransition(const PageLogOutRemote());
            break;
        }
        return null;
      });
    });
  }

  void sendUpdateStateDriver(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    apiInterface.responseUpdateStateDriver(prPrincipalRead.modelUser.idVehicle!,
        prPrincipalRead.verifyStateTracking(), (code, data) {
      return null;
    });
  }

  void getSuggestionDirection(BuildContext context) {
    final prSearchDestinationRead = context.read<ProviderSearchDestination>();
    final prMapRead = context.read<ProviderMap>();
    GlobalPreference.getDataUser().then((user) {
      GlobalFunction().showProgress();
      apiInterface.responseCoordinateDirection(user!.idCity!,
          prSearchDestinationRead.selectedDirectionStreet.placeId!, (data) {
        ModelCoordinateDirection modelCoordinateDirection = data;
        prSearchDestinationRead.latitudeStreet =
            modelCoordinateDirection.latitude!;
        prSearchDestinationRead.longitudeStreet =
            modelCoordinateDirection.longitude!;
        apiInterface.responseSuggestionDirection(
            prMapRead.positionLatitude,
            prMapRead.positionLongitude,
            modelCoordinateDirection.latitude!,
            modelCoordinateDirection.longitude!,
            GlobalLabel.idApplication, (code, data) {
          GlobalFunction().hideProgress();
          if (code != 1) {
            GlobalFunction().messageAlert(context, GlobalLabel.textNoResult);
          } else {
            prSearchDestinationRead.addDirectionRecent(
                prSearchDestinationRead.selectedDirectionStreet);
            ResponseSuggestionDestination responseSuggestionDestination = data;
            GlobalFunction().nextPageViewTransition(PageDetailDestination(
                responseSuggestionDestination: responseSuggestionDestination));
          }
          return null;
        });
        return null;
      });
    });
  }

  void sendRequestStreet(BuildContext context, dynamic data) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    GlobalFunction().showProgress();
    apiInterface.responseRequestStreet(data, (code) {
      GlobalFunction().hideProgress();
      if (code != 1) {
        GlobalFunction().messageAlert(context, data);
      } else {
        prPrincipalRead.listeningService(context);
        GlobalFunction().closeView();
        GlobalFunction().closeView();
      }
      return null;
    });
  }

  void sendAboardRequestStreet(
      BuildContext context, int requestId, int state, int aboard) {
    final prServiceRestRead = context.read<ProviderServiceRest>();
    final prMapRead = context.read<ProviderMap>();
    apiInterface.responseAboardRequestStreet(requestId, state, aboard,
        prMapRead.positionLatitude, prMapRead.positionLongitude, (code) {
      if (code != 0) return;
      prServiceRestRead.sendUpdateStateDriver(context);
      return null;
    });
  }

  void sendDeclineRequest(BuildContext context, int requestId) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    apiInterface.responseDeclineRequest(
        requestId, prPrincipalRead.modelUser.idUser!, (code) {
      return null;
    });
  }

  void sendFinalizeStreetRequest(BuildContext context, double cost, double tips,
      double costDistance, double costToll, int requestId) {
    final prTaximeterRead = context.read<ProviderTaximeter>();
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prPaymentRead = context.read<ProviderPayment>();

    if (double.parse(prTaximeterRead.priceTotal.trim()) == 0.00) {
      return GlobalFunction()
          .messageAlert(context, GlobalLabel.textMessageErrorPayment);
    }
    if ((prPaymentRead.initialReviewSlider == 0 ||
            prPaymentRead.initialReviewSlider == 1) &&
        prPaymentRead.editComment.text.toString().trim().isEmpty) {
      return GlobalFunction()
          .messageAlert(context, GlobalLabel.textMotiveComment);
    }

    apiInterface.responseFinalizeStreetRequest(
        cost, tips, costDistance, costToll, requestId, (code, data) {
      if (code != 0) return;
      GlobalFunction().nextPageViewTransition(WidgetCheck(message: data));
      prPrincipalRead.finalizeRequest(1);
      return null;
    });
  }

  void sendFinalizeRequestCallCenter(BuildContext context, double cost,
      double tips, double costDistance, double costToll, int requestId) {
    final prTaximeterRead = context.read<ProviderTaximeter>();
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prPaymentRead = context.read<ProviderPayment>();

    if (double.parse(prTaximeterRead.priceTotal.trim()) == 0.00) {
      return GlobalFunction()
          .messageAlert(context, GlobalLabel.textMessageErrorPayment);
    }
    if ((prPaymentRead.initialReviewSlider == 0 ||
            prPaymentRead.initialReviewSlider == 1) &&
        prPaymentRead.editComment.text.toString().trim().isEmpty) {
      return GlobalFunction()
          .messageAlert(context, GlobalLabel.textMotiveComment);
    }

    apiInterface.responseFinalizeRequestCallCenter(
        cost, tips, costDistance, costToll, requestId, (code, data) {
      if (code != 0) return;
      GlobalFunction().nextPageViewTransition(WidgetCheck(message: data));
      prPrincipalRead.finalizeRequest(1);
      return null;
    });
  }

  void sendPaymentHybrid(BuildContext context) {
    final prPaymentRead = context.read<ProviderPayment>();
    final prTaximeterRead = context.read<ProviderTaximeter>();
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prMapRead = context.read<ProviderMap>();

    List<Map<String, dynamic>> paymentMethodsArray = [];
    List<Map<String, dynamic>> paymentDiscountArray = [];

    Map<String, dynamic> paymentWallet = {};
    Map<String, dynamic> paymentCash = {};
    Map<String, dynamic> paymentCard = {};
    Map<String, dynamic> paymentDiscount = {};

    if (prPaymentRead.modelPaymentHybrid!.wallet != null) {
      try {
        paymentWallet["name"] = prPaymentRead.modelPaymentHybrid!.wallet!.name;
        paymentWallet["price"] = prPaymentRead.costWallet;
        paymentWallet["typeWallet"] =
            prPaymentRead.modelPaymentHybrid!.wallet!.typeWallet;
        if (prPaymentRead.modelPaymentHybrid!.wallet!.typeWallet == 10) {
          paymentWallet["pin"] = prPaymentRead.editPin.text.toString().trim();
        }
        paymentMethodsArray.add(Map.from(paymentWallet));
      } catch (e) {
        if (kDebugMode) {
          print('ERROR WALLET >>> $e');
        }
      }
    }

    if (prPaymentRead.modelPaymentHybrid!.card != null) {
      try {
        paymentCard["name"] = prPaymentRead.modelPaymentHybrid!.card!.name;
        paymentCard["price"] =
            prPaymentRead.statusErrorCard ? '0.00' : prPaymentRead.costCard;
        paymentCard["typePaymentMethod"] =
            prPaymentRead.modelPaymentHybrid!.typePaymentMethod;
        paymentMethodsArray.add(Map.from(paymentCard));
      } catch (e) {
        if (kDebugMode) {
          print('ERROR CARD >> $e');
        }
      }
    }

    try {
      paymentCash["name"] = prPaymentRead.modelPaymentHybrid!.cash != null
          ? prPaymentRead.modelPaymentHybrid!.cash!.name
          : "Cash";
      paymentCash["price"] = prPaymentRead.costCash;
      paymentCash["typePaymentMethod"] =
          prPaymentRead.modelPaymentHybrid!.cash != null
              ? prPaymentRead.modelPaymentHybrid!.typePaymentMethod
              : 1000;
      paymentMethodsArray.add(Map.from(paymentCash));
    } catch (e) {
      if (kDebugMode) {
        print('ERROR CASH >>> $e');
      }
    }

    if (prPaymentRead.modelPaymentHybrid!.discount!.isNotEmpty) {
      String percentage = "0.00";
      if (prPaymentRead.modelPaymentHybrid!.discount![0].typeDiscount == 30) {
        percentage = (((double.parse(!prTaximeterRead.connectedTaximeterExternal
                            ? prTaximeterRead.priceTotal
                            : prTaximeterRead.priceTotalStreet) -
                        prPrincipalRead
                            .modelRequestActive!.requestData!.toll!) *
                    prPaymentRead
                        .modelPaymentHybrid!.discount![0].discountPercentage!) /
                100)
            .toStringAsFixed(2);
      } else {
        percentage = prPaymentRead.costDiscount;
      }

      Map<String, dynamic> discount = {
        "discountFixed":
            prPaymentRead.modelPaymentHybrid!.discount![0].discountFixed,
        "amount": prPaymentRead.modelPaymentHybrid!.discount![0].amount,
        "discountPercentage":
            prPaymentRead.modelPaymentHybrid!.discount![0].discountPercentage,
        "typeDiscount":
            prPaymentRead.modelPaymentHybrid!.discount![0].typeDiscount,
        "typeDiscountAffectsTo": prPaymentRead
            .modelPaymentHybrid!.discount![0].typeDiscountAffectsTo,
      };

      try {
        paymentDiscount["price"] = percentage;
        paymentDiscount["discount"] = Map.from(discount);
        paymentDiscountArray.add(Map.from(paymentDiscount));
      } catch (e) {
        if (kDebugMode) {
          print('ERROR DISCOUNT >>> $e');
        }
      }

      if (prPaymentRead
              .modelPaymentHybrid!.discount![0].typeDiscountAffectsTo ==
          1) {
        if (prPaymentRead.modelPaymentHybrid!.tip != null) {
          if (prPaymentRead.modelPaymentHybrid!.discount![0].typeDiscount ==
              30) {
            prPaymentRead.totalDiscount = ((double.parse(
                            !prTaximeterRead.connectedTaximeterExternal
                                ? prTaximeterRead.priceTotal
                                : prTaximeterRead.priceTotalStreet) +
                        double.parse(
                            prPaymentRead.modelPaymentHybrid!.tip!.tip!)) -
                    ((double.parse(!prTaximeterRead.connectedTaximeterExternal
                                ? prTaximeterRead.priceTotal
                                : prTaximeterRead.priceTotalStreet) *
                            prPaymentRead.modelPaymentHybrid!.discount![0]
                                .discountPercentage!) /
                        100))
                .toStringAsFixed(2);
          } else {
            prPaymentRead.totalDiscount = ((double.parse(
                            !prTaximeterRead.connectedTaximeterExternal
                                ? prTaximeterRead.priceTotal
                                : prTaximeterRead.priceTotalStreet) +
                        double.parse(
                            prPaymentRead.modelPaymentHybrid!.tip!.tip!)) -
                    double.parse(prPaymentRead
                        .modelPaymentHybrid!.discount![0].discountFixed!))
                .toStringAsFixed(2);
          }
        }
      }
    } else {
      if (prPaymentRead.modelPaymentHybrid!.tip != null) {
        prPaymentRead.totalDiscount = (double.parse(
                    !prTaximeterRead.connectedTaximeterExternal
                        ? prTaximeterRead.priceTotal
                        : prTaximeterRead.priceTotalStreet) +
                double.parse(prPaymentRead.modelPaymentHybrid!.tip!.tip!))
            .toStringAsFixed(2);
      } else {
        prPaymentRead.totalDiscount = double.parse(
                !prTaximeterRead.connectedTaximeterExternal
                    ? prTaximeterRead.priceTotal
                    : prTaximeterRead.priceTotalStreet)
            .toStringAsFixed(2);
      }
    }

    if (prPaymentRead.modelPaymentHybrid!.wallet != null &&
        prPaymentRead.modelPaymentHybrid!.wallet!.typeWallet == 10) {
      if (prPaymentRead.editPin.text.trim().isEmpty) {
        GlobalFunction().speakMessage(GlobalLabel.textWritePINVoucher);
        GlobalFunction().messageAlert(context, GlobalLabel.textWritePINVoucher);
        return;
      }

      if (prPaymentRead.editPin.text.trim().length < 4) {
        GlobalFunction().speakMessage(GlobalLabel.textWriteCheckPINVoucher);
        GlobalFunction()
            .messageAlert(context, GlobalLabel.textWriteCheckPINVoucher);
        return;
      }
    }

    if (GlobalFunction().checkHourDay()) {
      if (double.parse(!prTaximeterRead.connectedTaximeterExternal
              ? prTaximeterRead.priceTotal.toString()
              : prTaximeterRead.priceTotalStreet.toString()) <
          prTaximeterRead.taximeter.cD!) {
        return GlobalFunction().messageAlert(context,
            '${GlobalLabel.textMessageErrorMinorPayment} ${prTaximeterRead.taximeter.cD!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}');
      }
    } else {
      if (double.parse(!prTaximeterRead.connectedTaximeterExternal
              ? prTaximeterRead.priceTotal.toString()
              : prTaximeterRead.priceTotalStreet.toString()) <
          prTaximeterRead.taximeter.cN!) {
        return GlobalFunction().messageAlert(context,
            '${GlobalLabel.textMessageErrorMinorPayment} ${prTaximeterRead.taximeter.cN!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}');
      }
    }

    GlobalFunction().showProgress();
    apiInterface.responseSendPaymentHybrid(
        prPrincipalRead.modelRequestActive!.requestData!.requestId!,
        prPrincipalRead.modelUser.idUser!,
        prPrincipalRead.modelRequestActive!.requestData!.toll!
            .toStringAsFixed(2),
        double.parse(prTaximeterRead.priceTotal).toStringAsFixed(2),
        prPaymentRead.totalDiscount,
        (double.parse(!prTaximeterRead.connectedTaximeterExternal
                    ? prTaximeterRead.priceTotal
                    : prTaximeterRead.priceTotalStreet) +
                double.parse(prPaymentRead.modelPaymentHybrid!.tip != null
                    ? prPaymentRead.modelPaymentHybrid!.tip!.tip!.toString()
                    : "0.00"))
            .toStringAsFixed(2),
        prPaymentRead.modelPaymentHybrid!.tip != null
            ? prPaymentRead.modelPaymentHybrid!.tip!.tip!
            : '0.00',
        prMapRead.positionLatitude,
        prMapRead.positionLongitude,
        prPaymentRead.statusErrorCard,
        paymentMethodsArray,
        paymentDiscountArray, (code, data) {
      GlobalFunction().hideProgress();
      switch (code) {
        case -2:
          GlobalFunction().speakMessage(data);
          prPrincipalRead.stateShowButtonPayment = true;
          prPrincipalRead.stateShowButtonPaymentHybrid = true;
          notifyListeners();
          break;
        case -4:
          GlobalFunction().speakMessage(data);
          GlobalFunction().messageAlert(context, data);
          break;
        case 0:
          GlobalFunction().nextPageViewTransition(WidgetCheck(message: data));
          prPrincipalRead.finalizeRequest(1);
          break;
      }

      return;
    });
  }

  void sendWaitTime(String waitTime) {
    final prPrincipalRead =
        GlobalFunction.context.currentContext!.read<ProviderPrincipal>();
    apiInterface.responseSendWaitTime(
        prPrincipalRead.modelRequestActive!.requestData!.requestId!,
        prPrincipalRead.modelUser.idVehicle!,
        prPrincipalRead.modelUser.idEquipment!,
        waitTime, (code, data) {
      return null;
    });
  }

  void consultPaymentHybrid(BuildContext context) {
    final prPrincipalRead =
        GlobalFunction.context.currentContext!.read<ProviderPrincipal>();
    final prPaymentRead = context.read<ProviderPayment>();
    apiInterface.responsePaymentHybrid(
        prPrincipalRead.modelRequestActive!.requestData!.requestId!,
        (code, data) {
      GlobalFunction().hideProgress();
      if (code != 0) return;
      ResponsePaymentHybrid responsePaymentHybrid = data;
      prPaymentRead.modelPaymentHybrid = responsePaymentHybrid.data!;
      prPrincipalRead.stateShowButtonPaymentHybrid = true;
      prPrincipalRead.stateShowButtonPayment = false;
      if (!prPaymentRead.showPagePayment) {
        GlobalFunction().nextPageViewTransition(const PagePayment());
      }
      return;
    });
  }

  void sendSaveDayStatistics(double distance, String time) {
    GlobalPreference.getDataUser().then((user) {
      if (user == null) return;
      apiInterface.responseSaveDayStatistics(
          user.idVehicle!, user.idEquipment!, distance, time, (code, data) {
        return;
      });
    });
  }

  /// Save data taximeter
  /// Type 1: Taximeter normal with request
  /// Type 2: Taximeter external with request
  /// Type 3: Taximeter external without request
  void saveTaximeter(BuildContext context, int type) {
    final prTaximeterRead = context.read<ProviderTaximeter>();
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prMapRead = context.read<ProviderMap>();
    final prPaymentRead = context.read<ProviderPayment>();

    apiInterface.responseSaveTaximeter(
        type == 1 || type == 2
            ? prPrincipalRead.modelRequestActive!.requestData!.requestId!
            : 0,
        prPrincipalRead.modelUser.idUser!,
        prPrincipalRead.modelUser.idVehicle!,
        type,
        type == 1 || type == 2
            ? prPrincipalRead.modelRequestActive!.requestData!.latitudeOnBoard!
            : 0.00,
        type == 1 || type == 2
            ? prPrincipalRead.modelRequestActive!.requestData!.longitudeOnBoard!
            : 0.00,
        type == 1 || type == 2
            ? double.parse(prTaximeterRead.priceTotal)
            : double.parse(prTaximeterRead.priceTotalStreet),
        type == 1 || type == 2
            ? prPrincipalRead.modelRequestActive!.requestData!.paymentType == 9
                ? double.parse(prPaymentRead.subTotal)
                : double.parse(prTaximeterRead.priceTotal)
            : double.parse(prTaximeterRead.priceTotalStreet),
        prMapRead.positionLatitude,
        prMapRead.positionLongitude,
        GlobalFunction().hour.format(GlobalFunction().dateNow),
        type == 1
            ? GlobalFunction().checkHourDay()
                ? prTaximeterRead.taximeter.cD != null
                    ? prTaximeterRead.taximeter.cD!
                    : 0.0
                : prTaximeterRead.taximeter.cN != null
                    ? prTaximeterRead.taximeter.cN!
                    : 0.0
            : 0.00,
        type == 1
            ? '${GlobalFunction().differentHour(prPrincipalRead.modelRequestActive!.requestData!.hour!, GlobalFunction().hour.format(GlobalFunction().dateNow))}'
            : prTaximeterRead.timeTotalTravelExternal,
        type == 1
            ? prTaximeterRead.timeTotalWait
            : prTaximeterRead.timeTotalWaitExternal,
        type == 1
            ? double.parse(prTaximeterRead.costTimeWait.toStringAsFixed(2))
            : 0.00,
        type == 1
            ? int.parse(prTaximeterRead.distanceTraveled.toStringAsFixed(0))
            : prTaximeterRead.distanceTraveledExternal,
        type == 1
            ? prTaximeterRead.costDistance
            : type == 2
                ? prTaximeterRead.costDistanceExternal
                : 0.00, (code, data) {
      return null;
    });
  }

  void qualificationUser(BuildContext context, int requestId) {
    final prMapRead = context.read<ProviderMap>();
    final prCanceledRead = context.read<ProviderCanceledUser>();
    GlobalFunction().showProgress();
    apiInterface.responseQualificationUser(
        requestId,
        prMapRead.positionLatitude,
        prMapRead.positionLongitude,
        1,
        prCanceledRead.editComment.text.toString().trim(), (code, data) {
      if (code != 0) return;
      GlobalFunction().hideProgress();
      GlobalFunction().speakMessage(data);
      GlobalFunction().closeView();
      return null;
    });
  }

  void activeRequestCallCenter(ModelRequest modelRequest) {
    FlutterForegroundTask.launchApp();
    GlobalFunction().speakMessage(GlobalLabel.textNewTravelCallCenter);
    GlobalFunction().messageConfirmation(GlobalLabel.textTravelCallCenter, () {
      GlobalPreference.getDataUser().then((user) {
        modelRequest.username = user!.idUser!;
        modelRequest.vehicleId = user.idVehicle;
        GlobalFunction().showProgress();
        apiInterface.responseAcceptTravelCallCenter(modelRequest, (code, data) {
          if (code != 0) return;
          GlobalFunction().hideProgress();
          consultInProgress(GlobalFunction.context.currentContext!, 2);
          return null;
        });
      });
    });
  }

  void saveErrorApp(String message, String error) {
    GlobalPreference.getDataUser().then((user) {
      GlobalPreference.getDataDispositive().then((dispositive) {
        apiInterface.responseSaveErrorApp(
            message, error, dispositive!.versionSystem!, user!.idUser!,
            (code, data) {
          return null;
        });
      });
    });
  }

  void consultHeatMap(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prMapRead = context.read<ProviderMap>();
    final prConfigurationAppRead = context.read<ProviderConfigurationApp>();
    if (prConfigurationAppRead.modelConfigurationApp.heatMap!) {
      apiInterface.responseHeatMap(prPrincipalRead.modelUser.idCity!,
          (code, data) {
        if (code != 0) return;
        ResponseHeatMap responseHeatMap = data;
        if (responseHeatMap.data!.isEmpty) return;
        prMapRead.addCircleMap(responseHeatMap.data!);
        return null;
      });
    }
  }

  void consultMessageReferred(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prReferredRead = context.read<ProviderReferred>();
    apiInterface.responseMessageReferred(prPrincipalRead.modelUser.idCity!,
        (code, data) {
      if (code != 0) return;
      ResponseMessageReferred responseMessageReferred = data;
      prReferredRead.addMessageReferred(responseMessageReferred);
      return;
    });
  }

  /// Type 1: Audio
  ///
  void sendFileRequest(
      String file, int requestId, int userId, int clientId, int type) {
    final prChatRequestRead =
        GlobalFunction.context.currentContext!.read<ProviderChatRequest>();
    apiInterface.responseSaveFileRequest(
        file, requestId, userId, clientId, type, (code, data) {
      if (code != 0) return;
      prChatRequestRead.addMessageListChat(data, '123', 4);
      return null;
    });
  }

  void sendVerifyIdentity(BuildContext context, String image) {
    final prVerifyIdentity = context.read<ProviderVerifyIdentity>();
    if (image.isEmpty) {
      return GlobalFunction()
          .messageAlert(context, 'No se ha detectado tu cara');
    }
    GlobalFunction().showProgress();
    // Bruno
    // 1104185630
    // Pablo
    // 1104619620
    apiInterface.responseVerifyIdentity(
        image, 1104619620, 'Pablo', 'Malla', '0', '0', '0', (code, data) {
      GlobalFunction().hideProgress();
      if (code == -1) {
        GlobalFunction().messageAlert(context, data);
        return;
      }
      prVerifyIdentity.deleteImage();
      GlobalFunction()
          .nextPageViewTransition(WidgetVerifyIdentity(message: data));
      return null;
    });
  }
}
