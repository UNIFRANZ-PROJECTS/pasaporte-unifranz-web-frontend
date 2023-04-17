// To parse this JSON data, do
//
//     final dashboardModel = dashboardModelFromJson(jsonString);

import 'dart:convert';

import 'package:passport_unifranz_web/models/career_model.dart';

DashboardModel dashboardModelFromJson(String str) => DashboardModel.fromJson(json.decode(str));

String dashboardModelToJson(DashboardModel data) => json.encode(data.toJson());

List<CountEvent> countEventFromJson(String str) =>
    List<CountEvent>.from(json.decode(str).map((x) => CountEvent.fromJson(x)));
List<EventosPorCampus> eventosPorCampusFromJson(String str) =>
    List<EventosPorCampus>.from(json.decode(str).map((x) => EventosPorCampus.fromJson(x)));

List<Carrer> carrerFromJson(String str) => List<Carrer>.from(json.decode(str).map((x) => Carrer.fromJson(x)));

Carrer carrerItemFromJson(String str) => Carrer.fromJson(json.decode(str));

class DashboardModel {
  DashboardModel({
    required this.ok,
    required this.total,
    required this.countEvents,
    required this.eventosPorCampus,
    required this.modality,
    required this.carrers,
  });

  bool ok;
  int total;
  List<CountEvent> countEvents;
  List<EventosPorCampus> eventosPorCampus;
  List<CountEvent> modality;
  List<Carrer> carrers;

  DashboardModel copyWith({
    bool? ok,
    int? total,
    List<CountEvent>? countEvents,
    List<EventosPorCampus>? eventosPorCampus,
    List<CountEvent>? modality,
    List<Carrer>? carrers,
  }) =>
      DashboardModel(
        ok: ok ?? this.ok,
        total: total ?? this.total,
        countEvents: countEvents ?? this.countEvents,
        eventosPorCampus: eventosPorCampus ?? this.eventosPorCampus,
        modality: modality ?? this.modality,
        carrers: carrers ?? this.carrers,
      );

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
        ok: json["ok"],
        total: json["total"],
        countEvents: List<CountEvent>.from(json["countEvents"].map((x) => CountEvent.fromJson(x))),
        eventosPorCampus:
            List<EventosPorCampus>.from(json["eventosPorCampus"].map((x) => EventosPorCampus.fromJson(x))),
        modality: List<CountEvent>.from(json["modality"].map((x) => CountEvent.fromJson(x))),
        carrers: List<Carrer>.from(json["carrers"].map((x) => Carrer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "total": total,
        "countEvents": List<dynamic>.from(countEvents.map((x) => x.toJson())),
        "eventosPorCampus": List<dynamic>.from(eventosPorCampus.map((x) => x.toJson())),
        "modality": List<dynamic>.from(countEvents.map((x) => x.toJson())),
        "carrers": List<dynamic>.from(carrers.map((x) => x.toJson())),
      };
}

class Carrer {
  Carrer({
    required this.campus,
    required this.carreras,
  });

  String campus;
  List<CareerModel> carreras;

  Carrer copyWith({
    String? campus,
    List<CareerModel>? carreras,
  }) =>
      Carrer(
        campus: campus ?? this.campus,
        carreras: carreras ?? this.carreras,
      );

  factory Carrer.fromJson(Map<String, dynamic> json) => Carrer(
        campus: json["campus"],
        carreras: List<CareerModel>.from(json["carreras"].map((x) => CareerModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "campus": campus,
        "carreras": List<dynamic>.from(carreras.map((x) => x.toJson())),
      };
}

class CountEvent {
  CountEvent({
    required this.name,
    required this.cantidad,
  });

  String name;
  int cantidad;

  CountEvent copyWith({
    String? name,
    int? cantidad,
  }) =>
      CountEvent(
        name: name ?? this.name,
        cantidad: cantidad ?? this.cantidad,
      );

  factory CountEvent.fromJson(Map<String, dynamic> json) => CountEvent(
        name: json["name"],
        cantidad: json["cantidad"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "cantidad": cantidad,
      };
}

class EventosPorCampus {
  EventosPorCampus({
    required this.campus,
    required this.carreras,
  });

  String campus;
  List<Carrera> carreras;

  EventosPorCampus copyWith({
    String? campus,
    List<Carrera>? carreras,
  }) =>
      EventosPorCampus(
        campus: campus ?? this.campus,
        carreras: carreras ?? this.carreras,
      );

  factory EventosPorCampus.fromJson(Map<String, dynamic> json) => EventosPorCampus(
        campus: json["campus"],
        carreras: List<Carrera>.from(json["carreras"].map((x) => Carrera.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "campus": campus,
        "carreras": List<dynamic>.from(carreras.map((x) => x.toJson())),
      };
}

class Carrera {
  Carrera({
    required this.carrera,
    required this.cantidad,
    required this.cancelado,
    required this.proximo,
    required this.concluido,
  });

  String carrera;
  int cantidad;
  int cancelado;
  int proximo;
  int concluido;

  Carrera copyWith({
    String? carrera,
    int? cantidad,
    int? cancelado,
    int? proximo,
    int? concluido,
  }) =>
      Carrera(
        carrera: carrera ?? this.carrera,
        cantidad: cantidad ?? this.cantidad,
        cancelado: cancelado ?? this.cancelado,
        proximo: proximo ?? this.proximo,
        concluido: concluido ?? this.concluido,
      );

  factory Carrera.fromJson(Map<String, dynamic> json) => Carrera(
        carrera: json["carrera"],
        cantidad: json["cantidad"],
        cancelado: json["cancelado"],
        proximo: json["proximo"],
        concluido: json["concluido"],
      );

  Map<String, dynamic> toJson() => {
        "carrera": carrera,
        "cantidad": cantidad,
        "cancelado": cancelado,
        "proximo": proximo,
        "concluido": concluido,
      };
}
