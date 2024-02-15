class ModelPreRegistration {
  String? name;
  String? lastName;
  String? number;
  String? country;
  String? email;
  String? selectedCountry;
  String? selectedCity;

  ModelPreRegistration({
    this.name,
    this.lastName,
    this.number,
    this.country,
    this.email,
    this.selectedCountry,
    this.selectedCity,
  });

  @override
  String toString() {
    return 'ModelPreRegistration{name: $name, lastName: $lastName, number: $number, country: $country, email: $email, selectedCountry: $selectedCountry, selectedCity: $selectedCity}';
  }

  factory ModelPreRegistration.fromMap(Map<String, dynamic> json) => ModelPreRegistration(
        name: json["name"],
        lastName: json["lastName"],
        number: json["number"],
        country: json["country"],
        email: json["email"],
        selectedCountry: json["selectedCountry"],
        selectedCity: json["selectCity"] ??= '',
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "lastName": lastName,
        "number": number,
        "country": country,
        "email": email,
        "selectedCountry": selectedCountry,
        "selectedCity": selectedCity,
      };
}
