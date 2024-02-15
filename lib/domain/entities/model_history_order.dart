 class ModelHistoryOrder{
  int? idOrder;
  String? order;
  double? price;
  int? typePay;
  int? state;
  String? principalStreet;
  String? secondaryStreet;
  String? neighborhood;
  String? referred;
  int? dayRegister;
  String? hour;

  ModelHistoryOrder(
      {this.idOrder,
        this.order,
        this.price,
        this.typePay,
        this.state,
        this.principalStreet,
        this.secondaryStreet,
        this.neighborhood,
        this.referred,
        this.dayRegister,
        this.hour});

  @override
  String toString() {
    return 'HistoryOrder{idOrder: $idOrder, order: $order, price: $price, typePay: $typePay, state: $state, principalStreet: $principalStreet, secondaryStreet: $secondaryStreet, neighborhood: $neighborhood, referred: $referred, dayRegister: $dayRegister, hour: $hour}';
  }

  factory ModelHistoryOrder.fromMap(Map<String, dynamic> json) => ModelHistoryOrder(
    idOrder: json["id"],
    order: json["ped"],
    principalStreet: json["cP"],
    secondaryStreet: json["cS"],
    neighborhood: json["b"],
    referred: json["r"],
    hour: json["h"],
    price: double.parse(json["pres"].toString()),
    typePay: json["t"],
    dayRegister: json["d"],
    state: json["e"] ??= 0,
  );

  Map<String, dynamic> toMap() => {
    "id": idOrder,
    "ped": order,
    "cP": principalStreet,
    "cS": secondaryStreet,
    "b": neighborhood,
    "pres": price,
    "r": referred,
    "h": hour,
    "t": typePay,
    "d": dayRegister,
    "e": state,
  };
}