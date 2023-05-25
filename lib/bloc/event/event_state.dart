part of 'event_bloc.dart';

class EventState extends Equatable {
  final bool existEvents;
  final List<EventModel> listEvents;

  final List<CalendarEventData<EventModel>> listEventsCalendar;

  final bool isLoading;
  final bool ascending;
  final int? sortColumnIndex;

  final EventController<EventModel>? eventCtrl;
  const EventState(
      {this.existEvents = false,
      this.listEvents = const [],
      this.listEventsCalendar = const [],
      this.isLoading = true,
      this.ascending = true,
      this.sortColumnIndex,
      this.eventCtrl});

  EventState copyWith({
    bool? existEvents,
    List<EventModel>? listEvents,
    List<CalendarEventData<EventModel>>? listEventsCalendar,
    bool? isLoading,
    bool? ascending,
    int? sortColumnIndex,
    EventController<EventModel>? eventCtrl,
  }) =>
      EventState(
          existEvents: existEvents ?? this.existEvents,
          listEvents: listEvents ?? this.listEvents,
          listEventsCalendar: listEventsCalendar ?? this.listEventsCalendar,
          isLoading: isLoading ?? this.isLoading,
          ascending: ascending ?? this.ascending,
          sortColumnIndex: sortColumnIndex ?? this.sortColumnIndex,
          eventCtrl: eventCtrl ?? this.eventCtrl);

  @override
  List<Object> get props => [existEvents, listEvents, listEventsCalendar, isLoading, ascending];
}
