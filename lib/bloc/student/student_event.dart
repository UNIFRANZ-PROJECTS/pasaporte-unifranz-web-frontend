part of 'student_bloc.dart';

abstract class StudentEvent extends Equatable {
  const StudentEvent();

  @override
  List<Object> get props => [];
}

class UpdateListStudent extends StudentEvent {
  final List<StudentModel> listEstudent;

  const UpdateListStudent(this.listEstudent);
}

class UpdateSortColumnIndexStudent extends StudentEvent {
  final int sortColumnIndex;

  const UpdateSortColumnIndexStudent(this.sortColumnIndex);
}
