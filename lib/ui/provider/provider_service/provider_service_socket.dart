import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../../data/response/response_user.dart';
import '../../../domain/entities/model_data_emit.dart';
import '../../../domain/entities/model_event.dart';
import '../../../domain/entities/model_request.dart';
import '../../../domain/entities/model_user.dart';
import '../../page/page_canceled_user.dart';
import '../../page/page_closing_session.dart';
import '../../page/page_disconnected_server.dart';
import '../../page/page_log_out_remote.dart';
import '../../page/page_log_out_server.dart';
import '../../page/page_payment.dart';
import '../../util/global_function.dart';
import '../../util/global_label.dart';
import '../../util/global_preference.dart';
import '../../util/global_widgets/widget_check.dart';
import '../provider_chat_request.dart';
import '../provider_configuration_app.dart';
import '../provider_map.dart';
import '../provider_payment.dart';
import '../provider_principal.dart';
import '../provider_taximeter.dart';
import '../provider_walkies_talkie.dart';
import 'provider_service_rest.dart';

enum ServerStatus {
  online,
  offline,
  connecting,
}

class ProviderServiceSocket with ChangeNotifier {
  ServerStatus? _serverStatus = ServerStatus.connecting;
  io.Socket? _socket;
  Timer? _timerConnection;

  ServerStatus get serverStatus => _serverStatus!;

  io.Socket get socket => _socket!;

  /// Start connection server
  /// TypeConnected 1: New connection
  /// TypeConnected 2: Recover connection
  /// TypeView 1: Send from splash
  /// TypeView 2: Send from page principal
  void startConnectionServer(int typeConnected) {
    final prMapRead =
        GlobalFunction.context.currentContext!.read<ProviderMap>();
    final prPrincipalRead =
        GlobalFunction.context.currentContext!.read<ProviderPrincipal>();
    GlobalFunction().checkConnectionServer().then((stateServer) {
      if (stateServer) {
        if (_socket != null) return;
        _socket = io.io(GlobalLabel.ipConnectionOld, {
          'transports': ['websocket'],
          'autoConnect': true,
          'forceNew': true,
        });

        _socket!.onConnect((_) {
          if (kDebugMode) {
            print('CONNECTION >>> CONNECTED');
          }
          if (_timerConnection != null) {
            _timerConnection!.cancel();
            _timerConnection = null;
            prPrincipalRead.stateInternet = true;
          }
          _serverStatus = ServerStatus.online;
          notifyListeners();
          authenticate(typeConnected);
        });

        _socket!.onDisconnect((_) async {
          if (kDebugMode) {
            print('CONNECTION >>> DISCONNECTED');
          }

          _serverStatus = ServerStatus.offline;
          if (_socket != null) {
            _socket!.close();
            _socket = null;
          }
          notifyListeners();

          GlobalFunction().checkConnection().then((statusConnected) {
            if (statusConnected) {
              GlobalPreference.getStateLogin().then((stateLogin) {
                if (stateLogin) {
                  if (prPrincipalRead.sendPreviewPostulation ||
                      prPrincipalRead.sendPostulation) {
                    prPrincipalRead.timePostulation.cancel();
                  }
                  prMapRead.resetTimerTracking();
                  prPrincipalRead.stateInternet = false;
                  notifyListeners();
                  _timerConnection =
                      Timer.periodic(const Duration(seconds: 1), (timer) async {
                    GlobalFunction().checkConnectionServer().then((status) {
                      if (!status) return;
                      startConnectionServer(2);
                    });
                  });
                }
              });
            }
          });
        });
      } else {
        prMapRead.resetTimerTracking();
        GlobalFunction().nextPageUntilView(const PageDisconnectedServer());
      }
    });
  }

