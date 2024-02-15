class ModelUser {
  String? user;
  String? password;
  String? name;
  String? lastName;
  String? email;
  String? phone;
  String? dni;
  String? business;
  String? vehiclePlate;
  String? city;
  String? regMunVehicle;
  String? vehicleBrand;
  String? vehicleModel;
  String? imageDriver;
  int? idUser;
  int? idVehicle;
  int? idEquipment;
  int? typeVehicle;
  int? idCity;
  int? idCountry;
  String? codeCountry;
  int? yearVehicle;
  int? idBusiness;
  int? unitVehicle;
  bool? loggedIn;

  ModelUser(
      {this.user,
      this.password,
      this.name,
      this.lastName,
      this.email,
      this.phone,
      this.dni,
      this.business,
      this.vehiclePlate,
      this.city,
      this.codeCountry,
      this.regMunVehicle,
      this.vehicleBrand,
      this.vehicleModel,
      this.imageDriver,
      this.idUser,
      this.idVehicle,
      this.idEquipment,
      this.typeVehicle,
      this.idCity,
      this.idCountry,
      this.yearVehicle,
      this.idBusiness,
      this.unitVehicle,
      this.loggedIn});

  @override
  String toString() {
    return 'User{user: $user, password: $password, name: $name, lastName: $lastName, email: $email, phone: $phone, dni: $dni, business: $business, vehiclePlate: $vehiclePlate, city: $city, regMunVehicle: $regMunVehicle, vehicleBrand: $vehicleBrand, vehicleModel: $vehicleModel, imageDriver: $imageDriver, idUser: $idUser, idVehicle: $idVehicle, idEquipment: $idEquipment, typeVehicle: $typeVehicle, idCity: $idCity, idCountry: $idCountry, codeCountry: $codeCountry, yearVehicle: $yearVehicle, idBusiness: $idBusiness, unitVehicle: $unitVehicle, loggedIn: $loggedIn}';
  }

  factory ModelUser.fromMap(Map<String, dynamic> json) => ModelUser(
      user: json["usuario"],
      password: json["contrasenia"],
      name: json["nombres"],
      lastName: json["apellidos"],
      email: json["correo"],
      phone: json["celular"],
      dni: json["cedula"],
      business: json["empresa"],
      vehiclePlate: json["placaVehiculo"],
      city: json["ciudad"] ?? '',
      regMunVehicle: json["regMunVehiculo"],
      vehicleBrand: json["marcaVehiculo"],
      vehicleModel: json["modeloVehiculo"],
      imageDriver: json["imagenConductor"],
      idUser: json["idUsuario"],
      idVehicle: json["idVehiculo"],
      idEquipment: json["idEquipo"],
      typeVehicle: json["tipoVehiculo"],
      idCity: json["idCiudad"],
      idCountry: json["idPais"],
      codeCountry: json["codigoPais"],
      yearVehicle: json["anoVehiculo"],
      idBusiness: json["idEmpresa"],
      unitVehicle: json["unidadVehiculo"],
      loggedIn: json["logueado"]);

  Map<String, dynamic> toMap() => {
        "usuario": user,
        "contrasenia": password,
        "nombres": name,
        "apellidos": lastName,
        "correo": email,
        "celular": phone,
        "cedula": dni,
        "empresa": business,
        "placaVehiculo": vehiclePlate,
        "ciudad": city,
        "regMunVehiculo": regMunVehicle,
        "marcaVehiculo": vehicleBrand,
        "modeloVehiculo": vehicleModel,
        "imagenConductor": imageDriver,
        "idUsuario": idUser,
        "idVehiculo": idVehicle,
        "idEquipo": idEquipment,
        "tipoVehiculo": typeVehicle,
        "idCiudad": idCity,
        "idPais": idCountry,
        "codigoPais": codeCountry,
        "anoVehiculo": yearVehicle,
        "idEmpresa": idBusiness,
        "unidadVehiculo": unitVehicle,
        "logueado": loggedIn,
      };
}
