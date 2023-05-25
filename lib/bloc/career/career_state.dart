part of 'career_bloc.dart';

class CareerState extends Equatable {
  final List<CareerModel> listCareer;

  final bool isLoading;
  final bool ascending;
  final int? sortColumnIndex;

  const CareerState({
    this.listCareer = const [],
    this.isLoading = true,
    this.ascending = true,
    this.sortColumnIndex,
  });
  CareerState copyWith({
    List<CareerModel>? listCareer,
    bool? isLoading,
    bool? ascending,
    int? sortColumnIndex,
  }) =>
      CareerState(
        listCareer: listCareer ?? this.listCareer,
        isLoading: isLoading ?? this.isLoading,
        ascending: ascending ?? this.ascending,
        sortColumnIndex: sortColumnIndex ?? this.sortColumnIndex,
      );
  @override
  List<Object> get props => [listCareer, isLoading, ascending];
}
