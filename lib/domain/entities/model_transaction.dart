import '../../ui/util/global_label.dart';

class ModelTransaction {
  double? balance;
  String? dateRegister;
  int? iE;
  String? state;
  int? iT;
  String? type;
  int? iR;
  String? reason;

  ModelTransaction(
      {this.balance,
        this.dateRegister,
        this.iE,
        this.state,
        this.iT,
        this.type,
        this.iR,
        this.reason});

  factory ModelTransaction.fromMap(Map<String, dynamic> json) => ModelTransaction(
    balance: double.parse(json["saldo"].toString()),
    dateRegister: json["fecha_registro"],
    iE: json["iE"],
    state: json["estado"],
    iT: json["iT"],
    type: json["tipo"],
    iR: json["iR"],
    reason: json["razon"] ?? GlobalLabel.textStranger,
  );

  Map<String, dynamic> toMap() => {
    "saldo": balance,
    "fecha_registro": dateRegister,
    "iE": iE,
    "estado": state,
    "iT": iT,
    "tipo": type,
    "iR": iR,
    "razon": reason,
  };
}