import 'dart:convert';

import '../../domain/entities/model_package_pending.dart';
import 'response_api.dart';

class ResponseDetailPackage extends ResponseApi {
  ModelPackagePending? p = ModelPackagePending();

  ResponseDetailPackage({this.p});

  factory ResponseDetailPackage.fromJson(String str) =>
      ResponseDetailPackage.fromMap(json.decode(str));

  @override
  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'ResponseDetailPackage{p: $p}';
  }

  ResponseDetailPackage.fromMap(Map<String, dynamic> json)
      : p = json["p"] == null ? null : ModelPackagePending.fromMap(json["p"]),
        super.fromMap(json);

  @override
  Map<String, dynamic> toMap() => {
        "p": p!.toMap(),
      };
}
