class ModelCountry {
  bool? stateSelection = false;
  int? idCountry;
  String? country;
  List<City>? lCity = [];

  ModelCountry({this.stateSelection, this.idCountry, this.country, this.lCity});

  @override
  String toString() {
    return 'Country{stateSelection: $stateSelection, idCountry: $idCountry, country: $country, lCiudades: $lCity}';
  }

  factory ModelCountry.fromMap(Map<String, dynamic> json) => ModelCountry(
        stateSelection: false,
        idCountry: json["idPais"],
        country: json["pais"],
        lCity: json["lCiudades"] == null
            ? []
            : List<City>.from(json["lCiudades"].map((x) => City.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "idPais": idCountry,
        "pais": country,
        "lCiudades": lCity == null
            ? []
            : List<dynamic>.from(lCity!.map((x) => x.toMap())),
      };
}

class City {
  bool? stateSelection = false;
  int? idCity;
  String? city;

  City({
    this.stateSelection,
    this.idCity,
    this.city,
  });

  factory City.fromMap(Map<String, dynamic> json) => City(
        stateSelection: false,
        idCity: json["idCiudad"],
        city: json["ciudad"],
      );

  Map<String, dynamic> toMap() => {
        "idCiudad": idCity,
        "ciudad": city,
      };

  @override
  String toString() {
    return 'City{stateSelection: $stateSelection, idCity: $idCity, city: $city}';
  }
}
