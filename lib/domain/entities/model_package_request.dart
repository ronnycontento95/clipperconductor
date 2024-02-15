class ModelPackageRequest {
  int? idPackageType;
  String? packageType;
  String? description;
  List<Package>? lP = [];

  ModelPackageRequest(
      {this.idPackageType, this.packageType, this.description, this.lP});

  @override
  String toString() {
    return 'PackageRequest{idPackageType: $idPackageType, packageType: $packageType, description: $description, lP: $lP}';
  }

  factory ModelPackageRequest.fromMap(Map<String, dynamic> json) =>
      ModelPackageRequest(
        idPackageType: json["idPaqueteTipo"],
        packageType: json["paqueteTipo"],
        description: json["descripcion"],
        lP: json["lP"] == null
            ? []
            : List<Package>.from(json["lP"].map((x) => Package.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "idPaqueteTipo": idPackageType,
        "paqueteTipo": packageType,
        "descripcion": description,
        "lP": lP == null ? [] : List<dynamic>.from(lP!.map((x) => x.toMap())),
      };
}

class Package {
  double? credit;
  double? promotional;
  double? total;
  double? priceTravel;
  String? expirationPromotion;
  int? relationPercentage;
  double? referenceP;

  Package(
      {this.credit,
      this.promotional,
      this.total,
      this.priceTravel,
      this.expirationPromotion,
      this.relationPercentage,
      this.referenceP});

  @override
  String toString() {
    return 'Package{credit: $credit, promotional: $promotional, total: $total, priceTravel: $priceTravel, expirationPromotion: $expirationPromotion, relationPercentage: $relationPercentage, referenceP: $referenceP}';
  }

  factory Package.fromMap(Map<String, dynamic> json) => Package(
        credit: double.parse(json["credito"].toString()),
        promotional: double.parse(json["creditoPromocion"].toString()),
        total: double.parse(json["creditoTotal"].toString()),
        priceTravel: double.parse(json["referenciaP"].toString()),
        expirationPromotion: json["caducidadPromocion"],
        relationPercentage: json["relacionPorcentage"],
      );

  Map<String, dynamic> toMap() => {
        "credito": credit,
        "creditoPromocion": promotional,
        "creditoTotal": total,
        "referenciaP": priceTravel,
        "caducidadPromocion": expirationPromotion,
        "relacionPorcentage": relationPercentage,
      };
}
