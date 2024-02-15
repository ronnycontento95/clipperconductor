class ModelMessageReferred {
  String? message;

  ModelMessageReferred({this.message});

  @override
  String toString() {
    return 'ModelMessageReferred{message: $message}';
  }

  factory ModelMessageReferred.fromMap(Map<String, dynamic> json) =>
      ModelMessageReferred(
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
    "message": message,
  };
}
