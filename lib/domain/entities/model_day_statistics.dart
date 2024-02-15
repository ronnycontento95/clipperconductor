class ModelDayStatistics {
  double? distance;
  String? time;

  ModelDayStatistics({this.distance, this.time});

  @override
  String toString() {
    return 'ModelDayStatistics{distance: $distance, time: $time}';
  }

  factory ModelDayStatistics.fromMap(Map<String, dynamic> json) =>
      ModelDayStatistics(
        distance: double.parse(json["distance"].toString()),
        time: json["time"],
      );

  Map<String, dynamic> toMap() => {
        "distance": distance,
        "time": time,
      };
}
