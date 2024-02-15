class ModelPackageRecharge {
  int? idPackage;
  double? cost;
  String? name;
  String? description;
  String? packageType;

  ModelPackageRecharge(
      {this.idPackage,
      this.cost,
      this.name,
      this.description,
      this.packageType});

  factory ModelPackageRecharge.fromMap(Map<String, dynamic> json) =>
      ModelPackageRecharge(
        idPackage: json["packageId"],
        cost: double.parse(json["cost"].toString()),
        name: json["name"],
        description: json["shortDescription"],
      );

  Map<String, dynamic> toMap() => {
        "packageId": idPackage,
        "cost": cost,
        "name": name,
        "shortDescription": description,
      };
}
