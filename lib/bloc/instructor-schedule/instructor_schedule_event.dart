part of 'instructor_schedule_bloc.dart';

abstract class InstructorScheduleEvent extends Equatable {
  const InstructorScheduleEvent();

  @override
  List<Instructor> get props => [];
}

class GetScheduleList extends InstructorScheduleEvent {
  final String? code;

  GetScheduleList({this.code});
}
