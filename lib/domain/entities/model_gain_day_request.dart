class ModelGainDayRequest {
  double? mont;
  String? date;
  int? numRequest;

  ModelGainDayRequest({this.mont, this.date, this.numRequest});

  @override
  String toString() {
    return 'GainDay{mont: $mont, date: $date, numRequest: $numRequest}';
  }

  factory ModelGainDayRequest.fromMap(Map<String, dynamic> json) =>
      ModelGainDayRequest(
        mont: double.parse(json["monto"].toString()),
        date: json["fechaActual"],
        numRequest: json["numSolicitude"],
      );

  Map<String, dynamic> toMap() => {
        "monto": mont,
        "fechaActual": date,
        "numSolicitude": numRequest,
      };
}
