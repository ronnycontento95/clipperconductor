class ModelEventuality {
  int? eventualityId;
  String? eventuality;

  ModelEventuality({
    this.eventualityId,
    this.eventuality,
  });

  @override
  String toString() {
    return 'Eventuality{eventualityId: $eventualityId, eventuality: $eventuality}';
  }

  factory ModelEventuality.fromMap(Map<String, dynamic> json) =>
      ModelEventuality(
        eventualityId: json["eventualityId"],
        eventuality: json["eventuality"],
      );

  Map<String, dynamic> toMap() => {
        "eventualityId": eventualityId,
        "eventuality": eventuality,
      };
}
