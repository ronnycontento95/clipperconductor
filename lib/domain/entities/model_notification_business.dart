import 'package:flutter/cupertino.dart';

class ModelNotificationBusiness {
  UniqueKey? key;
  int? idBulletin;
  int? read;
  int? type;
  String? business;
  String? bulletin;
  String? url;
  String? bond;
  String? imageBulletin;
  List<Question>? lP = [];

  ModelNotificationBusiness(
      {this.key,
      this.idBulletin,
      this.read,
      this.type,
      this.business,
      this.bulletin,
      this.url,
      this.bond,
      this.imageBulletin,
      this.lP});

  @override
  String toString() {
    return 'ModelNotificationBusiness{key: $key, idBulletin: $idBulletin, read: $read, type: $type, business: $business, bulletin: $bulletin, url: $url, bond: $bond, imageBulletin: $imageBulletin, lP: $lP}';
  }

  factory ModelNotificationBusiness.fromMap(Map<String, dynamic> json) =>
      ModelNotificationBusiness(
        key: json["key"],
        idBulletin: json["idBoletin"],
        read: json["leido"],
        type: json["tipo"],
        business: json["asunto"],
        bulletin: json["boletin"],
        url: json["url"] ?? "",
        bond: json["vinculo"] ?? "",
        imageBulletin: json["imgBoletin"],
        lP: json["lP"] == null
            ? []
            : List<Question>.from(json["lP"].map((x) => Question.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "key": key,
        "idBoletin": idBulletin,
        "leido": read,
        "tipo": type,
        "asunto": business,
        "boletin": bulletin,
        "url": url,
        "vinculo": bond,
        "imgBoletin": imageBulletin,
        "lP": lP == null ? [] : List<dynamic>.from(lP!.map((x) => x.toMap())),
      };
}

class Question {
  int? idQuestion;
  String? question;
  bool? check;

  Question({this.idQuestion, this.question, this.check});

  @override
  String toString() {
    return 'Question{idQuestion: $idQuestion, question: $question, check: $check}';
  }

  factory Question.fromMap(Map<String, dynamic> json) => Question(
        idQuestion: json["id"],
        question: json["pregunta"],
        check: false,
      );

  Map<String, dynamic> toMap() => {
        "id": idQuestion,
        "pregunta": question,
      };
}
