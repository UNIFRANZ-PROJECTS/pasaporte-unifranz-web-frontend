import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:passport_unifranz_web/models/event_model.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc() : super(const ReportState()) {
    on<UpdateListReportEvent>((event, emit) => emit(state.copyWith(listEvents: event.listEvents)));
  }
}
