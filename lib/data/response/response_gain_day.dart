import 'dart:convert';

import '../../domain/entities/model_gain_day_order.dart';
import '../../domain/entities/model_gain_day_request.dart';
import 'response_api.dart';

class ResponseGainDay extends ResponseApi {
  ModelGainDayRequest? g = ModelGainDayRequest();
  ModelGainDayOrder? p = ModelGainDayOrder();

  ResponseGainDay({this.g});

  factory ResponseGainDay.fromJson(String str) =>
      ResponseGainDay.fromMap(json.decode(str));

  @override
  String toJson() => json.encode(toMap());

  ResponseGainDay.fromMap(Map<String, dynamic> json)
      : g = json["g"] == null ? null : ModelGainDayRequest.fromMap(json["g"]),
        p = json["p"] == null ? null : ModelGainDayOrder.fromMap(json["p"]),
        super.fromMap(json);

  @override
  Map<String, dynamic> toMap() => {
        "g": g!.toMap(),
        "p": p!.toMap(),
      };
}
