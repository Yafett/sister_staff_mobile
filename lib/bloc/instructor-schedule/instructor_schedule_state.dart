part of 'instructor_schedule_bloc.dart';

abstract class InstructorScheduleState extends Equatable {
  const InstructorScheduleState();

  @override
  List<Schedule> get props => [];
}

class InstructorScheduleInitial extends InstructorScheduleState {}

class InstructorScheduleLoading extends InstructorScheduleState {}

class InstructorScheduleLoaded extends InstructorScheduleState {
  Schedule scheduleModel;
  InstructorScheduleLoaded(this.scheduleModel);
}

class InstructorScheduleError extends InstructorScheduleState {
  String? errorMessage;
  InstructorScheduleError(this.errorMessage);
}
