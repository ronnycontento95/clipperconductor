class ModelCoordinateDirection {
  double? latitude;
  double? longitude;

  ModelCoordinateDirection({this.latitude, this.longitude});

  @override
  String toString() {
    return 'ModelCoordinateDirection{latitude: $latitude, longitude: $longitude}';
  }

  factory ModelCoordinateDirection.fromMap(Map<String, dynamic> json) =>
      ModelCoordinateDirection(
        latitude: json["lt"] ??= 0.0,
        longitude: json["lg"] ??= 0.0,
      );

  Map<String, dynamic> toMap() => {
        "lt": latitude,
        "lg": longitude,
      };
}
