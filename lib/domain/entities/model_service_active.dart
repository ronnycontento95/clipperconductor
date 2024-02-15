class ModelServiceActive {
  int? activeServiceId;
  int? idCharacteristic;
  String? service;

  ModelServiceActive(
      {this.activeServiceId, this.idCharacteristic, this.service});

  @override
  String toString() {
    return 'ServiceActive{activeServiceId: $activeServiceId, idCharacteristic: $idCharacteristic, service: $service}';
  }

  factory ModelServiceActive.fromMap(Map<String, dynamic> json) =>
      ModelServiceActive(
          activeServiceId: json["activeServiceId"],
          idCharacteristic: json["idCharacteristic"],
          service: json["service"]);

  Map<String, dynamic> toMap() => {
        "activeServiceId": activeServiceId,
        "idCharacteristic": idCharacteristic,
        "service": service,
      };
}
