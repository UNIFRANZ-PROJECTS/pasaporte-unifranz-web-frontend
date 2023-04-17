part of 'event_bloc.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object> get props => [];
}

class UpdateListEvent extends EventEvent {
  final List<EventModel> listEvents;

  const UpdateListEvent(this.listEvents);
}

class UpdateSortColumnIndexEvent extends EventEvent {
  final int sortColumnIndex;

  const UpdateSortColumnIndexEvent(this.sortColumnIndex);
}

class AddItemListEvent extends EventEvent {
  final EventModel event;

  const AddItemListEvent(this.event);
}

class UpdateItemEvent extends EventEvent {
  final EventModel event;
  const UpdateItemEvent(this.event);
}
