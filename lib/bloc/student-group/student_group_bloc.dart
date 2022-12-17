import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'student_group_event.dart';
part 'student_group_state.dart';

class StudentGroupBloc extends Bloc<StudentGroupEvent, StudentGroupState> {
  StudentGroupBloc() : super(StudentGroupInitial()) {
    on<StudentGroupEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
