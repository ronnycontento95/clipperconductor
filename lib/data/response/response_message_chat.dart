import 'dart:convert';

import '../../domain/entities/model_message_chat.dart';
import 'response_api.dart';

class ResponseMessageChat extends ResponseApi {
  List<ModelMessageChat>? data = [];

  ResponseMessageChat({this.data});

  factory ResponseMessageChat.fromJson(String str) =>
      ResponseMessageChat.fromMap(json.decode(str));

  @override
  String toJson() => json.encode(toMap());

  ResponseMessageChat.fromMap(Map<String, dynamic> json)
      : data = (json["data"] == null
            ? []
            : List<ModelMessageChat>.from(
                json["data"].map((x) => ModelMessageChat.fromMap(x)))),
        super.fromMap(json);

  @override
  Map<String, dynamic> toMap() => {
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };

  @override
  String toString() {
    return 'ResponseMessageChat{data: $data}';
  }
}
