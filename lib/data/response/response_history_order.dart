import 'dart:convert';


import '../../domain/entities/model_history_order.dart';
import 'response_api.dart';

class ResponseHistoryOrder extends ResponseApi {
  List<ModelHistoryOrder>? lHP = [];

  ResponseHistoryOrder(this.lHP);

  @override
  String toJson() => json.encode(toMap());

  ResponseHistoryOrder.fromMap(Map<String, dynamic> json)
      : lHP = (json["lHP"] == null
      ? []
      : List<ModelHistoryOrder>.from(
      json["lHP"].map((x) => ModelHistoryOrder.fromMap(x)))),
        super.fromMap(json);

  @override
  Map<String, dynamic> toMap() => {
    "lHP":
    lHP == null ? [] : List<dynamic>.from(lHP!.map((x) => x.toMap())),
  };
}
