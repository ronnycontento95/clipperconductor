import 'dart:convert';

import '../../domain/entities/model_service_active.dart';
import 'response_api.dart';

class ResponseServiceActive extends ResponseApi {
  List<ModelServiceActive>? data = [];

  ResponseServiceActive({this.data});

  factory ResponseServiceActive.fromJson(String str) =>
      ResponseServiceActive.fromMap(json.decode(str));

  @override
  String toJson() => json.encode(toMap());

  ResponseServiceActive.fromMap(Map<String, dynamic> json)
      : data = (json["data"] == null
            ? []
            : List<ModelServiceActive>.from(
                json["data"].map((x) => ModelServiceActive.fromMap(x)))),
        super.fromMap(json);

  @override
  Map<String, dynamic> toMap() => {
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}
