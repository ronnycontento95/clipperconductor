class ModelRequest {
  int? username;
  int? vehicleId;
  int? statusDriver;
  int? requestType;
  RequestData? requestData;

  ModelRequest({
    this.username,
    this.vehicleId,
    this.statusDriver,
    this.requestType,
    this.requestData,
  });

  @override
  String toString() {
    return 'ModelRequest{username: $username, vehicleId: $vehicleId, statusDriver: $statusDriver, requestType: $requestType, requestData: $requestData}';
  }

  factory ModelRequest.fromMap(Map<String, dynamic> json) => ModelRequest(
        username: json["username"],
        vehicleId: json["vehicleId"],
        statusDriver: json["statusDriver"],
        requestType: json["requestType"],
        requestData: json["requestDetails"] == null
            ? null
            : RequestData.fromMap(json["requestDetails"]),
      );

  Map<String, dynamic> toMap() => {
        "username": username,
        "vehicleId": vehicleId,
        "statusDriver": statusDriver,
        "requestType": requestType,
        "requestDetails": requestData!.toMap(),
      };
}

class Users {
  String? names;
  String? phone;
  String? gender;
  double? rating;
  int? totalRequest;
  String? imageUser;
  int? clientId;
  List<Direction>? addresses = [];

  Users({
    this.names,
    this.phone,
    this.gender,
    this.rating,
    this.totalRequest,
    this.imageUser,
    this.clientId,
    this.addresses,
  });

  @override
  String toString() {
    return 'Users{names: $names, phone: $phone, gender: $gender, rating: $rating, totalRequest: $totalRequest, imageUser: $imageUser, clientId: $clientId, addresses: $addresses}';
  }

