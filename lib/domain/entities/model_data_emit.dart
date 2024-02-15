class ModelDataEmit {
  String? en;
  String? m;
  int? state;
  int? idConfigurationPenalty;
  int? idRequest;
  String? title;
  String? message;
  String? time;
  String? username;
  String? name;
  String? messageChat;
  bool? stateButton;
  bool? audio;
  bool? a;
  int? u;
  String? n;


  ModelDataEmit(
      {this.state,
        this.title,
        this.messageChat,
        this.time,
        this.stateButton,
        this.idConfigurationPenalty,
        this.username,
        this.name,
        this.idRequest,
        this.message,
        this.en,
        this.m,
        this.audio,
        this.a,
        this.u,
        this.n
      });

  factory ModelDataEmit.fromMap(Map<String, dynamic> json) => ModelDataEmit(
    state: json["estado"] ??= 0,
    title: json["titulo"],
    message: json["mensaje"] ??= '',
    time: json["tiempo"],
    stateButton: json["estadoBoton"],
    idConfigurationPenalty: json["idConfiguracionPenalizacion"],
    username: json["username"],
    name: json["nombres"],
    idRequest: json["idSolicitud"],
    messageChat: json["message"] ??= '',
    en: json["m"],
    m: json["m"],
    audio: json["audio"] ??= false,
    a: json["a"],
    u: json["u"],
    n: json["n"] ??= 'Call Center',

  );

  Map<String, dynamic> toMap() => {
    "estado": state,
    "titulo": title,
    "mensaje": message,
    "tiempo": time,
    "estadoBoton": stateButton,
    "idConfiguracionPenalizacion": idConfigurationPenalty,
    "username": username,
    "nombres": name,
    "idSolicitud": idRequest,
    "message": messageChat,
    "en": en,
    "m": m,
    "audio": audio,
    "a": a,
    "u": u,
    "n": n,
  };
}
