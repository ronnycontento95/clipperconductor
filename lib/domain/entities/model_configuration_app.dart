class ModelConfigurationApp {
  bool? routeMap;
  bool? routeGoogle;
  bool? routeWaze;
  bool? speakChat;
  bool? externalTaximeter;
  bool? heatMap;

  ModelConfigurationApp(
      {this.routeMap,
      this.routeWaze,
      this.routeGoogle,
      this.speakChat,
      this.externalTaximeter,
      this.heatMap});

  factory ModelConfigurationApp.fromMap(Map<String, dynamic> json) =>
      ModelConfigurationApp(
        routeMap: json['routeMap'],
        routeWaze: json['routeWaze'],
        routeGoogle: json['routeGoogle'],
        speakChat: json['speakChat'] ?? false,
        externalTaximeter: json['externalTaximeter'] ?? false,
        heatMap: json['heatMap'] ?? false,
      );

  Map<String, dynamic> toMap() => {
        "routeMap": routeMap,
        "routeGoogle": routeGoogle,
        "routeWaze": routeWaze,
        "speakChat": speakChat,
        "externalTaximeter": externalTaximeter,
        "heatMap": heatMap,
      };
}
