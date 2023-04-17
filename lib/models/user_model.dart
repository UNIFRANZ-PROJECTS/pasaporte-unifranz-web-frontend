// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

List<UserModel> userModelFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

UserModel userItemModelFromJson(String str) => UserModel.fromJson(json.decode(str));

class UserModel {
  UserModel({
    required this.careerIds,
    required this.valid,
    required this.state,
    required this.name,
    required this.email,
    required this.typeUser,
    required this.rol,
    required this.responsible,
    required this.password,
    required this.id,
  });

  List<CareerId> careerIds;
  bool valid;
  bool state;
  String name;
  String email;
  Responsible typeUser;
  Responsible rol;
  Responsible responsible;
  String password;
  String id;

  UserModel copyWith({
    List<CareerId>? careerIds,
    bool? valid,
    bool? state,
    String? name,
    String? email,
    Responsible? typeUser,
    Responsible? rol,
    Responsible? responsible,
    String? password,
    String? id,
  }) =>
      UserModel(
        careerIds: careerIds ?? this.careerIds,
        valid: valid ?? this.valid,
        state: state ?? this.state,
        name: name ?? this.name,
        email: email ?? this.email,
        typeUser: typeUser ?? this.typeUser,
        rol: rol ?? this.rol,
        responsible: responsible ?? this.responsible,
        password: password ?? this.password,
        id: id ?? this.id,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        careerIds: List<CareerId>.from(json["careerIds"].map((x) => CareerId.fromJson(x))),
        valid: json["valid"],
        state: json["state"],
        name: json["name"],
        email: json["email"],
        typeUser: Responsible.fromJson(json["type_user"]),
        rol: Responsible.fromJson(json["rol"]),
        responsible: Responsible.fromJson(json["responsible"]),
        password: json["password"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "careerIds": List<dynamic>.from(careerIds.map((x) => x.toJson())),
        "valid": valid,
        "state": state,
        "name": name,
        "email": email,
        "type_user": typeUser.toJson(),
        "rol": rol.toJson(),
        "responsible": responsible.toJson(),
        "password": password,
        "id": id,
      };
}

class CareerId {
  CareerId({
    required this.id,
    required this.name,
    required this.campus,
  });

  String? id;
  String? name;
  String? campus;

  CareerId copyWith({
    String? id,
    String? name,
    String? campus,
  }) =>
      CareerId(
        id: id ?? this.id,
        name: name ?? this.name,
        campus: campus ?? this.campus,
      );

  factory CareerId.fromJson(Map<String, dynamic> json) => CareerId(
        id: json["_id"],
        name: json["name"],
        campus: json["campus"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "campus": campus,
      };
}

class Responsible {
  Responsible({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  Responsible copyWith({
    String? id,
    String? name,
  }) =>
      Responsible(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory Responsible.fromJson(Map<String, dynamic> json) => Responsible(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}
