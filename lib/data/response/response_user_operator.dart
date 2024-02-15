import 'dart:convert';


import '../../domain/entities/model_user_operator.dart';
import 'response_api.dart';

class ResponseUserOperator extends ResponseApi {
  List<ModelUserOperator>? data = [];

  ResponseUserOperator({this.data});

  factory ResponseUserOperator.fromJson(String str) =>
      ResponseUserOperator.fromMap(json.decode(str));

  @override
  String toJson() => json.encode(toMap());

  ResponseUserOperator.fromMap(Map<String, dynamic> json)
      : data = (json["data"] == null
            ? []
            : List<ModelUserOperator>.from(
                json["data"].map((x) => ModelUserOperator.fromMap(x)))),
        super.fromMap(json);

  @override
  Map<String, dynamic> toMap() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}