  /// TypeView 1: Send from splash
  /// TypeView 2: Send from page principal
  void authenticate(int typeConnected) async {
    final prPrincipalRead =
        GlobalFunction.context.currentContext!.read<ProviderPrincipal>();
    final request = {'lista': []};
    final operator = {'op': 'SN'};

    GlobalPreference.getDataUser().then((dataUser) {
      GlobalPreference.getDataDispositive().then((dataDispositive) {
        _socket!.emitWithAck(GlobalLabel.emitReconnect, [
          dataUser!.idVehicle,
          dataUser.idCity,
          dataUser.idBusiness,
          dataUser.idUser,
          '${dataUser.name} ${dataUser.lastName}',
          GlobalFunction().generatedSHA256(dataDispositive!.imei),
          dataDispositive.model,
          dataDispositive.versionSystem,
          dataDispositive.brand,
          dataDispositive.version,
          request,
          operator,
        ], ack: (response) {
          if (kDebugMode) {
            GlobalFunction().printWrapped('AUTHENTICATE >>> $response');
          }

          /// 1: User no authorized
          /// -1: User locked
          /// 2: Dispositive not authorized
          /// 3: Authorized user
          switch (response['estado']) {
            case 1:
              GlobalFunction().hideProgress();
              GlobalPreference().setDataUser(dataUser);
              prPrincipalRead.addListConfigurationDriver(
                  prPrincipalRead.listConfigurationDriver!);
              GlobalFunction().nextPageUntilView(const PageLogOutRemote());
              break;
            case -1:
              GlobalFunction().hideProgress();
              GlobalFunction().closeView();
              GlobalFunction().nextPageViewTransition(
                  const PageClosingSession(message: GlobalLabel.textLocked));
              break;
            case 2:
              GlobalFunction().hideProgress();
              GlobalFunction().closeView();
              GlobalFunction().nextPageViewTransition(
                  PageClosingSession(message: response['nombres']));
              break;
            case 3:
              ResponseUser responseUser = ResponseUser.fromMap(response);
              GlobalPreference().setStateLogin(true);
              prPrincipalRead.loadDataView(
                  GlobalFunction.context.currentContext!,
                  responseUser.cnf!,
                  typeConnected);
              break;
          }
        });
      });
    });
  }

  /// Disable listening new request
  void disableGlobalEvents() {
    if (_socket == null) return;
    _socket!.off(GlobalLabel.emitGlobalEvents);
  }

  /// Postulation data json format
  formatDataPostulation(ModelUser user, ModelRequest request, double cost,
      int time, double price, int state) {
    final data = {
      'idSolicitud': request.requestData!.requestId,
      'atendidaDesde': GlobalLabel.attendedFrom,
      'idEmpresa': user.idBusiness,
      'idVehiculo': user.idVehicle,
      'empresa': user.business,
      'unidad': user.unitVehicle,
      'placa': user.vehiclePlate,
      'regMunicipal': user.regMunVehicle,
      'nombres': user.name,
      'apellidos': user.lastName,
      'telefono': user.phone,
      'imagen': user.imageDriver,
      'costo': cost,
      'distancia': request.requestData!.distance,
      'c': cost,
      'estado': state,
      'tiempo': time,
    };
    return data;
  }

  /// Action button request
  void actionButtonRequest(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prServiceRestRead = context.read<ProviderServiceRest>();
    final prChatRequestRead = context.read<ProviderChatRequest>();
    final prChatRequestWatch = context.read<ProviderChatRequest>();

    final prMapRead = context.read<ProviderMap>();
    if (prPrincipalRead.modelRequestActive!.statusDriver == 3 &&
        prPrincipalRead.modelRequestActive!.requestData!.advice! == 0) {
      sendArrived(context);
    } else {
      switch (prPrincipalRead.modelRequestActive!.statusDriver) {
        case 3:
          if (prPrincipalRead.modelRequestActive!.requestType == 3) {
            prServiceRestRead.sendAboardRequestStreet(
                context,
                prPrincipalRead.modelRequestActive!.requestData!.requestId!,
                5,
                9);
            prServiceRestRead.consultTaximeterStreet(context, 2);
          } else if (prPrincipalRead.modelRequestActive!.requestType == 1 ||
              prPrincipalRead.modelRequestActive!.requestType == 4) {
            prChatRequestWatch.deleteBadgeChat();
            prChatRequestRead.updateViewChat();
            prServiceRestRead.sendBoardRequest(
                context,
                prPrincipalRead.modelRequestActive!.requestData!.requestId!,
                5,
                9,
                prPrincipalRead.modelRequestActive!.requestType!);
            prServiceRestRead.consultTaximeterRequest(
                context, prPrincipalRead.modelRequestActive!);
          }
          prPrincipalRead.resetChronometer();
          prMapRead.deleteTracingRouteMap();
          prMapRead.deleteMarker(GlobalLabel.textOriginMarker);
          notifyListeners();
          break;
        case 5:
          activePayment(context);
          break;
      }
    }
  }

