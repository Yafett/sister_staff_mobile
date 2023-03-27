import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sister_staff_mobile/resource/data-provider.dart';

part 'get_teacher_student_attendance_event.dart';
part 'get_teacher_student_attendance_state.dart';

class GetTeacherStudentAttendanceBloc extends Bloc<
    GetTeacherStudentAttendanceEvent, GetTeacherStudentAttendanceState> {
  GetTeacherStudentAttendanceBloc()
      : super(GetTeacherStudentAttendanceInitial()) {
    final _dataProvider = DataProvider();

    on<GetTeacherStudentAttendanceEvent>((event, emit) async {
      emit(GetTeacherStudentAttendanceLoading());
    });
  }
}
