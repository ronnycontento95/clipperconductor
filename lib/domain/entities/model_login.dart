class ModelLogIn {
  String? user;
  String? password;
  String? deviceId;
  int? applicationId;
  String? version;

  ModelLogIn(
      {this.user,
      this.password,
      this.deviceId,
      this.applicationId,
      this.version});

  @override
  String toString() {
    return 'ModelLogIn{user: $user, password: $password, deviceId: $deviceId, applicationId: $applicationId, version: $version}';
  }

  factory ModelLogIn.fromMap(Map<String, dynamic> json) => ModelLogIn(
        user: json["usuario"],
        password: json["contrasenia"],
        deviceId: json["deviceId"],
        applicationId: json["applicationId"],
        version: json["version"],
      );

  Map<String, dynamic> toMap() => {
        "usuario": user,
        "contrasenia": password,
        "deviceId": deviceId,
        "applicationId": applicationId,
        "version": version,
      };
}