  void sendArrived(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    _socket!.emitWithAck(GlobalLabel.emitSendChatRequest, [
      prPrincipalRead.modelRequestActive!.requestData!.requestId,
      prPrincipalRead.modelRequestActive!.username,
      GlobalLabel.textNoticeArrives,
    ], ack: (data) {
      if (data != null) {
        if (kDebugMode) {
          print('ALERT ARRIVE >>> $data');
        }
        prPrincipalRead.modelRequestActive!.requestData!.advice = 1;
        GlobalFunction().playAudio(GlobalLabel.identificationNoticeArrival);
        prPrincipalRead.getNameButtonRequestActive();
        prPrincipalRead.getDescriptionStateRequest();
        return null;
      }
    });
  }

  void activePayment(BuildContext context) {
    final prTaximeterRead = context.read<ProviderTaximeter>();
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prServiceRestRead = context.read<ProviderServiceRest>();
    final prPaymentRead = context.read<ProviderPayment>();

    if (prPrincipalRead.modelRequestActive!.requestData != null) {
      prTaximeterRead.setPriceTotal(context);
      if (prPrincipalRead.modelRequestActive!.requestData!.paymentType == 9) {
        GlobalFunction().showProgress();
        prServiceRestRead.consultPaymentHybrid(context);
      } else {
        prPrincipalRead.stateShowButtonPaymentStreet = false;
        prPrincipalRead.stateShowButtonPayment = true;
        prPrincipalRead.stateShowButtonPaymentHybrid = false;
        if (!prPaymentRead.showPagePayment) {
          GlobalFunction().nextPageViewTransition(const PagePayment());
        }
      }
    } else {
      prTaximeterRead.priceTotal = prTaximeterRead.priceTotalStreet;
      prPrincipalRead.stateShowButtonPaymentStreet = true;
      prPrincipalRead.stateShowButtonPayment = false;
      prPrincipalRead.stateShowButtonPaymentHybrid = false;
      if (!prPaymentRead.showPagePayment) {
        GlobalFunction().nextPageViewTransition(const PagePayment());
      }
    }
  }

