class ModelPointTracing {
  double? lat;
  double? lng;

  ModelPointTracing({this.lat, this.lng});

  @override
  String toString() {
    return 'ModelPointTracing{lat: $lat, lng: $lng}';
  }

  factory ModelPointTracing.fromMap(Map<String, dynamic> json) =>
      ModelPointTracing(
        lat: json["lat"],
        lng: double.parse(json["lng"].toString()),
      );

  Map<String, dynamic> toMap() => {
        "lat": lat,
        "lng": lng,
      };
}
