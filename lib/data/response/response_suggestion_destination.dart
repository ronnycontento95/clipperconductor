import 'dart:convert';


import '../../domain/entities/model_suggestion_destination.dart';
import 'response_api.dart';

class ResponseSuggestionDestination extends ResponseApi {
  List<ModelSuggestionDestination>? listSuggestion = [];
  List<Routers>? listRoute = [];
  List<SuggestionRoute>? listSuggestionRoute = [];

  ResponseSuggestionDestination(
      {this.listSuggestion, this.listRoute, this.listSuggestionRoute});

  factory ResponseSuggestionDestination.fromJson(String str) =>
      ResponseSuggestionDestination.fromMap(json.decode(str));

  @override
  String toJson() => json.encode(toMap());

  ResponseSuggestionDestination.fromMap(Map<String, dynamic> json)
      : listSuggestion = (json["s"] == null
            ? []
            : List<ModelSuggestionDestination>.from(
                json["s"].map((x) => ModelSuggestionDestination.fromMap(x)))),
        listRoute = (json["r"] == null
            ? []
            : List<Routers>.from(json["r"].map((x) => Routers.fromMap(x)))),
        listSuggestionRoute = (json["rutas"] == null
            ? []
            : List<SuggestionRoute>.from(
                json["rutas"].map((x) => SuggestionRoute.fromMap(x)))),
        super.fromMap(json);

  @override
  Map<String, dynamic> toMap() => {
        "s": listSuggestion == null
            ? []
            : List<dynamic>.from(listSuggestion!.map((x) => x.toMap())),
        "r": listRoute == null
            ? []
            : List<dynamic>.from(listRoute!.map((x) => x.toMap())),
        "rutas": listSuggestionRoute == null
            ? []
            : List<dynamic>.from(listSuggestionRoute!.map((x) => x.toMap())),
      };
}
