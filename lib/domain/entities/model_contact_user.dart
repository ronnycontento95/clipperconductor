class ModelContactUser {
  int? idContactUser;
  String? name;
  String? phone;
  int? state;

  ModelContactUser({this.idContactUser, this.name, this.phone, this.state});

  @override
  String toString() {
    return 'ContactUser{idContactUser: $idContactUser, name: $name, phone: $phone, state: $state}';
  }

  factory ModelContactUser.fromMap(Map<String, dynamic> json) => ModelContactUser(
    idContactUser: json["idContactosUsuario"],
    name: json["nombre"],
    phone: json["numero"],
    state: json["habilitado"],
  );

  Map<String, dynamic> toMap() => {
    "idContactosUsuario": idContactUser,
    "nombre": name,
    "numero": phone,
    "habilitado": state,
  };
}