// To parse this JSON data, do
//
//     final eventModel = eventModelFromJson(jsonString);

import 'dart:convert';

import 'package:passport_unifranz_web/models/career_model.dart';
import 'package:passport_unifranz_web/models/category_model.dart';
import 'package:passport_unifranz_web/models/guest_model.dart';
import 'package:passport_unifranz_web/models/student_model.dart';

List<EventModel> eventModelFromJson(String str) =>
    List<EventModel>.from(json.decode(str).map((x) => EventModel.fromJson(x)));

String eventModelToJson(List<EventModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

EventModel eventItemModelFromJson(String str) => EventModel.fromJson(json.decode(str));

class EventModel {
  EventModel({
    required this.categoryIds,
    required this.activitieIds,
    required this.careerIds,
    required this.guestIds,
    required this.studentIds,
    required this.state,
    required this.title,
    required this.description,
    required this.start,
    required this.end,
    required this.user,
    required this.image,
    required this.id,
    required this.stateEvent,
    required this.modality,
    this.urlEvent,
  });

  List<CategoryModel> categoryIds;
  List<CategoryModel> activitieIds;
  List<CareerModel> careerIds;
  List<GuestModel> guestIds;
  List<StudentModel> studentIds;
  bool state;
  String title;
  String description;
  DateTime start;
  DateTime end;
  String user;
  String image;
  String id;
  String stateEvent;
  String modality;
  dynamic urlEvent;

  EventModel copyWith({
    List<CategoryModel>? categoryIds,
    List<CategoryModel>? activitieIds,
    List<CareerModel>? careerIds,
    List<GuestModel>? guestIds,
    List<StudentModel>? studentIds,
    bool? state,
    String? title,
    String? description,
    DateTime? start,
    DateTime? end,
    String? user,
    String? image,
    String? id,
    String? stateEvent,
    String? modality,
    dynamic urlEvent,
  }) =>
      EventModel(
        categoryIds: categoryIds ?? this.categoryIds,
        activitieIds: activitieIds ?? this.activitieIds,
        careerIds: careerIds ?? this.careerIds,
        guestIds: guestIds ?? this.guestIds,
        studentIds: studentIds ?? this.studentIds,
        state: state ?? this.state,
        title: title ?? this.title,
        description: description ?? this.description,
        start: start ?? this.start,
        end: end ?? this.end,
        user: user ?? this.user,
        image: image ?? this.image,
        id: id ?? this.id,
        stateEvent: stateEvent ?? this.stateEvent,
        modality: modality ?? this.urlEvent,
        urlEvent: urlEvent ?? this.urlEvent,
      );

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        categoryIds: List<CategoryModel>.from(json["categoryIds"].map((x) => CategoryModel.fromJson(x))),
        activitieIds: List<CategoryModel>.from(json["activitieIds"].map((x) => x)),
        careerIds: List<CareerModel>.from(json["careerIds"].map((x) => CareerModel.fromJson(x))),
        guestIds: List<GuestModel>.from(json["guestIds"].map((x) => GuestModel.fromJson(x))),
        studentIds: List<StudentModel>.from(json["studentIds"].map((x) => StudentModel.fromJson(x))),
        state: json["state"],
        title: json["title"],
        description: json["description"],
        start: DateTime.parse(json["start"]),
        end: DateTime.parse(json["end"]),
        user: json["user"],
        image: json["image"],
        id: json["id"],
        stateEvent: json["stateEvent"],
        modality: json["modality"],
        urlEvent: json["urlEvent"],
      );

  Map<String, dynamic> toJson() => {
        "categoryIds": List<dynamic>.from(categoryIds.map((x) => x.toJson())),
        "activitieIds": List<dynamic>.from(activitieIds.map((x) => x.toJson())),
        "careerIds": List<dynamic>.from(careerIds.map((x) => x.toJson())),
        "guestIds": List<dynamic>.from(guestIds.map((x) => x.toJson())),
        "studentIds": List<dynamic>.from(studentIds.map((x) => x.toJson())),
        "state": state,
        "title": title,
        "description": description,
        "start": start.toIso8601String(),
        "end": end.toIso8601String(),
        "user": user,
        "image": image,
        "id": id,
        "stateEvent": stateEvent,
        "modality": modality,
        "urlEvent": urlEvent,
      };
}
