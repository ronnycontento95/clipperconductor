import 'dart:convert';


import '../../domain/entities/model_taximeter.dart';
import 'response_api.dart';

class ResponseTaximeter extends ResponseApi {
  ModelTaximeter? r = ModelTaximeter();

  ResponseTaximeter({this.r});

  factory ResponseTaximeter.fromJson(String str) =>
      ResponseTaximeter.fromMap(json.decode(str));

  @override
  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Taximeter{r: $r}';
  }

  ResponseTaximeter.fromMap(Map<String, dynamic> json)
      : r = json["r"] == null ? null : ModelTaximeter.fromMap(json["r"]),
        super.fromMap(json);

  @override
  Map<String, dynamic> toMap() => {
    "r":  r!.toMap(),
  };
}
