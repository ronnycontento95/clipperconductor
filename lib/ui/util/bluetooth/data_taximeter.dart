class DataTaximeter {
  String? mode;
  int? lastReceivedTime;
  int? dateTime;
  String? meterSerial = '';
  int? passengerOnBoardTime;
  int? passengerExitTime;
  int? passengerTravelDistance;
  int? passengerTravelTime;
  int? passengerWaitTime;
  int? totalFare;
  int? carSpeed;
  int? sos;
  int? vipSurchargeSelection;

  DataTaximeter(
      {this.mode,
      this.lastReceivedTime,
      this.dateTime,
      this.meterSerial,
      this.passengerOnBoardTime,
      this.passengerExitTime,
      this.passengerTravelDistance,
      this.passengerTravelTime,
      this.passengerWaitTime,
      this.totalFare,
      this.carSpeed,
      this.sos,
      this.vipSurchargeSelection});

  @override
  String toString() {
    return 'AbstractDataVo{mode: $mode, lastReceivedTime: $lastReceivedTime, dateTime: $dateTime, meterSerial: $meterSerial, passengerOnBoardTime: $passengerOnBoardTime, passengerExitTime: $passengerExitTime, passengerTravelDistance: $passengerTravelDistance, passengerTravelTime: $passengerTravelTime, passengerWaitTime: $passengerWaitTime, totalFare: $totalFare, carSpeed: $carSpeed, sos: $sos, vipSurchargeSelection: $vipSurchargeSelection}';
  }

  factory DataTaximeter.fromMap(Map<String, dynamic> json) => DataTaximeter(
        mode: json["mode"],
        lastReceivedTime: json["lastReceivedTime"],
        dateTime: json["dateTime"],
        meterSerial: json["meterSerial"],
        passengerOnBoardTime: json["passengerOnBoardTime"],
        passengerExitTime: json["passengerExitTime"],
        passengerTravelDistance: json["passengerTravelDistance"],
        passengerTravelTime: json["passengerTravelTime"],
        passengerWaitTime: json["passengerWaitTime"],
        totalFare: json["totalFare"],
        carSpeed: json["carSpeed"] ?? 0,
        sos: json["sos"],
        vipSurchargeSelection: json["vipSurchargeSelection"],
      );

  Map<String, dynamic> toMap() => {
        "mode": mode,
        "lastReceivedTime": lastReceivedTime,
        "dateTime": dateTime,
        "meterSerial": meterSerial,
        "passengerOnBoardTime": passengerOnBoardTime,
        "passengerExitTime": passengerExitTime,
        "passengerTravelDistance": passengerTravelDistance,
        "passengerTravelTime": passengerTravelTime,
        "passengerWaitTime": passengerWaitTime,
        "totalFare": totalFare,
        "carSpeed": carSpeed,
        "sos": sos,
        "vipSurchargeSelection": vipSurchargeSelection,
      };
}
