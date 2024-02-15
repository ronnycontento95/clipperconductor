import 'dart:convert';


import '../../domain/entities/model_package_pending.dart';
import 'response_api.dart';


class ResponsePackagePending extends ResponseApi {
  List<ModelPackagePending>? lP = [];

  ResponsePackagePending({this.lP});

  factory ResponsePackagePending.fromJson(String str) =>
      ResponsePackagePending.fromMap(json.decode(str));

  @override
  String toJson() => json.encode(toMap());

  ResponsePackagePending.fromMap(Map<String, dynamic> json)
      : lP = (json["lP"] == null
            ? []
            : List<ModelPackagePending>.from(
                json["lP"].map((x) => ModelPackagePending.fromMap(x)))),
        super.fromMap(json);

  @override
  Map<String, dynamic> toMap() => {
        "lP": lP == null ? [] : List<dynamic>.from(lP!.map((x) => x.toMap())),
      };
}
