import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:passport_unifranz_web/models/guest_model.dart';

part 'guest_event.dart';
part 'guest_state.dart';

class GuestBloc extends Bloc<GuestEvent, GuestState> {
  List<GuestModel> listGuest = [];
  GuestBloc() : super(const GuestState()) {
    on<UpdateListGuest>((event, emit) => emit(state.copyWith(listGuests: event.listRol)));
    on<UpdateSortColumnIndexGuest>((event, emit) {
      sort((event) => event.firstName);
      emit(state.copyWith(listGuests: listGuest, ascending: !state.ascending, sortColumnIndex: event.sortColumnIndex));
    });
    on<AddItemListGuest>((event, emit) => emit(state.copyWith(listGuests: [...state.listGuests, event.guest])));
    on<UpdateItemGuest>(((event, emit) => _onUpdateTypeUserById(event, emit)));
  }

  void sort<T>(Comparable<T> Function(GuestModel event) getField) {
    listGuest = [...state.listGuests];
    listGuest.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      Comparable.compare(aValue, bValue);
      return state.ascending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
    });
  }

  _onUpdateTypeUserById(UpdateItemGuest guest, Emitter<GuestState> emit) async {
    List<GuestModel> listNewGuest = [...state.listGuests];
    listNewGuest[listNewGuest.indexWhere((e) => e.id == guest.guest.id)] = guest.guest;
    emit(state.copyWith(listGuests: listNewGuest));
  }
}
