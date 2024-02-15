import 'dart:convert';



import '../../domain/entities/model_debts.dart';
import 'response_api.dart';

class ResponseDebts extends ResponseApi {
  List<ModelDebts>? lD = [];

  ResponseDebts({this.lD});

  factory ResponseDebts.fromJson(String str) =>
      ResponseDebts.fromMap(json.decode(str));

  @override
  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'ResponseDebts{lD: $lD}';
  }

  ResponseDebts.fromMap(Map<String, dynamic> json)
      : lD = (json["lD"] == null
      ? []
      : List<ModelDebts>.from(json["lD"].map((x) => ModelDebts.fromMap(x)))),
        super.fromMap(json);

  @override
  Map<String, dynamic> toMap() => {
    "lD": lD == null ? [] : List<dynamic>.from(lD!.map((x) => x.toMap())),
  };
}
