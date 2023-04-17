// To parse this JSON data, do
//
//     final careerModel = careerModelFromJson(jsonString);

import 'dart:convert';

List<CareerModel> careerModelFromJson(String str) =>
    List<CareerModel>.from(json.decode(str).map((x) => CareerModel.fromJson(x)));

String careerModelToJson(List<CareerModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
CareerModel careerItemModelFromJson(String str) => CareerModel.fromJson(json.decode(str));

class CareerModel {
  CareerModel({
    required this.state,
    required this.name,
    required this.abbreviation,
    required this.campus,
    required this.faculty,
    required this.id,
  });

  bool state;
  String name;
  String abbreviation;
  String campus;
  String faculty;
  String id;

  CareerModel copyWith({
    bool? state,
    String? name,
    String? abbreviation,
    String? campus,
    String? faculty,
    String? id,
  }) =>
      CareerModel(
        state: state ?? this.state,
        name: name ?? this.name,
        abbreviation: abbreviation ?? this.abbreviation,
        campus: campus ?? this.campus,
        faculty: faculty ?? this.faculty,
        id: id ?? this.id,
      );

  factory CareerModel.fromJson(Map<String, dynamic> json) => CareerModel(
        state: json["state"],
        name: json["name"],
        abbreviation: json["abbreviation"],
        campus: json["campus"],
        faculty: json["faculty"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "state": state,
        "name": name,
        "abbreviation": abbreviation,
        "campus": campus,
        "faculty": faculty,
        "id": id,
      };
}
