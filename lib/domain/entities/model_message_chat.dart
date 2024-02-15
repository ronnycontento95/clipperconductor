class ModelMessageChat {
  String? message;

  ModelMessageChat({this.message});

  @override
  String toString() {
    return 'ModelMessageChat{message: $message}';
  }

  factory ModelMessageChat.fromMap(Map<String, dynamic> json) =>
      ModelMessageChat(
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
        "message": message,
      };
}
