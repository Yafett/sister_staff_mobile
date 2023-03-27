part of 'get_teacher_student_attendance_bloc.dart';

abstract class GetTeacherStudentAttendanceState extends Equatable {
  const GetTeacherStudentAttendanceState();

  @override
  List<Object> get props => [];
}

class GetTeacherStudentAttendanceInitial
    extends GetTeacherStudentAttendanceState {}

class GetTeacherStudentAttendanceLoading
    extends GetTeacherStudentAttendanceState {}

class GetTeacherStudentAttendanceLoaded
    extends GetTeacherStudentAttendanceState {}

class GetTeacherStudentAttendanceError
    extends GetTeacherStudentAttendanceState {}
