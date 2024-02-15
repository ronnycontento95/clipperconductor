class ModelConfigurationDriver {
  int? id;
  String? nb;
  String? vd;
  int? h;

  ModelConfigurationDriver({this.id, this.nb, this.vd, this.h});

  @override
  String toString() {
    return 'ConfigurationDriver{id: $id, nb: $nb, vd: $vd, h: $h}';
  }

  factory ModelConfigurationDriver.fromMap(Map<String, dynamic> json) =>
      ModelConfigurationDriver(
        id: json["id"],
        nb: json["nb"],
        vd: json["vd"],
        h: json["h"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "nb": nb,
        "vd": vd,
        "h": h,
      };
}
