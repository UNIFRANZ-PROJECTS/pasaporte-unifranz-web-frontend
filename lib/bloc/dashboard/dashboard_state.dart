part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final List<CountEvent> countEvent;
  final int totalEvents;
  final List<EventosPorCampus> listEventCampus;
  final List<CountEvent> modality;
  final List<Carrer> carrers;
  const DashboardState({
    this.countEvent = const [],
    this.totalEvents = 0,
    this.listEventCampus = const [],
    this.modality = const [],
    this.carrers = const [],
  });
  DashboardState copyWith({
    List<CountEvent>? countEvent,
    int? totalEvents,
    List<EventosPorCampus>? listEventCampus,
    List<CountEvent>? modality,
    List<Carrer>? carrers,
  }) =>
      DashboardState(
        countEvent: countEvent ?? this.countEvent,
        totalEvents: totalEvents ?? this.totalEvents,
        listEventCampus: listEventCampus ?? this.listEventCampus,
        modality: modality ?? this.modality,
        carrers: carrers ?? this.carrers,
      );
  @override
  List<Object> get props => [countEvent, totalEvents, listEventCampus, modality, carrers];
}
