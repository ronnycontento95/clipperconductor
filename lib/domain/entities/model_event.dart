class ModelEvent {
  int? state;
  Data? data = Data();

  ModelEvent({this.state, this.data});

  @override
  String toString() {
    return 'ModelEvent{state: $state}';
  }

  factory ModelEvent.fromMap(Map<String, dynamic> json) => ModelEvent(
        state: json["state"] ??= 0,
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "state": state,
        "data": data!.toMap(),
      };
}

class Data {
  int? requestId;
  double? distance;
  int? typeChat;
  String? message;

  Data({this.requestId, this.distance, this.typeChat, this.message});

  @override
  String toString() {
    return 'Data{requestId: $requestId, distance: $distance, typeChat: $typeChat, message: $message}';
  }

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        requestId: json["requestId"] ??= 0,
        distance: json["distance"] != null
            ? double.parse(json["distance"].toString())
            : 0.0,
        typeChat: json["typeChat"],
        message: json["message"] ??= '',
      );

  Map<String, dynamic> toMap() => {
        "requestId": requestId,
        "distance": distance,
        "typeChat": typeChat,
        "message": message
      };
}
