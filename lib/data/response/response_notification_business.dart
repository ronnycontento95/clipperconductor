import 'dart:convert';


import '../../domain/entities/model_notification_business.dart';
import 'response_api.dart';

class ResponseNotificationBusiness extends ResponseApi {
  List<ModelNotificationBusiness>? lN = [];

  ResponseNotificationBusiness({this.lN});

  factory ResponseNotificationBusiness.fromJson(String str) =>
      ResponseNotificationBusiness.fromMap(json.decode(str));

  ResponseNotificationBusiness.fromMap(Map<String, dynamic> json)
      : lN = (json["lN"] == null
            ? []
            : List<ModelNotificationBusiness>.from(
                json["lN"].map((x) => ModelNotificationBusiness.fromMap(x)))),
        super.fromMap(json);

  @override
  Map<String, dynamic> toMap() => {
        "lN": lN == null ? [] : List<dynamic>.from(lN!.map((x) => x.toMap())),
      };
}