  /// Send payment request
  sendPaymentService(BuildContext context) {
    final prTaximeterRead = context.read<ProviderTaximeter>();
    final prPaymentRead = context.read<ProviderPayment>();
    final prPrincipalRead = context.read<ProviderPrincipal>();
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
    GlobalPreference.getDataUser().then((modelUser) {
      if (prPrincipalRead.modelRequestActive!.requestData!.paymentType == 1) {
        if (prPaymentRead.editPin.text.trim().isEmpty) {
          GlobalFunction()
              .messageAlert(context, GlobalLabel.textWritePINVoucher);
          GlobalFunction().speakMessage(GlobalLabel.textWritePINVoucher);
          return;
        }

        if (prPaymentRead.editPin.text.trim().length < 4) {
          GlobalFunction()
              .messageAlert(context, GlobalLabel.textWriteCheckPINVoucher);
          GlobalFunction().speakMessage(GlobalLabel.textWriteCheckPINVoucher);
          return;
        }
      }
      if (GlobalFunction().checkHourDay()) {
        if (double.parse(prTaximeterRead.priceTotal.toString()) <
            prTaximeterRead.taximeter.cD!) {
          return GlobalFunction().messageAlert(context,
              '${GlobalLabel.textMessageErrorMinorPayment} ${prTaximeterRead.taximeter.cD!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}');
        }
      } else {
        if (double.parse(prTaximeterRead.priceTotal.toString()) <
            prTaximeterRead.taximeter.cN!) {
          return GlobalFunction().messageAlert(context,
              '${GlobalLabel.textMessageErrorMinorPayment} ${prTaximeterRead.taximeter.cN!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}');
        }
      }

      switch (prPrincipalRead.modelRequestActive!.requestData!.paymentType) {
        case 0:
        case 4:
        case 9:
          GlobalFunction().showProgress();
          _socket!.emitWithAck(
              prPrincipalRead.modelRequestActive!.requestData!.requestId! > 0
                  ? GlobalLabel.emitPaymentCash
                  : GlobalLabel.emitPaymentOrder,
              [
                prPaymentRead.formatDataPayment(
                    context,
                    modelUser!,
                    prPrincipalRead.modelRequestActive!,
                    1,
                    0,
                    0.0,
                    double.parse(prTaximeterRead.priceTotal))
              ], ack: (response) async {
            if (response == null) {
              return GlobalFunction()
                  .messageAlert(context, GlobalLabel.textMessageError);
            }
            if (kDebugMode) {
              print('PAYMENT REQUEST CASH >>>> $response');
            }
            GlobalFunction().hideProgress();
            switch (response['e']) {
              case -1:
                GlobalFunction().messageAlert(context, response['m']);
                break;
              case 1:
                GlobalFunction().nextPageViewTransition(
                    WidgetCheck(message: response['m']));
                prPrincipalRead.finalizeRequest(1);
                break;
            }
          });
          break;
        case 1:
          GlobalFunction().showProgress();
          _socket!.emitWithAck(GlobalLabel.emitPaymentPin, [
            prPaymentRead.formatDataPaymentVoucher(
                context,
                modelUser!,
                prPrincipalRead.modelRequestActive!,
                1,
                0.0,
                0.0,
                double.parse(prTaximeterRead.priceTotal.trim()),
                int.parse(prPaymentRead.editPin.text.trim()))
          ], ack: (response) {
            if (kDebugMode) {
              print('PAYMENT REQUEST VOUCHER >>>> $response');
            }
            GlobalFunction().hideProgress();
            switch (response['e']) {
              case -1:
                GlobalFunction().messageAlert(context, response['m']);
                GlobalFunction().speakMessage(response['m']);
                prPrincipalRead.modelRequestActive!.requestData!.paymentType =
                    0;
                break;
              case 1:
                GlobalFunction().nextPageViewTransition(
                    WidgetCheck(message: response['m']));
                prPrincipalRead.finalizeRequest(1);
                break;
            }
          });
          break;
        case 7:
          GlobalFunction().showProgress();
          String timeStanD =
              GlobalFunction().dateNow.millisecondsSinceEpoch.toString();
          String token = GlobalFunction().generatedSHA256(
              '$timeStanD${GlobalFunction().generatedMd5(prPrincipalRead.modelUser.idUser!.toString())}');
          String key = GlobalFunction().generatedMd5(
              '${GlobalFunction().generatedSHA256(prPrincipalRead.modelUser.idUser!.toString())}$timeStanD');

          _socket!.emitWithAck(GlobalLabel.emitPaymentCreditCard, [
            modelUser!.idUser!,
            timeStanD,
            token,
            key,
            prPaymentRead.formatDataPayment(
                context,
                modelUser,
                prPrincipalRead.modelRequestActive!,
                1,
                0,
                0.0,
                double.parse(prTaximeterRead.priceTotal.trim())),
          ], ack: (response) {
            if (response == null) return;
            if (kDebugMode) {
              print('PAYMENT REQUEST CREDIT CARD >>>> $response');
            }
            GlobalFunction().hideProgress();
            if (response.toString().contains('success')) {
              if (response['success'] == 1) {
                GlobalFunction().nextPageViewTransition(const WidgetCheck(
                    message: 'El cobro se ha realizado correctamente'));
                prPrincipalRead.finalizeRequest(1);
              }
            }
          });
          break;
      }
    });
  }

