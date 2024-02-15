class ModelTaximeter {
  int? editPriceC;
  int? type;
  int? b;
  int? visibility;
  double? vV;
  double? kmD;
  double? kmN;
  double? minD;
  double? minN;
  double? aD;
  double? aN;
  double? cD;
  double? cN;
  String? hD;
  String? hN;
  double? approximate;
  int? itv;
  double? cvD;
  double? cvN;
  int? kvD;
  int? kvN;

  ModelTaximeter(
      {this.editPriceC,
      this.type,
      this.b,
      this.visibility,
      this.vV,
      this.kmD,
      this.kmN,
      this.minD,
      this.minN,
      this.aD,
      this.aN,
      this.cD,
      this.cN,
      this.hD,
      this.hN,
      this.approximate,
      this.itv,
      this.cvD,
      this.cvN,
      this.kvD,
      this.kvN});

  @override
  String toString() {
    return 'DataTaximeter{editPriceC: $editPriceC, type: $type, b: $b, visible: $visibility, vV: $vV, kmD: $kmD, kmN: $kmN, minD: $minD, minN: $minN, aD: $aD, aN: $aN, cD: $cD, cN: $cN, hD: $hD, hN: $hN, approximate: $approximate, itv: $itv, cvD: $cvD, cvN: $cvN, kvD: $kvD, kvN: $kvN}';
  }

  factory ModelTaximeter.fromMap(Map<String, dynamic> json) => ModelTaximeter(
        editPriceC: json["editarCostoC"],
        type: json["tipo"],
        b: json["b"],
        visibility: json["visible"],
        vV: double.parse(json["vV"].toString()),
        kmD: double.parse(json["kmD"].toString()),
        kmN: double.parse(json["kmN"].toString()),
        minD: double.parse(json["minD"].toString()),
        minN: double.parse(json["minN"].toString()),
        aD: double.parse(json["aD"].toString()),
        aN: double.parse(json["aN"].toString()),
        cD: double.parse(json["cD"].toString()),
        cN: double.parse(json["cN"].toString()),
        approximate: double.parse(json["aproximado"].toString()),
        hD: json["hD"],
        hN: json["hN"],
        itv: json["itv"] ??= 0,
        cvD: json["cvD"] != null ? double.parse(json["cvD"].toString()) : 0.0,
        cvN: json["cvN"] != null ? double.parse(json["cvN"].toString()) : 0.0,
        kvD: json["kvD"] ??= 0,
        kvN: json["kvN"] ??= 0,
      );

  Map<String, dynamic> toMap() => {
        "editarCostoC": editPriceC,
        "tipo": type,
        "b": b,
        "visible": visibility,
        "vV": vV,
        "kmD": kmD,
        "kmN": kmN,
        "minD": minD,
        "minN": minN,
        "aD": aD,
        "aN": aN,
        "cD": cD,
        "hD": hD,
        "hN": hN,
        "aproximado": approximate,
        "itv": itv,
        "cvD": cvD,
        "cvN": cvN,
        "kvD": kvD,
        "kvN": kvN,
      };
}
