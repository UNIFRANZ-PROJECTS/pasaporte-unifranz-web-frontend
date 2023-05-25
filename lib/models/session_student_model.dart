// To parse this JSON data, do
//
//     final sessionStudentModel = sessionStudentModelFromJson(jsonString);

import 'dart:convert';

SessionStudentModel sessionStudentModelFromJson(String str) => SessionStudentModel.fromJson(json.decode(str));

String sessionStudentModelToJson(SessionStudentModel data) => json.encode(data.toJson());

class SessionStudentModel {
  bool ok;
  String uid;
  String name;
  Cliente cliente;
  bool admin;
  String token;

  SessionStudentModel({
    required this.ok,
    required this.uid,
    required this.name,
    required this.cliente,
    required this.admin,
    required this.token,
  });

  SessionStudentModel copyWith({
    bool? ok,
    String? uid,
    String? name,
    Cliente? cliente,
    bool? admin,
    String? token,
  }) =>
      SessionStudentModel(
        ok: ok ?? this.ok,
        uid: uid ?? this.uid,
        name: name ?? this.name,
        cliente: cliente ?? this.cliente,
        admin: admin ?? this.admin,
        token: token ?? this.token,
      );

  factory SessionStudentModel.fromJson(Map<String, dynamic> json) => SessionStudentModel(
        ok: json["ok"],
        uid: json["uid"],
        name: json["name"],
        cliente: Cliente.fromJson(json["cliente"]),
        admin: json["admin"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "uid": uid,
        "name": name,
        "cliente": cliente.toJson(),
        "admin": admin,
        "token": token,
      };
}

class Cliente {
  bool online;
  String sede;
  String carrera;
  String semestre;
  String ci;
  String codigo;
  String nombre;
  String apellido;
  String email;
  String id;

  Cliente({
    required this.online,
    required this.sede,
    required this.carrera,
    required this.semestre,
    required this.ci,
    required this.codigo,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.id,
  });

  Cliente copyWith({
    bool? online,
    String? sede,
    String? carrera,
    String? semestre,
    String? ci,
    String? codigo,
    String? nombre,
    String? apellido,
    String? email,
    String? id,
  }) =>
      Cliente(
        online: online ?? this.online,
        sede: sede ?? this.sede,
        carrera: carrera ?? this.carrera,
        semestre: semestre ?? this.semestre,
        ci: ci ?? this.ci,
        codigo: codigo ?? this.codigo,
        nombre: nombre ?? this.nombre,
        apellido: apellido ?? this.apellido,
        email: email ?? this.email,
        id: id ?? this.id,
      );

  factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
        online: json["online"],
        sede: json["sede"],
        carrera: json["carrera"],
        semestre: json["semestre"],
        ci: json["ci"],
        codigo: json["codigo"],
        nombre: json["nombre"],
        apellido: json["apellido"],
        email: json["email"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "online": online,
        "sede": sede,
        "carrera": carrera,
        "semestre": semestre,
        "ci": ci,
        "codigo": codigo,
        "nombre": nombre,
        "apellido": apellido,
        "email": email,
        "id": id,
      };
}
