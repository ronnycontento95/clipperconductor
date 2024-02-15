import 'dart:convert';

class ResponseApi {
  int? statusCode;
  String? message;

  ResponseApi({
    this.statusCode,
    this.message,
  });

  String toJson() => json.encode(toMap());

  ResponseApi.fromMap(Map<String, dynamic> json) {
    statusCode = json["statusCode"];
    message = json["message"];
  }

  Map<String, dynamic> toMap() => {
        "statusCode": statusCode,
        "message": message,
      };
}
