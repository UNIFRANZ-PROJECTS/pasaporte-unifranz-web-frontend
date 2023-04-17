part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class UpdateDashboard extends DashboardEvent {
  final List<CountEvent> countEvent;
  final int total;
  final List<EventosPorCampus> listEventCampus;
  final List<CountEvent> modality;
  final List<Carrer>? carrers;
  const UpdateDashboard(this.countEvent, this.total, this.listEventCampus, this.modality, this.carrers);
}
