class ModelCoordinateDestination {
  double? lat;
  double? lng;

  ModelCoordinateDestination({this.lat, this.lng});

  @override
  String toString() {
    return 'CoordinateDestination{lat: $lat, lng: $lng}';
  }

  factory ModelCoordinateDestination.fromMap(Map<String, dynamic> json) =>
      ModelCoordinateDestination(
        lat: json["lat"],
        lng: json["lng"],
      );

  Map<String, dynamic> toMap() => {
        "lat": lat,
        "lng": lng,
      };
}
