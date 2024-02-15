import 'dart:convert';

import '../../domain/entities/model_configuration_driver.dart';
import '../../domain/entities/model_user.dart';
import 'response_api.dart';

class ResponseUser extends ResponseApi {
  ModelUser? user = ModelUser();

  List<ModelConfigurationDriver>? cnf = [];

  ResponseUser({this.user, this.cnf});

  factory ResponseUser.fromJson(String str) =>
      ResponseUser.fromMap(json.decode(str));

  @override
  String toJson() => json.encode(toMap());

  ResponseUser.fromMap(Map<String, dynamic> json)
      : user =
            json["usuario"] == null ? null : ModelUser.fromMap(json["usuario"]),
        cnf = (json["cnf"] == null
            ? []
            : List<ModelConfigurationDriver>.from(
                json["cnf"].map((x) => ModelConfigurationDriver.fromMap(x)))),
        super.fromMap(json);

  @override
  Map<String, dynamic> toMap() => {
        "usuario": user!.toMap(),
        "cnf":
            cnf == null ? [] : List<dynamic>.from(cnf!.map((x) => x.toMap())),
      };
}
