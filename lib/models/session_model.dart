// To parse this JSON data, do
//
//     final sessionModel = sessionModelFromJson(jsonString);

import 'dart:convert';

import 'package:passport_unifranz_web/models/career_model.dart';
import 'package:passport_unifranz_web/models/permisions_model.dart';

SessionModel sessionModelFromJson(String str) => SessionModel.fromJson(json.decode(str));

String sessionModelToJson(SessionModel data) => json.encode(data.toJson());

class SessionModel {
  SessionModel({
    required this.ok,
    required this.uid,
    required this.name,
    required this.image,
    required this.rol,
    required this.permisions,
    required this.typeUser,
    required this.careerIds,
    required this.token,
  });

  bool ok;
  String uid;
  String name;
  String image;
  String rol;
  List<PermisionsModel> permisions;
  String typeUser;
  List<CareerModel> careerIds;
  String token;

  SessionModel copyWith({
    bool? ok,
    String? uid,
    String? name,
    String? image,
    String? rol,
    List<PermisionsModel>? permisions,
    String? typeUser,
    List<CareerModel>? careerIds,
    String? token,
  }) =>
      SessionModel(
        ok: ok ?? this.ok,
        uid: uid ?? this.uid,
        name: name ?? this.name,
        image: image ?? this.image,
        rol: rol ?? this.rol,
        permisions: permisions ?? this.permisions,
        typeUser: typeUser ?? this.typeUser,
        careerIds: careerIds ?? this.careerIds,
        token: token ?? this.token,
      );

  factory SessionModel.fromJson(Map<String, dynamic> json) => SessionModel(
        ok: json["ok"],
        uid: json["uid"],
        name: json["name"],
        image: json["image"],
        rol: json["rol"],
        permisions: List<PermisionsModel>.from(json["permisions"].map((x) => PermisionsModel.fromJson(x))),
        typeUser: json["type_user"],
        careerIds: List<CareerModel>.from(json["careerIds"].map((x) => CareerModel.fromJson(x))),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "uid": uid,
        "name": name,
        "image": image,
        "rol": rol,
        "permisions": List<dynamic>.from(permisions.map((x) => x.toJson())),
        "type_user": typeUser,
        "careerIds": List<dynamic>.from(careerIds.map((x) => x.toJson())),
        "token": token,
      };
}
