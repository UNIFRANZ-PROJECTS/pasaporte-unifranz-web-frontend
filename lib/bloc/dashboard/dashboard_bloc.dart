import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:passport_unifranz_web/models/dashboard_model.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(const DashboardState()) {
    on<UpdateDashboard>((event, emit) {
      debugPrint('AVTIZANDO ${event.total} EVENTOSSSSSSS ');
      emit(state.copyWith(
        countEvent: event.countEvent,
        totalEvents: event.total,
        listEventCampus: event.listEventCampus,
        modality: event.modality,
        carrers: event.carrers,
      ));
    });
  }
}
