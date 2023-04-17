part of 'guest_bloc.dart';

class GuestState extends Equatable {
  final List<GuestModel> listGuests;

  final bool isLoading;
  final bool ascending;
  final int? sortColumnIndex;

  const GuestState({
    this.listGuests = const [],
    this.isLoading = true,
    this.ascending = true,
    this.sortColumnIndex,
  });
  GuestState copyWith({
    List<GuestModel>? listGuests,
    bool? isLoading,
    bool? ascending,
    int? sortColumnIndex,
  }) =>
      GuestState(
        listGuests: listGuests ?? this.listGuests,
        isLoading: isLoading ?? this.isLoading,
        ascending: ascending ?? this.ascending,
        sortColumnIndex: sortColumnIndex ?? this.sortColumnIndex,
      );

  @override
  List<Object> get props => [listGuests, isLoading, ascending];
}
