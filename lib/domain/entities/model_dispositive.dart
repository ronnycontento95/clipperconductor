class ModelDispositive {
  String? imei;
  String? model;
  String? brand;
  String? version;
  String? versionSystem;

  ModelDispositive({
    this.imei,
    this.model,
    this.brand,
    this.version,
    this.versionSystem,
  });

  @override
  String toString() {
    return 'Dispositive{imei: $imei, model: $model, brand: $brand, version: $version, versionSystem: $versionSystem}';
  }

  factory ModelDispositive.fromMap(Map<String, dynamic> json) => ModelDispositive(
    imei: json["imei"],
    model: json["model"],
    brand: json["brand"],
    version: json["version"],
    versionSystem: json["versionSystem"],
  );

  Map<String, dynamic> toMap() => {
    "imei": imei,
    "model": model,
    "brand": brand,
    "version": version,
    "versionSystem": versionSystem,
  };
}