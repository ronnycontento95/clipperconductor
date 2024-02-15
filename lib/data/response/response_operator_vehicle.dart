import 'dart:convert';

import '../../domain/entities/model_user.dart';
import 'response_api.dart';

class ResponseOperatorVehicle extends ResponseApi {
  List<ModelUser>? lUser = [];

  ResponseOperatorVehicle({this.lUser});

  factory ResponseOperatorVehicle.fromJson(String str) =>
      ResponseOperatorVehicle.fromMap(json.decode(str));

  @override
  String toJson() => json.encode(toMap());

  ResponseOperatorVehicle.fromMap(Map<String, dynamic> json)
      : lUser = (json["usuario"] == null
            ? []
            : List<ModelUser>.from(
                json["usuario"].map((x) => ModelUser.fromMap(x)))),
        super.fromMap(json);

  @override
  Map<String, dynamic> toMap() => {
        "usuario": lUser == null
            ? []
            : List<dynamic>.from(lUser!.map((x) => x.toMap())),
      };
}
