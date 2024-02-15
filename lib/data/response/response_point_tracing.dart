import 'dart:convert';

import '../../domain/entities/model_point_tracing.dart';
import 'response_api.dart';

class ResponsePointTracing extends ResponseApi {
  List<ModelPointTracing>? points = [];

  ResponsePointTracing({this.points});

  factory ResponsePointTracing.fromJson(String str) =>
      ResponsePointTracing.fromMap(json.decode(str));

  @override
  String toJson() => json.encode(toMap());

  ResponsePointTracing.fromMap(Map<String, dynamic> json)
      : points = (json["points"] == null
            ? []
            : List<ModelPointTracing>.from(
                json["points"].map((x) => ModelPointTracing.fromMap(x)))),
        super.fromMap(json);

  @override
  Map<String, dynamic> toMap() => {
        "points": points == null
            ? []
            : List<dynamic>.from(points!.map((x) => x.toMap())),
      };
}