  /// Send alert panic
  /// Type 1: Send panic
  /// Type 2: Possible requests
  /// Type 3: New request type travel
  /// Type 4: New request type order
  /// Type 5: Send possible request
  alertPanic(BuildContext context, int type) {
    final prMapRead = context.read<ProviderMap>();
    final prPrincipalRead = context.read<ProviderPrincipal>();
    int idRequest = prPrincipalRead.modelRequestActive!.requestData!.requestId!;

    GlobalPreference.getDataUser().then((dataUser) {
      final data = {
        'usuario': dataUser!.idUser!,
        'empresa': dataUser.business,
        'numeroUnidad': dataUser.unitVehicle,
        'idAplicativo': GlobalLabel.idApplication,
        't': 1,
        'iPS': 0,
        'lt': prMapRead.positionLatitude,
        'lg': prMapRead.positionLongitude,
        "iS": idRequest,
      };

      _socket!.emitWithAck(GlobalLabel.emitSendPanic, [
        dataUser.idUser,
        dataUser.idCity,
        dataUser.idVehicle,
        data
      ], ack: (data) {
        if (kDebugMode) {
          print('SEND ALERT PANIC >>> $data');
        }
      });
    });
  }

  /// Send audio char walkies talkie
  /// Type 1: User of my business
  /// Type 2: Call Center
  /// Type 3: All business
  sendChatAudioWalkiesTalkie(Uint8List message, int typeEmit) {
    final prPrincipalRead =
        GlobalFunction.context.currentContext!.read<ProviderPrincipal>();
    final prWalkiesTalkieRead =
        GlobalFunction.context.currentContext!.read<ProviderWalkiesTalkie>();

    String urlEmit;
    final data = {
      'n': prPrincipalRead.modelUser.name,
      'iE': prPrincipalRead.modelUser.idBusiness,
      'iU': prPrincipalRead.modelUser.idUser,
      "u": prPrincipalRead.modelUser.unitVehicle
    };
    if (typeEmit == 1) {
      urlEmit = GlobalLabel.emitChatRecordAllBusiness;
    } else if (typeEmit == 2) {
      urlEmit = GlobalLabel.emitChatRecordCallCenter;
    } else {
      urlEmit = GlobalLabel.emitChatRecordAll;
    }

    _socket!.emitWithAck(urlEmit, [data, message], ack: (data) {
      if (data != null) {
        if (kDebugMode) {
          print('REQUEST WALKIES TALK >>> $data');
        }
        if (data['en'] == 1) {
          prWalkiesTalkieRead.addAudioWalkies(
              "Yo",
              "123",
              prWalkiesTalkieRead.pathAudio,
              prWalkiesTalkieRead.positionSelectedRequest);
        }
      }
    }, binary: true);
  }

  /// Activate listen record user all business
  activateListenRecordUserBusiness(
      VoidCallback? Function(dynamic data) callback) {
    _socket!.on(GlobalLabel.emitListenChatRecordUserAllBusiness, (data) {
      if (kDebugMode) {
        print('LISTEN RECORD USER ALL BUSINESS >>> $data');
      }
      if (data != null) {
        callback(data);
      }
    });
  }

  /// Activate listen record call center
  activateListenRecordCallCenter(
      VoidCallback? Function(dynamic data) callback) {
    _socket!.on(GlobalLabel.emitListenChatRecordCallCenter, (data) {
      if (kDebugMode) {
        print('LISTEN RECORD CALL CENTER >>> $data');
      }
      if (data != null) {
        callback(data);
      }
    });
  }

