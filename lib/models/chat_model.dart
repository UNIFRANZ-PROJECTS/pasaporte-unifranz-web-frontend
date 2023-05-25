// To parse this JSON data, do
//
//     final chatModel = chatModelFromJson(jsonString);

import 'dart:convert';

List<ChatModel> chatModelFromJson(String str) =>
    List<ChatModel>.from(json.decode(str).map((x) => ChatModel.fromJson(x)));

String chatModelToJson(List<ChatModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatModel {
  ChatModel({
    required this.text,
    required this.client,
    required this.id,
  });

  String text;
  Client client;
  String id;

  ChatModel copyWith({
    String? text,
    Client? client,
    String? id,
  }) =>
      ChatModel(
        text: text ?? this.text,
        client: client ?? this.client,
        id: id ?? this.id,
      );

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        text: json["text"],
        client: Client.fromJson(json["client"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "client": client.toJson(),
        "id": id,
      };
}

class Client {
  Client({
    required this.online,
    required this.id,
    required this.sede,
    required this.carrera,
    required this.semestre,
    required this.ci,
    required this.codigo,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.v,
  });

  bool online;
  String id;
  String sede;
  String carrera;
  String semestre;
  String ci;
  String codigo;
  String nombre;
  String apellido;
  String email;
  int v;

  Client copyWith({
    bool? online,
    String? id,
    String? sede,
    String? carrera,
    String? semestre,
    String? ci,
    String? codigo,
    String? nombre,
    String? apellido,
    String? email,
    int? v,
  }) =>
      Client(
        online: online ?? this.online,
        id: id ?? this.id,
        sede: sede ?? this.sede,
        carrera: carrera ?? this.carrera,
        semestre: semestre ?? this.semestre,
        ci: ci ?? this.ci,
        codigo: codigo ?? this.codigo,
        nombre: nombre ?? this.nombre,
        apellido: apellido ?? this.apellido,
        email: email ?? this.email,
        v: v ?? this.v,
      );

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        online: json["online"],
        id: json["_id"],
        sede: json["sede"],
        carrera: json["carrera"],
        semestre: json["semestre"],
        ci: json["ci"],
        codigo: json["codigo"],
        nombre: json["nombre"],
        apellido: json["apellido"],
        email: json["email"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "online": online,
        "_id": id,
        "sede": sede,
        "carrera": carrera,
        "semestre": semestre,
        "ci": ci,
        "codigo": codigo,
        "nombre": nombre,
        "apellido": apellido,
        "email": email,
        "__v": v,
      };
}
