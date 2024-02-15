import 'dart:convert';

import '../../domain/entities/model_total_qualification.dart';
import 'response_api.dart';

class ResponseTotalQualification extends ResponseApi {
  List<ModelTotalQualification>? data = [];

  ResponseTotalQualification({this.data});

  @override
  String toString() {
    return 'ResponseTotalQualification{data: $data}';
  }

  factory ResponseTotalQualification.fromJson(String str) =>
      ResponseTotalQualification.fromMap(json.decode(str));

  @override
  String toJson() => json.encode(toMap());

  ResponseTotalQualification.fromMap(Map<String, dynamic> json)
      : data = (json["data"] == null
            ? []
            : List<ModelTotalQualification>.from(
                json["data"].map((x) => ModelTotalQualification.fromMap(x)))),
        super.fromMap(json);

  @override
  Map<String, dynamic> toMap() => {
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}
