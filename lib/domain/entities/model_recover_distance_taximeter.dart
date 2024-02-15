import 'dart:convert';

class ModelRecoverDistanceTaximeter {
  double? distance;
  double? latitude;
  double? longitude;
  String? waitTime;
  double? valueRecover;

  ModelRecoverDistanceTaximeter(
      {this.distance,
      this.latitude,
      this.longitude,
      this.waitTime,
      this.valueRecover});

  @override
  String toString() {
    return 'ModelRecoverDistanceTaximeter{distance: $distance, latitude: $latitude, longitude: $longitude, waitTime: $waitTime, valueRecover: $valueRecover}';
  }

  factory ModelRecoverDistanceTaximeter.fromJson(String str) =>
      ModelRecoverDistanceTaximeter.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ModelRecoverDistanceTaximeter.fromMap(Map<String, dynamic> json) =>
      ModelRecoverDistanceTaximeter(
          distance: double.parse(json["distance"].toString()),
          latitude: double.parse(json["latitude"].toString()),
          longitude: double.parse(json["longitude"].toString()),
          waitTime: json["waitTime"],
          valueRecover: double.parse(json["value"].toString()));

  Map<String, dynamic> toMap() => {
        "distance": distance,
        "latitude": latitude,
        "longitude": longitude,
        "waitTime": waitTime,
        "value": valueRecover,
      };
}
