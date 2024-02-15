import 'dart:convert';


import '../../domain/entities/model_contact_user.dart';
import 'response_api.dart';


class ResponseContactUser extends ResponseApi {
  List<ModelContactUser>? lC = [];

  ResponseContactUser({this.lC});

  factory ResponseContactUser.fromJson(String str) =>
      ResponseContactUser.fromMap(json.decode(str));

  @override
  String toJson() => json.encode(toMap());

  ResponseContactUser.fromMap(Map<String, dynamic> json)
      : lC = (json["lC"] == null
            ? []
            : List<ModelContactUser>.from(
                json["lC"].map((x) => ModelContactUser.fromMap(x)))),
        super.fromMap(json);

  @override
  Map<String, dynamic> toMap() => {
        "lC": lC == null ? [] : List<dynamic>.from(lC!.map((x) => x.toMap())),
      };
}
