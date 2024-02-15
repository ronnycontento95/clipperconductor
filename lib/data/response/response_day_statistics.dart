import 'dart:convert';

import '../../domain/entities/model_day_statistics.dart';
import 'response_api.dart';

class ResponseDayStatistics extends ResponseApi {
  ModelDayStatistics? data = ModelDayStatistics();

  ResponseDayStatistics({this.data});

  factory ResponseDayStatistics.fromJson(String str) =>
      ResponseDayStatistics.fromMap(json.decode(str));

  @override
  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'ResponseDayStatistics{data: $data}';
  }

  ResponseDayStatistics.fromMap(Map<String, dynamic> json)
      : data = json["data"] == null
            ? null
            : ModelDayStatistics.fromMap(json["data"]),
        super.fromMap(json);

  @override
  Map<String, dynamic> toMap() => {
        "data": data!.toMap(),
      };
}
