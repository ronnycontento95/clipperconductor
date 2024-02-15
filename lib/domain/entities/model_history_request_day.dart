class ModelHistoryRequestDay {
  int? idHistory;
  String? principalStreet;
  String? secondaryStreet;
  String? neighborhood;
  String? referred;
  String? hour;
  double? discount;
  int? typePay;
  int? dayRegister;
  int? state;
  double? payment;
  String? order;
  double? price;

  ModelHistoryRequestDay(
      {this.idHistory,
      this.principalStreet,
      this.secondaryStreet,
      this.neighborhood,
      this.referred,
      this.hour,
      this.discount,
      this.typePay,
      this.dayRegister,
      this.state,
      this.payment,
      this.order,
      this.price});

  @override
  String toString() {
    return 'HistoryRequestDay{idHistory: $idHistory, principalStreet: $principalStreet, secondaryStreet: $secondaryStreet, neighborhood: $neighborhood, referred: $referred, hour: $hour, discount: $discount, typePay: $typePay, dayRegister: $dayRegister, state: $state, payment: $payment, order: $order, price: $price}';
  }

  factory ModelHistoryRequestDay.fromMap(Map<String, dynamic> json) =>
      ModelHistoryRequestDay(
        idHistory: json["id"],
        principalStreet: json["cP"],
        secondaryStreet: json["cS"],
        neighborhood: json["b"],
        referred: json["r"],
        hour: json["h"],
        discount: double.parse(json["des"].toString()),
        typePay: json["t"],
        dayRegister: json["d"],
        state: json["e"],
        payment:
            json["vc"] != null ? double.parse(json["vc"].toString()) : 0.00,
        order: json["ped"] ??= '',
        price:
            json["pres"] != null ? double.parse(json["pres"].toString()) : 0.00,
      );

  Map<String, dynamic> toMap() => {
        "id": idHistory,
        "cP": principalStreet,
        "cS": secondaryStreet,
        "b": neighborhood,
        "des": discount,
        "r": referred,
        "h": hour,
        "t": typePay,
        "d": dayRegister,
        "e": state,
        "vc": payment,
        "ped": order,
        "pres": price,
      };
}
