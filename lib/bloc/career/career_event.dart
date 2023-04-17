part of 'career_bloc.dart';

abstract class CareerEvent extends Equatable {
  const CareerEvent();

  @override
  List<Object> get props => [];
}

class UpdateListCareer extends CareerEvent {
  final List<CareerModel> listCareer;

  const UpdateListCareer(this.listCareer);
}

class UpdateSortColumnIndexCareer extends CareerEvent {
  final int sortColumnIndex;

  const UpdateSortColumnIndexCareer(this.sortColumnIndex);
}
