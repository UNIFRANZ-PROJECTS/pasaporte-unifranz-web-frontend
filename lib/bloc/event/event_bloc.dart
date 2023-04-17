import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:passport_unifranz_web/models/event_model.dart';

part 'event_event.dart';
part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  List<EventModel> listEvent = [];
  EventBloc() : super(const EventState()) {
    on<UpdateListEvent>((event, emit) {
      List<CalendarEventData<EventModel>> listEventCalendar = [];
      for (final EventModel element in event.listEvents) {
        debugPrint('HOLA');
        debugPrint('element $element');
        listEventCalendar.add(CalendarEventData(
          date: element.start,
          event: element,
          title: element.title,
          startTime: element.start,
          endTime: element.end,
        ));
      }
      emit(state.copyWith(
        existEvents: event.listEvents.isNotEmpty,
        listEvents: event.listEvents,
        eventCtrl: EventController<EventModel>()..addAll(listEventCalendar),
        listEventsCalendar: listEventCalendar,
      ));
    });

    on<UpdateSortColumnIndexEvent>((event, emit) {
      sort((event) => event.title);
      emit(state.copyWith(listEvents: listEvent, ascending: !state.ascending, sortColumnIndex: event.sortColumnIndex));
    });
    on<AddItemListEvent>((event, emit) {
      final eventCalendar = CalendarEventData(
        date: event.event.start,
        event: event.event,
        title: event.event.title,
        description: json.encode(event.event),
        startTime: event.event.start,
        endTime: event.event.end,
      );
      emit(state.copyWith(
          existEvents: true,
          listEvents: [...state.listEvents, event.event],
          eventCtrl: EventController<EventModel>()..addAll([...state.listEventsCalendar, eventCalendar]),
          listEventsCalendar: [...state.listEventsCalendar, eventCalendar]));
    });
    on<UpdateItemEvent>(((event, emit) => _onUpdateEventById(event, emit)));
  }
  void sort<T>(Comparable<T> Function(EventModel event) getField) {
    listEvent = [...state.listEvents];
    listEvent.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      Comparable.compare(aValue, bValue);
      return state.ascending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
    });
  }

  _onUpdateEventById(UpdateItemEvent evento, Emitter<EventState> emit) async {
    List<EventModel> listNewEvent = [...state.listEvents];
    listNewEvent[listNewEvent.indexWhere((e) => e.id == evento.event.id)] = evento.event;
    emit(state.copyWith(listEvents: listNewEvent));
  }
}
