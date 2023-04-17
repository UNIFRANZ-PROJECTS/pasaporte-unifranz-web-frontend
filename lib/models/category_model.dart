// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

List<CategoryModel> categoryModelFromJson(String str) =>
    List<CategoryModel>.from(json.decode(str).map((x) => CategoryModel.fromJson(x)));

String categoryModelToJson(List<CategoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

CategoryModel categoryItemModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

class CategoryModel {
  CategoryModel({
    required this.state,
    required this.title,
    required this.user,
    required this.icon,
    required this.id,
  });

  bool state;
  String title;
  String user;
  String icon;
  String id;

  CategoryModel copyWith({
    bool? state,
    String? title,
    String? user,
    String? icon,
    String? id,
  }) =>
      CategoryModel(
        state: state ?? this.state,
        title: title ?? this.title,
        user: user ?? this.user,
        icon: icon ?? this.icon,
        id: id ?? this.id,
      );

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        state: json["state"],
        title: json["title"],
        user: json["user"],
        icon: json["icon"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "state": state,
        "title": title,
        "user": user,
        "icon": icon,
        "id": id,
      };
}