  /// Activate listen record All
  activateListenRecordAll(VoidCallback? Function(dynamic data) callback) {
    _socket!.on(GlobalLabel.emitListenChatRecordAll, (data) {
      if (kDebugMode) {
        print('LISTEN RECORD ALL >>> $data');
      }
      if (data != null) {
        callback(data);
      }
    });
  }

  /// **** NEW SOCKET ****

  /// Listening global
  /// State 1: New request
  /// State 2: Send postulation corrected
  /// State 3: Request attended other driver
  /// State 4: Request accepted
  /// State 5: Delete request to the list
  /// State 6: Cancel request after postulation
  /// State 7: Cancel request
  /// State 8: Message informative
  /// State 9: Message informative type text by cancelled
  /// State 10: Message informative type audio by cancelled
  /// State 11: Message informative type audio and text by cancelled
  /// State 12: Log Out server
  /// State 13: Request call center
  /// State 14: Chat request
  void activeGlobalEvents(BuildContext context) {
    final prServiceRestRead =
        GlobalFunction.context.currentContext!.read<ProviderServiceRest>();
    final prPrincipalRead =
        GlobalFunction.context.currentContext!.read<ProviderPrincipal>();
    final prChatRequestRead =
        GlobalFunction.context.currentContext!.read<ProviderChatRequest>();
    if (_socket == null) return;
    if (kDebugMode) {
      print('GLOBAL EVENTS ACTIVATED IDENTIFIER >>> ${_socket!.id}');
    }
    disableGlobalEvents();
    _socket!.on(GlobalLabel.emitGlobalEvents, (response) {
      if (response != null) {
        if (kDebugMode) {
          print('GLOBAL EVENTS >>> $response');
        }
        ModelEvent modelEvent = ModelEvent.fromMap(response);
        if (modelEvent.state != 13) {
          if (modelEvent.data!.requestId != 0) {
            switch (modelEvent.state) {
              case 1:
                if (!prPrincipalRead.sendPreviewPostulation &&
                    !prPrincipalRead.sendPostulation &&
                    prPrincipalRead.modelRequestActive!.requestData == null &&
                    !prPrincipalRead.stateTaximeterStreet) {
                  prServiceRestRead.sendEvent(
                      GlobalFunction.context.currentContext!,
                      3,
                      modelEvent.data!.requestId!,
                      double.parse(
                          modelEvent.data!.distance!.toStringAsFixed(2)));
                }
                break;
              case 2:
                prPrincipalRead.sendPostulation = true;
                prPrincipalRead.sendPreviewPostulation = false;
                prServiceRestRead.sendUpdateStateDriver(context);
                break;
              case 3:
                if (prPrincipalRead.listModelRequest!.isEmpty) return;
                if (prPrincipalRead.modelRequestPostulation != null &&
                    prPrincipalRead.modelRequestPostulation!.requestData !=
                        null &&
                    prPrincipalRead
                            .modelRequestPostulation!.requestData!.requestId ==
                        modelEvent.data!.requestId) {
                  GlobalFunction().speakMessage(GlobalLabel.textOtherDriver);
                  prPrincipalRead.stopPostulation();
                  prServiceRestRead.sendUpdateStateDriver(context);
                }
                prPrincipalRead.deleteRequest(modelEvent.data!.requestId!);
                break;
              case 4:
                if (prPrincipalRead.modelRequestPostulation != null &&
                    prPrincipalRead.modelRequestPostulation!.requestData !=
                        null &&
                    prPrincipalRead
                            .modelRequestPostulation!.requestData!.requestId ==
                        modelEvent.data!.requestId) {
                  prPrincipalRead.deleteRequest(modelEvent.data!.requestId!);
                  prPrincipalRead.stopPostulation();
                  prPrincipalRead.modelRequestPostulation!.statusDriver = 3;
                  prPrincipalRead.modelRequestActive =
                      prPrincipalRead.modelRequestPostulation;

                  prPrincipalRead.clearRequestList();
                  GlobalPreference().setTimeTravelUser(
                      prPrincipalRead.modelRequestActive!.requestData!.times!);
                  prPrincipalRead.activeRequest(
                      prPrincipalRead.modelRequestActive!, 1);
                  notifyListeners();
                  prServiceRestRead.sendUpdateStateDriver(context);
                  prPrincipalRead.markerDetailRequest();
                }
                break;
              case 5:
                if (prPrincipalRead.listModelRequest!.isEmpty) return;
                if (prPrincipalRead.modelRequestPostulation != null &&
                    prPrincipalRead.modelRequestPostulation!.requestData !=
                        null &&
                    prPrincipalRead
                            .modelRequestPostulation!.requestData!.requestId ==
                        modelEvent.data!.requestId) {
                  prPrincipalRead.deleteRequest(modelEvent.data!.requestId!);
                  GlobalFunction().speakMessage(GlobalLabel.textCancelUser);
                  prPrincipalRead.stopPostulation();
                } else {
                  prPrincipalRead.deleteRequest(modelEvent.data!.requestId!);
                }
                notifyListeners();
                prServiceRestRead.sendUpdateStateDriver(context);
                break;
              case 6:
                if (prPrincipalRead.modelRequestActive!.requestData == null) {
                  prPrincipalRead.deleteRequest(modelEvent.data!.requestId!);
                  if (prPrincipalRead.sendPostulation) {
                    prPrincipalRead.stopPostulation();
                    GlobalFunction()
                        .speakMessage(GlobalLabel.textNoAcceptPostulation);
                    prServiceRestRead.sendUpdateStateDriver(context);
                  }
                } else {
                  FlutterForegroundTask.launchApp();
                  prPrincipalRead.resetChronometer();
                  GlobalFunction().speakMessage(GlobalLabel.textCancelUser);
                  GlobalFunction().nextPageViewTransition(
                      PageCanceledUser(requestId: modelEvent.data!.requestId!));
                  prPrincipalRead.finalizeRequest(2);
                }

                break;
              case 7:
                if (prPrincipalRead.modelRequestActive!.requestData == null) {
                  if (prPrincipalRead.sendPreviewPostulation &&
                      prPrincipalRead.sendPostulation) {
                    prPrincipalRead.stopPostulation();
                    prPrincipalRead.deleteRequest(modelEvent.data!.requestId!);
                    GlobalFunction().speakMessage(GlobalLabel.textCancelUser);
                  }
                } else {
                  GlobalFunction().speakMessage(GlobalLabel.textCancelUser);
                  GlobalFunction().nextPageViewTransition(
                      PageCanceledUser(requestId: modelEvent.data!.requestId!));
                  prPrincipalRead.finalizeRequest(2);
                }
                notifyListeners();
                prServiceRestRead.sendUpdateStateDriver(context);
                break;
              case 8:

                /// Mensaje informativo texto
                break;
              case 9:

                /// Mensaje informativo texto cancelacion
                break;
              case 10:

                /// Mensaje informativo audio cancelacion
                break;
              case 11:

                /// Mensaje informativo text audio cancelacion
                break;
              case 14:
                prChatRequestRead.addMessageListChat(modelEvent.data!.message!,
                    '124', modelEvent.data!.typeChat!);

                /// Mensaje informativo text audio cancelacion
                break;
            }
          } else {
            switch (modelEvent.state) {
              case 12:
                GlobalFunction().nextPageViewTransition(
                    PageLogOutServer(message: modelEvent.data!.message!));
                break;
            }
          }
        } else {
          if (!prPrincipalRead.sendPreviewPostulation &&
              !prPrincipalRead.sendPostulation &&
              prPrincipalRead.modelRequestActive!.requestData == null &&
              !prPrincipalRead.stateTaximeterStreet) {
            prServiceRestRead.activeRequestCallCenter(
                ModelRequest.fromMap(response['data']));
          }
        }
      }
    });
  }

