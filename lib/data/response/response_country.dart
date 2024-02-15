import 'dart:convert';

import '../../domain/entities/model_country.dart';
import 'response_api.dart';


class ResponseCountry extends ResponseApi {
  List<ModelCountry>? lCountry = [];

  ResponseCountry({this.lCountry});

  factory ResponseCountry.fromJson(String str) =>
      ResponseCountry.fromMap(json.decode(str));

  @override
  String toJson() => json.encode(toMap());

  ResponseCountry.fromMap(Map<String, dynamic> json)
      : lCountry = (json["lPaises"] == null
            ? []
            : List<ModelCountry>.from(
                json["lPaises"].map((x) => ModelCountry.fromMap(x)))),
        super.fromMap(json);

  @override
  Map<String, dynamic> toMap() => {
        "lPaises": lCountry == null
            ? []
            : List<dynamic>.from(lCountry!.map((x) => x.toMap())),
      };
}
