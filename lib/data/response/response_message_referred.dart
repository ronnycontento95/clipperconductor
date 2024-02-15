import 'dart:convert';

import '../../domain/entities/model_message_referred.dart';
import 'response_api.dart';

class ResponseMessageReferred extends ResponseApi {
  List<ModelMessageReferred>? data = [];

  ResponseMessageReferred({this.data});

  factory ResponseMessageReferred.fromJson(String str) =>
      ResponseMessageReferred.fromMap(json.decode(str));

  @override
  String toJson() => json.encode(toMap());

  ResponseMessageReferred.fromMap(Map<String, dynamic> json)
      : data = (json["data"] == null
            ? []
            : List<ModelMessageReferred>.from(
                json["data"].map((x) => ModelMessageReferred.fromMap(x)))),
        super.fromMap(json);

  @override
  Map<String, dynamic> toMap() => {
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}