  /// Send chat
  sendChat(int type, int typeMessage, String message) {
    final prPrincipalRead =
        GlobalFunction.context.currentContext!.read<ProviderPrincipal>();
    final prChatRequestRead =
        GlobalFunction.context.currentContext!.read<ProviderChatRequest>();

    if (typeMessage == 0) {
      if (message.isEmpty) return;
    }
    if (prPrincipalRead.modelRequestActive!.requestType == 1) {
      if (type == 1 && typeMessage == 1) {
        prChatRequestRead.editChat.clear();
      }
      prChatRequestRead.typeChat = false;
      _socket!.emitWithAck(GlobalLabel.emitSendChatRequest, [
        prPrincipalRead.modelRequestActive!.requestData!.requestId,
        prPrincipalRead.modelRequestActive!.requestData!.user!.clientId,
        message
      ], ack: (data) {
        if (data != null) {
          if (kDebugMode) {
            print('REQUEST CHAT REQUEST >>> $data');
          }
          if (data == 1) {
            prChatRequestRead.editChat.clear();
          }
          prChatRequestRead.typeChat = false;
          prChatRequestRead.addMessageListChat(message, '123', 1);
          return null;
        }
      });
    }
  }

  /// Send chat type audio
  /// Chat driver: '123'
  sendChatAudio(Uint8List message) {
    final prPrincipalRead =
        GlobalFunction.context.currentContext!.read<ProviderPrincipal>();
    final prChatRequestRead =
        GlobalFunction.context.currentContext!.read<ProviderChatRequest>();
    final Map<String, dynamic> data;
    data = {
      'tipo': 1,
      'to': prPrincipalRead.modelRequestActive!.username,
      'idSolicitud': prPrincipalRead.modelRequestActive!.requestData!.requestId,
    };
    _socket!.emitWithAck(GlobalLabel.emitSendChatAudioRequest, [data, message],
        ack: (data) {
      if (data != null) {
        if (kDebugMode) {
          print('REQUEST CHAT REQUEST >>> $data');
        }
        prChatRequestRead.typeChat = false;
        if (data == 1) {
          prChatRequestRead.addMessageListChat(message.toString(), '123', 4);
          return null;
        }
        return null;
      }
    }, binary: true);
  }

