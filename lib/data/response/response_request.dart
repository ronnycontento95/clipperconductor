

import 'dart:convert';

import '../../domain/entities/model_request.dart';
import 'response_api.dart';

class ResponseRequest extends ResponseApi {
  List<ModelRequest>? listRequest = [];

  ResponseRequest({this.listRequest});

  factory ResponseRequest.fromJson(String str) =>
      ResponseRequest.fromMap(json.decode(str));

  @override
  String toJson() => json.encode(toMap());

  ResponseRequest.fromMap(Map<String, dynamic> json)
      : listRequest = (json["data"] == null
            ? []
            : List<ModelRequest>.from(
                json["data"].map((x) => ModelRequest.fromMap(x)))),
        super.fromMap(json);

  @override
  Map<String, dynamic> toMap() => {
        "data": listRequest == null
            ? []
            : List<dynamic>.from(listRequest!.map((x) => x.toMap())),
      };
}
