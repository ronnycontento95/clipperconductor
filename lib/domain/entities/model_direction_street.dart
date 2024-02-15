class ModelDirectionStreet {
  String? dP;
  String? dS;

  ModelDirectionStreet({this.dP, this.dS});

  @override
  String toString() {
    return 'DirectionStreet{dP: $dP, sD: $dS}';
  }

  factory ModelDirectionStreet.fromMap(Map<String, dynamic> json) =>
      ModelDirectionStreet(
        dP: json["dP"],
        dS: json["dS"],
      );

  Map<String, dynamic> toMap() => {
        "dP": dP,
        "dS": dS,
      };
}
