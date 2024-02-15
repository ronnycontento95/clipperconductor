import 'dart:convert';

import '../../domain/entities/model_heat_map.dart';
import 'response_api.dart';

class ResponseHeatMap extends ResponseApi {
  List<ModelHeatMap>? data =[];

  ResponseHeatMap({this.data});

  factory ResponseHeatMap.fromJson(String str) =>
      ResponseHeatMap.fromMap(json.decode(str));

  @override
  String toJson() => json.encode(toMap());

  ResponseHeatMap.fromMap(Map<String, dynamic> json)
      : data = (json["data"] == null
      ? []
      : List<ModelHeatMap>.from(json["data"].map((x) => ModelHeatMap.fromMap(x)))),
        super.fromMap(json);

  @override
  Map<String, dynamic> toMap() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
  };
}