  /// Active listen chat
  activeListenChat(BuildContext context) {
    final prChatRequestRead = context.read<ProviderChatRequest>();
    final prConfigurationAppRead = context.read<ProviderConfigurationApp>();
    final prPrincipalRead = context.read<ProviderPrincipal>();
    _socket!.on(GlobalLabel.emitListenChat, (data) {
      if (kDebugMode) {
        print('LISTEN CHAT REQUEST >>> $data');
      }
      FlutterForegroundTask.launchApp();
      if (data != null) {
        prChatRequestRead.dataEmit = data[0] != null
            ? ModelDataEmit.fromMap(data[0])
            : ModelDataEmit.fromMap(data);
        if (prChatRequestRead.dataEmit.audio!) {
          prChatRequestRead.getAudioOld(data![1]);
        } else {
          if (prChatRequestRead.dataEmit.state != 0) {
            prPrincipalRead.statusResponseEmit();
          } else {
            if (prPrincipalRead.modelRequestActive == null ||
                prPrincipalRead.modelRequestActive!.requestData == null) return;
            if (prChatRequestRead.dataEmit.messageChat!.isNotEmpty) {
              prChatRequestRead.messageChatUser =
                  prChatRequestRead.dataEmit.messageChat!;
              prChatRequestRead.addMessageListChat(
                  prChatRequestRead.dataEmit.messageChat!, '124', 1);
              if (prConfigurationAppRead.modelConfigurationApp.speakChat!) {
                GlobalFunction().speakMessage(
                    '${GlobalLabel.textSpeakChat}, ${prChatRequestRead.dataEmit.messageChat!}');
              }
              return null;
            }
          }
          return null;
        }
        return null;
      }
    });
  }
}
