class ModelPackagePending{
  int? idDebt;
  int? idPackageUser;
  int? isPercentage;
  double? costRequest;
  String? packageType;
  String? description;
  int? idPackageType;
  int? idPackage;
  double? credit;
  double? valuePromotion;
  double? total;

  ModelPackagePending(
      {this.idDebt,
        this.idPackageUser,
        this.isPercentage,
        this.costRequest,
        this.packageType,
        this.description,
        this.idPackageType,
        this.idPackage,
        this.credit,
        this.valuePromotion,
        this.total});

  @override
  String toString() {
    return 'PackagePending{idDebt: $idDebt, idPackageUser: $idPackageUser, isPercentage: $isPercentage, costRequest: $costRequest, packageType: $packageType, description: $description, idPackageType: $idPackageType, idPackage: $idPackage, credit: $credit, valuePromotion: $valuePromotion, total: $total}';
  }

  factory ModelPackagePending.fromMap(Map<String, dynamic> json) => ModelPackagePending(
    idDebt: json["idDeuda"],
    idPackageUser: json["idPaqueteUsuario"],
    isPercentage: json["idPorcentage"],
    costRequest: double.parse(json["costoCarrera"].toString()),
    packageType: json["paqueteTipo"],
    description: json["descripcion"],
    idPackageType: json["idPaqueteTipo"],
    idPackage: json["idPaquete"],
    credit: double.parse(json["credito"].toString()),
    valuePromotion: double.parse(json["valor_promocion"].toString()),
    total: double.parse(json["total"].toString()),
  );

  Map<String, dynamic> toMap() => {
    "idDeuda": idDebt,
    "idPaqueteUsuario": idPackageUser,
    "idPorcentage": isPercentage,
    "costoCarrera": costRequest,
    "paqueteTipo": packageType,
    "descripcion": description,
    "idPaqueteTipo": idPackageType,
    "idPaquete": idPackage,
    "credito": credit,
    "valor_promocion": valuePromotion,
    "total": total,
  };
}