  factory Users.fromMap(Map<String, dynamic> json) => Users(
        names: json["names"],
        phone: json["phone"],
        gender: json["gender"],
        rating: json["rating"] != null
            ? double.parse(json["rating"].toString())
            : 5,
        totalRequest: json["totalRequest"] ??= 0,
        imageUser: json["userImage"],
        clientId: json["clientId"],
        addresses: json["addresses"] == null
            ? []
            : List<Direction>.from(
                json["addresses"].map((x) => Direction.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "names": names,
        "phone": phone,
        "gender": gender,
        "rating": rating,
        "totalRequest": totalRequest,
        "userImage": imageUser,
        "clientId": clientId,
        "addresses": addresses == null
            ? []
            : List<dynamic>.from(addresses!.map((x) => x.toMap())),
      };
}

class Direction {
  String? label;
  String? description;

  Direction({
    this.label,
    this.description,
  });

  @override
  String toString() {
    return 'Direction{label: $label, description: $description}';
  }

  factory Direction.fromMap(Map<String, dynamic> json) => Direction(
        label: json["label"],
        description: json["description"],
      );

  Map<String, dynamic> toMap() => {
        "label": label,
        "description": description,
      };
}

class RequestData {
  int? requestId;
  String? requestIdCall;
  int? activeServiceId;
  int? paymentType;
  double? longitude;
  double? latitude;
  double? distance;
  int? times;
  List<double>? prices = [];
  double? latitudeOnBoard;
  double? longitudeOnBoard;
  String? hour;
  int? timePost;
  int? advice;
  String? nameHybrid;
  double? tip;
  Users? user = Users();
  List<TypePay>? paymentList = [];
  List<Destiny>? destination = [];
  List<Chat>? lCh = [];
  double? toll;
  List<Toll>? pointsToll = [];
  int? statusAssigned;

  RequestData(
      {this.requestId,
      this.requestIdCall,
      this.activeServiceId,
      this.paymentType,
      this.longitude,
      this.latitude,
      this.distance,
      this.times,
      this.prices,
      this.latitudeOnBoard,
      this.longitudeOnBoard,
      this.hour,
      this.timePost,
      this.advice,
      this.nameHybrid,
      this.tip,
      this.user,
      this.paymentList,
      this.destination,
      this.lCh,
      this.toll,
      this.pointsToll,
      this.statusAssigned});

  @override
  String toString() {
    return 'RequestData{requestId: $requestId, requestIdCall: $requestIdCall, activeServiceId: $activeServiceId, paymentType: $paymentType, longitude: $longitude, latitude: $latitude, distance: $distance, times: $times, prices: $prices, latitudeOnBoard: $latitudeOnBoard, longitudeOnBoard: $longitudeOnBoard, hour: $hour, timePost: $timePost, advice: $advice, nameHybrid: $nameHybrid, tip: $tip, user: $user, paymentList: $paymentList, destination: $destination, lCh: $lCh, toll: $toll, pointsToll: $pointsToll, statusAssigned: $statusAssigned}';
  }

  factory RequestData.fromMap(Map<String, dynamic> json) => RequestData(
        requestId: json["requestId"] ??= 0,
        requestIdCall: json["requestIdCall"] ??= '',
        activeServiceId: json["activeServiceId"],
        latitude: json["latitude"] != null
            ? double.parse(json["latitude"].toString())
            : 0.0,
        longitude: json["longitude"] != null
            ? double.parse(json["longitude"].toString())
            : 0.0,
        latitudeOnBoard: json["latitudeOnBoard"] != null
            ? double.parse(json["latitudeOnBoard"].toString())
            : 0.0,
        longitudeOnBoard: json["longitudeOnBoard"] != null
            ? double.parse(json["longitudeOnBoard"].toString())
            : 0.0,
        paymentType: json["paymentType"],
        distance: json["distance"] != null
            ? double.parse(json["distance"].toString())
            : 0.0,
        times: json["times"] ??= 1,
        prices: json["prices"] == null
            ? []
            : List<double>.from(json["prices"].map((x) => x.toDouble())),
        hour: json["hour"],
        timePost: json["timePost"] ??= 0,
        advice: json["advice"] ??= 0,
        user: json["user"] == null ? null : Users.fromMap(json["user"]),
        nameHybrid: json["labeltF"],
        tip: json["tip"] != null ? double.parse(json["tip"].toString()) : 0.0,
        paymentList: json["paymentList"] == null
            ? []
            : List<TypePay>.from(
                json["paymentList"].map((x) => TypePay.fromMap(x))),
        destination: json["destination"] == null
            ? []
            : List<Destiny>.from(
                json["destination"].map((x) => Destiny.fromMap(x))),
        lCh: json["lCh"] == null
            ? []
            : List<Chat>.from(json["lCh"].map((x) => Chat.fromMap(x))),
        toll:
            json["toll"] != null ? double.parse(json["toll"].toString()) : 0.0,
        pointsToll: json["pointsToll"] == null
            ? []
            : List<Toll>.from(
                json["pointsToll"].map((x) => Toll.fromMap(x)),
              ),
        statusAssigned: json["statusAssigned"],
      );

  Map<String, dynamic> toMap() => {
        "requestId": requestId,
        "requestIdCall": requestIdCall,
        "activeServiceId": activeServiceId,
        "longitude": longitude,
        "latitude": latitude,
        "longitudeOnBoard": longitudeOnBoard,
        "latitudeOnBoard": latitudeOnBoard,
        "paymentType": paymentType,
        "distance": distance,
        "times": times,
        "prices": prices == null
            ? []
            : List<dynamic>.from(prices!.map((x) => x.toDouble())),
        "hour": hour,
        "timePost": timePost,
        "advice": advice,
        "user": user!.toMap(),
        "labeltF": nameHybrid,
        "tip": tip,
        "paymentList": paymentList == null
            ? []
            : List<dynamic>.from(paymentList!.map((x) => x.toMap())),
        "destination": destination == null
            ? []
            : List<dynamic>.from(destination!.map((x) => x.toMap())),
        "lCh":
            lCh == null ? [] : List<dynamic>.from(lCh!.map((x) => x.toMap())),
        "toll": toll,
        "pointsTolls": pointsToll == null
            ? []
            : List<dynamic>.from(pointsToll!.map((x) => x.toMap())),
        "statusAssigned": statusAssigned,
      };
}

class Toll {
  double? latitude;
  double? longitude;
  String? money;
  String? name;
  double? price;

  Toll({this.latitude, this.longitude, this.money, this.name, this.price});

  @override
  String toString() {
    return 'Toll{latitude: $latitude, longitude: $longitude, money: $money, name: $name, price: $price}';
  }

  factory Toll.fromMap(Map<String, dynamic> json) => Toll(
        latitude: json["lat"],
        longitude: json["lng"],
        money: json["moneda"] ??= '',
        name: json["nombre"] ??= '',
        price: json["precio"] != null
            ? double.parse(json["precio"].toString())
            : 0.00,
      );

  Map<String, dynamic> toMap() => {
        "lat": latitude,
        "lng": longitude,
        "moneda": money,
        "nombre": name,
        "price": price,
      };
}

class TypePay {
  String? namePay;
  List<Item>? itemsList = [];

  TypePay({
    this.namePay,
    this.itemsList,
  });

  @override
  String toString() {
    return 'TypePay{namePay: $namePay, itemsList: $itemsList}';
  }

  factory TypePay.fromMap(Map<String, dynamic> json) => TypePay(
        namePay: json["namePay"],
        itemsList: json["itemsList"] == null
            ? []
            : List<Item>.from(json["itemsList"].map((x) => Item.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "namePay": namePay,
        "itemsList": itemsList == null
            ? []
            : List<dynamic>.from(itemsList!.map((x) => x.toMap())),
      };
}

class Item {
  int? type;
  String? name;
  double? mount;

  Item({
    this.type,
    this.name,
    this.mount,
  });

  @override
  String toString() {
    return 'Item{type: $type, name: $name, mount: $mount}';
  }

  factory Item.fromMap(Map<String, dynamic> json) => Item(
        type: json["type"],
        name: json["name"],
        mount: json["mount"] != null
            ? double.parse(json["mount"].toString())
            : 0.0,
      );

  Map<String, dynamic> toMap() => {
        "type": type,
        "name": name,
        "mount": mount,
      };
}

class Destiny {
  double? ltD;
  double? lgD;
  double? desDis;
  String? desBar;
  String? desCp;
  String? desCs;
  double? desC;
  String? desT;
  double? moreBid;
  double? lessBid;
  double? fraction;
  double? cost;
  int? isBid;

  Destiny(
      {this.ltD,
      this.lgD,
      this.desDis,
      this.desBar,
      this.desCp,
      this.desCs,
      this.desC,
      this.desT,
      this.moreBid,
      this.lessBid,
      this.fraction,
      this.cost,
      this.isBid});

  @override
  String toString() {
    return 'Destiny{ltD: $ltD, lgD: $lgD, desDis: $desDis, desBar: $desBar, desCp: $desCp, desCs: $desCs, desC: $desC, desT: $desT, moreBid: $moreBid, lessBid: $lessBid, fraction: $fraction, cost: $cost, isBid: $isBid}';
  }

  factory Destiny.fromMap(Map<String, dynamic> json) => Destiny(
        ltD: json["ltD"] != null ? double.parse(json["ltD"].toString()) : 0.0,
        lgD: json["lgD"] != null ? double.parse(json["lgD"].toString()) : 0.0,
        desDis: json["desDis"] != null
            ? double.parse(json["desDis"].toString())
            : 0.0,
        desBar: json["desBar"],
        desCp: json["desCp"],
        desCs: json["desCs"],
        desT: json["desT"],
        desC:
            json["desC"] != null ? double.parse(json["desC"].toString()) : 0.0,
        moreBid: double.parse(json["masPuja"].toString()),
        lessBid: double.parse(json["minPuja"].toString()),
        fraction: double.parse(json["fraccion"].toString()),
        cost: double.parse(json["costo"].toString()),
        isBid: json["isPuja"],
      );

  Map<String, dynamic> toMap() => {
        "ltD": ltD,
        "lgD": lgD,
        "desDis": desDis,
        "desBar": desBar,
        "desCp": desCp,
        "desCs": desCs,
        "desC": desC,
        "desT": desT,
        "masPuja": moreBid,
        "minPuja": lessBid,
        "fraccion": desT,
        "costo": cost,
        "isPuja": isBid
      };
}

class Chat {
  bool? stateChat;
  String? uid;
  String? message;
  String? hour;
  String? date;
  String? url;
  int? typeChat;
  int? typeAudioWalkieTalkie;
  String? pathAudio;
  bool? isPlaying;

  Chat(
      {this.stateChat,
      this.uid,
      this.message,
      this.hour,
      this.date,
      this.url,
      this.typeChat,
      this.typeAudioWalkieTalkie,
      this.pathAudio,
      this.isPlaying});

  @override
  String toString() {
    return 'Chat{stateChat: $stateChat, uid: $uid, message: $message, hour: $hour, date: $date, url: $url, typeChat: $typeChat, typeAudioWalkieTalkie: $typeAudioWalkieTalkie, pathAudio: $pathAudio, isPlaying: $isPlaying}';
  }

  factory Chat.fromMap(Map<String, dynamic> json) => Chat(
        stateChat: json["stateChat"] ??= false,
        uid: json["uid"],
        message: json["message"],
        hour: json["hora"],
        date: json["date"],
        typeChat: json["typeChat"],
        url: json["url"],
        typeAudioWalkieTalkie: json["typeAudio"],
        pathAudio: json["pathAudio"],
        isPlaying: json["isPlaying"] ??= false,
      );

  Map<String, dynamic> toMap() => {
        "state": stateChat,
        "uid": uid,
        "message": message,
        "hora": hour,
        "date": date,
        "typeChat": typeChat,
        "url": url,
        "typeAudioWalkieTalkie": typeAudioWalkieTalkie,
        "pathAudio": pathAudio,
        "isPlaying": isPlaying
      };
}
