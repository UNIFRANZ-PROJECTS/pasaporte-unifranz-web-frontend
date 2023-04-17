import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:passport_unifranz_web/models/career_model.dart';

part 'career_event.dart';
part 'career_state.dart';

class CareerBloc extends Bloc<CareerEvent, CareerState> {
  List<CareerModel> listRol = [];
  CareerBloc() : super(const CareerState()) {
    on<UpdateListCareer>((event, emit) => emit(state.copyWith(listCareer: event.listCareer)));
  }
}
