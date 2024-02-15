import 'dart:convert';

import '../../domain/entities/model_transaction.dart';
import 'response_api.dart';

class ResponseTransaction extends ResponseApi {
  List<ModelTransaction>? lT = [];

  ResponseTransaction({this.lT});

  factory ResponseTransaction.fromJson(String str) =>
      ResponseTransaction.fromMap(json.decode(str));

  @override
  String toJson() => json.encode(toMap());

  ResponseTransaction.fromMap(Map<String, dynamic> json)
      : lT = (json["lT"] == null
            ? []
            : List<ModelTransaction>.from(
                json["lT"].map((x) => ModelTransaction.fromMap(x)))),
        super.fromMap(json);

  @override
  Map<String, dynamic> toMap() => {
        "lT": lT == null ? [] : List<dynamic>.from(lT!.map((x) => x.toMap())),
      };
}
