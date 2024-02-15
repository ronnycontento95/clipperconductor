import 'dart:convert';

import '../../domain/entities/model_paymet_hybrid.dart';
import 'response_api.dart';

class ResponsePaymentHybrid extends ResponseApi {
  ModelPaymentHybrid? data = ModelPaymentHybrid();

  ResponsePaymentHybrid({this.data});

  factory ResponsePaymentHybrid.fromJson(String str) =>
      ResponsePaymentHybrid.fromMap(json.decode(str));

  @override
  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'ResponsePaymentHybrid{data: $data}';
  }

  ResponsePaymentHybrid.fromMap(Map<String, dynamic> json)
      : data =
            json["data"] == null ? null : ModelPaymentHybrid.fromMap(json["data"]),
        super.fromMap(json);

  @override
  Map<String, dynamic> toMap() => {
        "data": data!.toMap(),
      };
}
