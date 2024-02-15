import 'dart:convert';

import '../../domain/entities/model_eventuality.dart';
import 'response_api.dart';


class ResponseEventuality extends ResponseApi {
  List<ModelEventuality>? eventuality = [];

  ResponseEventuality({this.eventuality});

  factory ResponseEventuality.fromJson(String str) =>
      ResponseEventuality.fromMap(json.decode(str));

  @override
  String toJson() => json.encode(toMap());

  ResponseEventuality.fromMap(Map<String, dynamic> json)
      : eventuality = (json["eventuality"] == null
            ? []
            : List<ModelEventuality>.from(
                json["eventuality"].map((x) => ModelEventuality.fromMap(x)))),
        super.fromMap(json);

  @override
  Map<String, dynamic> toMap() => {
        "eventuality": eventuality == null
            ? []
            : List<dynamic>.from(eventuality!.map((x) => x.toMap())),
      };
}
