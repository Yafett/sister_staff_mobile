part of 'get_teacher_student_attendance_bloc.dart';

abstract class GetTeacherStudentAttendanceEvent extends Equatable {
  const GetTeacherStudentAttendanceEvent();

  @override
  List<Object> get props => [];
}

class GetTeacherStudentAttendanceList
    extends GetTeacherStudentAttendanceEvent {}
