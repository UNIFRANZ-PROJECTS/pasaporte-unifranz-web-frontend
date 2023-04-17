part of 'student_bloc.dart';

class StudentState extends Equatable {
  final List<StudentModel> listEstudent;

  final bool isLoading;
  final bool ascending;
  final int? sortColumnIndex;

  const StudentState({
    this.listEstudent = const [],
    this.isLoading = true,
    this.ascending = true,
    this.sortColumnIndex,
  });
  StudentState copyWith({
    List<StudentModel>? listEstudent,
    bool? isLoading,
    bool? ascending,
    int? sortColumnIndex,
  }) =>
      StudentState(
        listEstudent: listEstudent ?? this.listEstudent,
        isLoading: isLoading ?? this.isLoading,
        ascending: ascending ?? this.ascending,
        sortColumnIndex: sortColumnIndex ?? this.sortColumnIndex,
      );

  @override
  List<Object> get props => [listEstudent, isLoading, ascending];
}
