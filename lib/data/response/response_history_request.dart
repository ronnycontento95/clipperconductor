import 'dart:convert';


import '../../domain/entities/model_history_request.dart';
import 'response_api.dart';

class ResponseHistoryRequest extends ResponseApi {
  List<ModelHistoryRequest>? lHS = [];

  ResponseHistoryRequest(this.lHS);

  @override
  String toJson() => json.encode(toMap());

  ResponseHistoryRequest.fromMap(Map<String, dynamic> json)
      : lHS = (json["lHS"] == null
      ? []
      : List<ModelHistoryRequest>.from(
      json["lHS"].map((x) => ModelHistoryRequest.fromMap(x)))),
        super.fromMap(json);

  @override
  Map<String, dynamic> toMap() => {
    "lHS":
    lHS == null ? [] : List<dynamic>.from(lHS!.map((x) => x.toMap())),
  };
}
