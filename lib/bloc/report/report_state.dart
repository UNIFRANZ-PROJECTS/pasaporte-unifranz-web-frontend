part of 'report_bloc.dart';

class ReportState extends Equatable {
  final List<EventModel> listEvents;
  final bool isLoading;
  final bool ascending;
  final int? sortColumnIndex;
  const ReportState({
    this.listEvents = const [],
    this.isLoading = true,
    this.ascending = true,
    this.sortColumnIndex,
  });

  ReportState copyWith({
    List<EventModel>? listEvents,
    bool? isLoading,
    bool? ascending,
    int? sortColumnIndex,
  }) =>
      ReportState(
        listEvents: listEvents ?? this.listEvents,
        isLoading: isLoading ?? this.isLoading,
        ascending: ascending ?? this.ascending,
        sortColumnIndex: sortColumnIndex ?? this.sortColumnIndex,
      );
  @override
  List<Object> get props => [listEvents];
}
