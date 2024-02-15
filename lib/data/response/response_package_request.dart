import 'dart:convert';


import '../../domain/entities/model_package_request.dart';
import 'response_api.dart';

class ResponsePackageRequest extends ResponseApi {
  List<ModelPackageRequest>? lPt = [];

  ResponsePackageRequest({this.lPt});

  factory ResponsePackageRequest.fromJson(String str) =>
      ResponsePackageRequest.fromMap(json.decode(str));

  @override
  String toJson() => json.encode(toMap());

  ResponsePackageRequest.fromMap(Map<String, dynamic> json)
      : lPt = (json["lPt"] == null
      ? []
      : List<ModelPackageRequest>.from(
      json["lPt"].map((x) => ModelPackageRequest.fromMap(x)))),
        super.fromMap(json);

  @override
  Map<String, dynamic> toMap() => {
    "lPt":
    lPt == null ? [] : List<dynamic>.from(lPt!.map((x) => x.toMap())),
  };
}
