// To parse this JSON data, do
//
//     final guestModel = guestModelFromJson(jsonString);

import 'dart:convert';

List<GuestModel> guestModelFromJson(String str) =>
    List<GuestModel>.from(json.decode(str).map((x) => GuestModel.fromJson(x)));

String guestModelToJson(List<GuestModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

GuestModel guestItemModelFromJson(String str) => GuestModel.fromJson(json.decode(str));

class GuestModel {
  GuestModel({
    required this.state,
    required this.firstName,
    required this.lastName,
    required this.description,
    required this.specialty,
    required this.user,
    required this.image,
    required this.id,
  });

  bool state;
  String firstName;
  String lastName;
  String description;
  String specialty;
  String user;
  String image;
  String id;

  GuestModel copyWith({
    bool? state,
    String? firstName,
    String? lastName,
    String? description,
    String? specialty,
    String? user,
    String? image,
    String? id,
  }) =>
      GuestModel(
        state: state ?? this.state,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        description: description ?? this.description,
        specialty: specialty ?? this.specialty,
        user: user ?? this.user,
        image: image ?? this.image,
        id: id ?? this.id,
      );

  factory GuestModel.fromJson(Map<String, dynamic> json) => GuestModel(
        state: json["state"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        description: json["description"],
        specialty: json["specialty"],
        user: json["user"],
        image: json["image"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "state": state,
        "first_name": firstName,
        "last_name": lastName,
        "description": description,
        "specialty": specialty,
        "user": user,
        "image": image,
        "id": id,
      };
}
