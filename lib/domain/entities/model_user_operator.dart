class ModelUserOperator {
  String? phone;
  String? name;

  ModelUserOperator({this.phone, this.name});

  @override
  String toString() {
    return 'UserOperator{phone: $phone, name: $name}';
  }

  factory ModelUserOperator.fromMap(Map<String, dynamic> json) =>
      ModelUserOperator(
        phone: json["t"],
        name: json["n"],
      );

  Map<String, dynamic> toMap() => {
        "t": phone,
        "n": name,
      };
}
