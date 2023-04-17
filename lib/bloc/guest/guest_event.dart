part of 'guest_bloc.dart';

abstract class GuestEvent extends Equatable {
  const GuestEvent();

  @override
  List<Object> get props => [];
}

class UpdateListGuest extends GuestEvent {
  final List<GuestModel> listRol;

  const UpdateListGuest(this.listRol);
}

class UpdateSortColumnIndexGuest extends GuestEvent {
  final int sortColumnIndex;

  const UpdateSortColumnIndexGuest(this.sortColumnIndex);
}

class AddItemListGuest extends GuestEvent {
  final GuestModel guest;

  const AddItemListGuest(this.guest);
}

class UpdateItemGuest extends GuestEvent {
  final GuestModel guest;
  const UpdateItemGuest(this.guest);
}
