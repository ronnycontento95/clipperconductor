import 'dart:convert';


import '../../domain/entities/model_package_recharge.dart';
import 'response_api.dart';

class ResponsePackageRecharge extends ResponseApi {
  List<ModelPackageRecharge>? data = [];

  ResponsePackageRecharge({this.data});

  factory ResponsePackageRecharge.fromJson(String str) =>
      ResponsePackageRecharge.fromMap(json.decode(str));

  @override
  String toJson() => json.encode(toMap());

  ResponsePackageRecharge.fromMap(Map<String, dynamic> json)
      : data = (json["data"] == null
            ? []
            : List<ModelPackageRecharge>.from(
                json["data"].map((x) => ModelPackageRecharge.fromMap(x)))),
        super.fromMap(json);

  @override
  Map<String, dynamic> toMap() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}
