class ModelPaymentHybrid {
  int? errorCode;
  String? balance;
  int? typePaymentMethod;
  Wallet? wallet;
  Cash? cash;
  Card? card;
  Tip? tip;
  List<Discount>? discount = [];

  ModelPaymentHybrid(
      {this.errorCode,
      this.balance,
      this.typePaymentMethod,
      this.wallet,
      this.cash,
      this.card,
      this.tip,
      this.discount});

  @override
  String toString() {
    return 'ModelPaymentHybrid{errorCode: $errorCode, balance: $balance, typePaymentMethod: $typePaymentMethod, wallet: $wallet, cash: $cash, card: $card, tip: $tip, discontData: $discount}';
  }

  factory ModelPaymentHybrid.fromMap(Map<String, dynamic> json) =>
      ModelPaymentHybrid(
        errorCode: json["errorCode"],
        balance: json["balance"] ?? '0.00',
        typePaymentMethod: json["typePaymentMethod"],
        wallet: json["wallet"] == null ? null : Wallet.fromMap(json["wallet"]),
        cash: json["cash"] == null ? null : Cash.fromMap(json["cash"]),
        card: json["card"] == null ? null : Card.fromMap(json["card"]),
        tip: json["tip"] == null ? null : Tip.fromMap(json["tip"]),
        discount: json["discontData"] == null
            ? []
            : List<Discount>.from(
                json["discontData"].map((x) => Discount.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "errorCode": errorCode,
        "balance": balance,
        "typePaymentMethod": typePaymentMethod,
        "wallet":  wallet!.toMap(),
        "cash":  cash!.toMap(),
        "card":  card!.toMap(),
        "tip":  tip!.toMap(),
        "discontData": discount == null
            ? []
            : List<dynamic>.from(discount!.map((x) => x.toMap())),
      };
}

class Wallet {
  String? min;
  String? max;
  String? increment;
  String? name;
  int? typeWallet;

  Wallet({this.min, this.max, this.increment, this.name, this.typeWallet});

  @override
  String toString() {
    return 'Wallet{min: $min, max: $max, increment: $increment, name: $name, typeWallet: $typeWallet}';
  }

  factory Wallet.fromMap(Map<String, dynamic> json) => Wallet(
        min: json["min"],
        max: json["max"],
        increment: json["increment"],
        name: json["name"],
        typeWallet: json["typeWallet"],
      );

  Map<String, dynamic> toMap() => {
        "min": min,
        "max": max,
        "increment": increment,
        "name": name,
        "typeWallet": typeWallet,
      };
}

class Cash {
  String? min;
  String? max;
  String? increment;
  String? name;

  Cash({this.min, this.max, this.increment, this.name});

  @override
  String toString() {
    return 'Cash{min: $min, max: $max, increment: $increment, name: $name}';
  }

  factory Cash.fromMap(Map<String, dynamic> json) => Cash(
        min: json["min"],
        max: json["max"],
        increment: json["increment"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "min": min,
        "max": max,
        "increment": increment,
        "name": name,
      };
}

class Card {
  String? min;
  String? max;
  String? increment;
  String? name;

  Card({this.min, this.max, this.increment, this.name});

  @override
  String toString() {
    return 'Card{min: $min, max: $max, increment: $increment, name: $name}';
  }

  factory Card.fromMap(Map<String, dynamic> json) => Card(
        min: json["min"],
        max: json["max"],
        increment: json["increment"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "min": min,
        "max": max,
        "increment": increment,
        "name": name,
      };
}

class Tip {
  String? max;
  String? tip;
  String? increment;

  Tip({this.max, this.tip, this.increment});

  @override
  String toString() {
    return 'Tip{max: $max, tip: $tip, increment: $increment}';
  }

  factory Tip.fromMap(Map<String, dynamic> json) => Tip(
        max: json["max"],
        tip: json["tip"],
        increment: json["increment"],
      );

  Map<String, dynamic> toMap() => {
        "max": max,
        "increment": increment,
        "tip": tip,
      };
}

class Discount {
  String? amount;
  int? typeDiscount;
  String? discountFixed;
  int? discountPercentage;
  int? typeDiscountAffectsTo;

  Discount(
      {this.amount,
      this.typeDiscount,
      this.discountFixed,
      this.discountPercentage,
      this.typeDiscountAffectsTo});

  @override
  String toString() {
    return 'Discount{amount: $amount, typeDiscount: $typeDiscount, discountFixed: $discountFixed, discountPercentage: $discountPercentage, typeDiscountAffectsTo: $typeDiscountAffectsTo}';
  }

  factory Discount.fromMap(Map<String, dynamic> json) => Discount(
        amount: json["amount"],
        typeDiscount: json["typeDiscount"],
        discountFixed: json["discountFixed"],
        discountPercentage: json["discountPercentage"],
        typeDiscountAffectsTo: json["typeDiscountAffectsTo"],
      );

  Map<String, dynamic> toMap() => {
        "amount": amount,
        "typeDiscount": typeDiscount,
        "discountFixed": discountFixed,
        "discountPercentage": discountPercentage,
        "typeDiscountAffectsTo": typeDiscountAffectsTo,
      };
}
