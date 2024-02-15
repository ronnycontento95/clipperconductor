class ModelHeatMap {
  String? circleId;
  double? latitude;
  double? longitude;
  int? count;

  ModelHeatMap({this.circleId, this.latitude, this.longitude, this.count});

  @override
  String toString() {
    return 'ModelHeatMap{circleId: $circleId, latitude: $latitude, longitude: $longitude, count: $count}';
  }

  factory ModelHeatMap.fromMap(Map<String, dynamic> json) => ModelHeatMap(
        circleId: json["ids"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        count: int.parse(json["count"]),
      );

  Map<String, dynamic> toMap() => {
        "ids": circleId,
        "latitude": latitude,
        "longitude": longitude,
        "count": count,
      };
}
