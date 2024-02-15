class ModelSuggestionDestination {
  Cost? cost = Cost();
  Distance? distance = Distance();
  TimeApproximate? timeApproximate = TimeApproximate();
  List<Detail>? listDetail = [];
  Toll? toll = Toll();

  ModelSuggestionDestination(
      {this.cost,
      this.distance,
      this.timeApproximate,
      this.listDetail,
      this.toll});

  @override
  String toString() {
    return 'Data{cost: $cost, distance: $distance, timeApproximate: $timeApproximate, listDetail: $listDetail, toll: $toll}';
  }

  factory ModelSuggestionDestination.fromMap(Map<String, dynamic> json) =>
      ModelSuggestionDestination(
        cost: json["costo"] == null ? null : Cost.fromMap(json["costo"]),
        distance: json["distancia"] == null
            ? null
            : Distance.fromMap(json["distancia"]),
        timeApproximate: json["tiempoEstimado"] == null
            ? null
            : TimeApproximate.fromMap(json["tiempoEstimado"]),
        toll: json["peaje"] == null ? null : Toll.fromMap(json["peaje"]),
        listDetail: json["detalle"] == null
            ? []
            : List<Detail>.from(json["detalle"].map((x) => Detail.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "costo": cost!.toMap(),
        "distancia": distance!.toMap(),
        "tiempoEstimado": timeApproximate!.toMap(),
        "peaje": toll!.toMap(),
        "detalle": listDetail == null
            ? []
            : List<dynamic>.from(listDetail!.map((x) => x.toMap())),
      };
}

class Cost {
  String? value;
  String? money;

  Cost({this.value, this.money});

  @override
  String toString() {
    return 'Cost{value: $value, money: $money}';
  }

  factory Cost.fromMap(Map<String, dynamic> json) => Cost(
        value: json["valor"],
        money: json["moneda"],
      );

  Map<String, dynamic> toMap() => {
        "valor": value,
        "moneda": money,
      };
}

class Distance {
  double? value;
  String? unity;

  Distance({this.value, this.unity});

  @override
  String toString() {
    return 'Distance{value: $value, unity: $unity}';
  }

  factory Distance.fromMap(Map<String, dynamic> json) => Distance(
        value: double.parse(json["valor"].toString()),
        unity: json["unidad"],
      );

  Map<String, dynamic> toMap() => {
        "valor": value,
        "unidad": unity,
      };
}

class TimeApproximate {
  String? value;

  TimeApproximate({this.value});

  @override
  String toString() {
    return 'TimeApproximate{value: $value}';
  }

  factory TimeApproximate.fromMap(Map<String, dynamic> json) => TimeApproximate(
        value: json["valor"],
      );

  Map<String, dynamic> toMap() => {
        "valor": value,
      };
}

class Detail {
  String? key;
  String? value;

  Detail({this.key, this.value});

  @override
  String toString() {
    return 'Detail{key: $key, value: $value}';
  }

  factory Detail.fromMap(Map<String, dynamic> json) => Detail(
        key: json["clave"],
        value: json["valor"],
      );

  Map<String, dynamic> toMap() => {
        "clave": key,
        "valor": value,
      };
}

class SuggestionRoute {
  List<ModelSuggestionDestination>? listSuggestion = [];
  List<Routers>? listRoute = [];

  SuggestionRoute({this.listSuggestion, this.listRoute});

  @override
  String toString() {
    return 'SuggestionRoute{listSuggestion: $listSuggestion, listRoute: $listRoute}';
  }

  factory SuggestionRoute.fromMap(Map<String, dynamic> json) => SuggestionRoute(
        listSuggestion: json["s"] == null
            ? []
            : List<ModelSuggestionDestination>.from(
                json["s"].map((x) => ModelSuggestionDestination.fromMap(x))),
        listRoute: json["r"] == null
            ? []
            : List<Routers>.from(json["r"].map((x) => Routers.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "s": listSuggestion == null
            ? []
            : List<dynamic>.from(listSuggestion!.map((x) => x.toMap())),
        "r": listRoute == null
            ? []
            : List<dynamic>.from(listRoute!.map((x) => x.toMap())),
      };
}

class Routers {
  double? latitude;
  double? longitude;

  Routers({this.latitude, this.longitude});

  @override
  String toString() {
    return 'Route{latitude: $latitude, longitude: $longitude}';
  }

  factory Routers.fromMap(Map<String, dynamic> json) => Routers(
        latitude: json["lat"],
        longitude: json["lng"],
      );

  Map<String, dynamic> toMap() => {
        "lat": latitude,
        "lng": longitude,
      };
}

class Toll {
  double? value;
  int? isToll;
  List<Point>? listPoint = [];

  Toll({this.value, this.isToll, this.listPoint});

  @override
  String toString() {
    return 'Toll{value: $value, isToll: $isToll, listPoint: $listPoint}';
  }

  factory Toll.fromMap(Map<String, dynamic> json) => Toll(
        value: json["valor"] == null
            ? 0.0
            : double.parse(json["valor"].toString()),
        isToll: json["isPeaje"],
        listPoint: json["puntos"] == null
            ? []
            : List<Point>.from(json["puntos"].map((x) => Point.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "valor": value,
        "isPeaje": isToll,
        "puntos": listPoint == null
            ? []
            : List<dynamic>.from(listPoint!.map((x) => x.toMap())),
      };
}

class Point {
  double? latitude;
  double? longitude;
  String? name;
  double? price;
  String? money;

  Point({this.latitude, this.longitude, this.name, this.price, this.money});

  @override
  String toString() {
    return 'Point{latitude: $latitude, longitude: $longitude, name: $name, price: $price, money: $money}';
  }

  factory Point.fromMap(Map<String, dynamic> json) => Point(
        latitude: json["lat"],
        longitude: json["lng"],
        name: json["nombre"],
        price: double.parse(json["precio"].toString()),
        money: json["moneda"],
      );

  Map<String, dynamic> toMap() => {
        "lat": latitude,
        "lng": longitude,
        "nombre": name,
        "precio": price,
        "moneda": money,
      };
}
