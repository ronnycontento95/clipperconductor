import 'dart:convert';

import '../../domain/entities/model_search_direction.dart';
import 'response_api.dart';

class ResponseSearchDirection extends ResponseApi {
  List<ModelSearchDirection>? predictions = [];

  ResponseSearchDirection({this.predictions});

  factory ResponseSearchDirection.fromJson(String str) =>
      ResponseSearchDirection.fromMap(json.decode(str));

  @override
  String toJson() => json.encode(toMap());

  ResponseSearchDirection.fromMap(Map<String, dynamic> json)
      : predictions = (json["predictions"] == null
            ? []
            : List<ModelSearchDirection>.from(json["predictions"]
                .map((x) => ModelSearchDirection.fromMap(x)))),
        super.fromMap(json);

  @override
  Map<String, dynamic> toMap() => {
        "predictions": predictions == null
            ? []
            : List<dynamic>.from(predictions!.map((x) => x.toMap())),
      };

  @override
  String toString() {
    return 'ResponseSearchDirection{predictions: $predictions}';
  }
}
