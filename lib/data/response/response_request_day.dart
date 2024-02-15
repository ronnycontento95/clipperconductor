import 'dart:convert';


import '../../domain/entities/model_history_request_day.dart';
import 'response_api.dart';

class ResponseRequestDay extends ResponseApi {
  List<ModelHistoryRequestDay>? lSH = [];

  ResponseRequestDay({this.lSH});

  factory ResponseRequestDay.fromJson(String str) =>
      ResponseRequestDay.fromMap(json.decode(str));

  @override
  String toJson() => json.encode(toMap());

  ResponseRequestDay.fromMap(Map<String, dynamic> json)
      : lSH = (json["lSH"] == null
            ? []
            : List<ModelHistoryRequestDay>.from(
                json["lSH"].map((x) => ModelHistoryRequestDay.fromMap(x)))),
        super.fromMap(json);

  @override
  Map<String, dynamic> toMap() => {
        "lSH":
        lSH == null ? [] : List<dynamic>.from(lSH!.map((x) => x.toMap())),
      };
}
