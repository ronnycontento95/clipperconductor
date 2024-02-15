class ModelBalance {
  String? reason;
  double? balance;

  ModelBalance({this.reason, this.balance});

  @override
  String toString() {
    return 'Balance{reason: $reason, balance: $balance}';
  }

  factory ModelBalance.fromMap(Map<String, dynamic> json) => ModelBalance(
        reason: json["razon"],
        balance: double.parse(json["saldo"].toString()),
      );

  Map<String, dynamic> toMap() => {
        "saldo": balance,
        "razon": reason,
      };
}
