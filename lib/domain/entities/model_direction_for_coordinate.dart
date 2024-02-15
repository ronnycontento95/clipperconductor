class ModelDirectionForCoordinate{
  int? en;
  String? nC;
  String? nB;
  int? idC;
  int? idB;
  String? st1;
  String? st2;

  ModelDirectionForCoordinate(
      {this.en, this.nC, this.nB, this.idC, this.idB, this.st1, this.st2});

  @override
  String toString() {
    return 'DirectionForCoordinate{en: $en, nC: $nC, nB: $nB, idC: $idC, idB: $idB, st1: $st1, st2: $st2}';
  }

  factory ModelDirectionForCoordinate.fromMap(Map<String, dynamic> json) =>
      ModelDirectionForCoordinate(
        en: json["en"],
        nC: json["nC"],
        nB: json["nB"],
        idC: json["idC"],
        idB: json["idB"],
        st1: json["st1"],
        st2: json["st2"],
      );

  Map<String, dynamic> toMap() => {
    "en": en,
    "nC": nC,
    "nB": nB,
    "idC": idC,
    "idB": idB,
    "st1": st1,
    "st2": st2,
  };
}