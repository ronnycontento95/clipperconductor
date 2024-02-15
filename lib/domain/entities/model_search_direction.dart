class ModelSearchDirection {
  String? placeId;
  String? description;
  StructuredFormatting? structuredFormatting;

  ModelSearchDirection(
      {this.placeId, this.description, this.structuredFormatting});

  @override
  String toString() {
    return 'ModelSearchDirection{placeId: $placeId, description: $description}';
  }

  factory ModelSearchDirection.fromMap(Map<String, dynamic> json) =>
      ModelSearchDirection(
        placeId: json["place_id"],
        description: json["description"],
        structuredFormatting: json["structured_formatting"] == null
            ? null
            : StructuredFormatting.fromMap(json["structured_formatting"]),
      );

  Map<String, dynamic> toMap() => {
        "place_id": placeId,
        "description": description,
        "structured_formatting": structuredFormatting!.toMap(),
      };
}

class StructuredFormatting {
  String? mainText;
  String? secondaryText;

  StructuredFormatting({this.mainText, this.secondaryText});

  @override
  String toString() {
    return 'StructuredFormatting{mainText: $mainText, secondaryText: $secondaryText}';
  }

  factory StructuredFormatting.fromMap(Map<String, dynamic> json) =>
      StructuredFormatting(
        mainText: json["main_text"],
        secondaryText: json["secondary_text"],
      );

  Map<String, dynamic> toMap() => {
        "main_text": mainText,
        "secondary_text": secondaryText,
      };
}
