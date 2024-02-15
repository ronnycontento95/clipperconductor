class ModelDebts {
  int? idDebts;
  String? description;
  double? debts;

  ModelDebts({this.idDebts, this.description, this.debts});

  @override
  String toString() {
    return 'Debts{idDebts: $idDebts, description: $description, debts: $debts}';
  }

  factory ModelDebts.fromMap(Map<String, dynamic> json) => ModelDebts(
    idDebts: json["idDeuda"],
    description: json["descripccion"],
    debts: double.parse(json["deuda"].toString()),
  );

  Map<String, dynamic> toMap() => {
    "idDeuda": idDebts,
    "descripccion": description,
    "deuda": debts,
  };
}