import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:passport_unifranz_web/models/student_model.dart';

part 'student_event.dart';
part 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  List<StudentModel> listEstudent = [];
  StudentBloc() : super(const StudentState()) {
    on<UpdateListStudent>((event, emit) => emit(state.copyWith(listEstudent: event.listEstudent)));
    on<UpdateSortColumnIndexStudent>((event, emit) {
      sort((event) => event.nombre);
      emit(state.copyWith(
          listEstudent: listEstudent, ascending: !state.ascending, sortColumnIndex: event.sortColumnIndex));
    });
  }

  void sort<T>(Comparable<T> Function(StudentModel event) getField) {
    listEstudent = [...state.listEstudent];
    listEstudent.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      Comparable.compare(aValue, bValue);
      return state.ascending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
    });
  }
}
