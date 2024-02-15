import 'dart:convert';


import '../../domain/entities/model_balance.dart';
import 'response_api.dart';

class ResponseBalance extends ResponseApi {
  List<ModelBalance>? lS = [];

  ResponseBalance({this.lS});

  factory ResponseBalance.fromJson(String str) =>
      ResponseBalance.fromMap(json.decode(str));

  @override
  String toJson() => json.encode(toMap());

  ResponseBalance.fromMap(Map<String, dynamic> json)
      : lS = (json["lS"] == null
      ? []
      : List<ModelBalance>.from(json["lS"].map((x) => ModelBalance.fromMap(x)))),
        super.fromMap(json);

  @override
  Map<String, dynamic> toMap() => {
    "lS": lS == null ? [] : List<dynamic>.from(lS!.map((x) => x.toMap())),
  };
}
