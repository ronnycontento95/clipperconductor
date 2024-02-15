class ModelTotalQualification {
  String? quantity;
  String? score;

  ModelTotalQualification({this.quantity, this.score});

  @override
  String toString() {
    return 'ModelTotalQualification{quantity: $quantity, score: $score}';
  }

  factory ModelTotalQualification.fromMap(Map<String, dynamic> json) =>
      ModelTotalQualification(
        quantity: json["quantity"],
        score: json["score"],
      );

  Map<String, dynamic> toMap() => {
        "quantity": quantity,
        "score": score,
      };
}
