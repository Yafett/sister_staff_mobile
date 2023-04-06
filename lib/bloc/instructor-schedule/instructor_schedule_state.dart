
 // ignore_for_file: prefer_const_constructors_in_immutables
 
part of 'instructor_schedule_bloc.dart';

abstract class InstructorScheduleState extends Equatable {
  const InstructorScheduleState();

  @override
  List<Schedule> get props => [];
}

class InstructorScheduleInitial extends InstructorScheduleState {}

class InstructorScheduleLoading extends InstructorScheduleState {}

class InstructorScheduleLoaded extends InstructorScheduleState {
  final Schedule scheduleModel;
  InstructorScheduleLoaded(this.scheduleModel);
}

class InstructorScheduleError extends InstructorScheduleState {
  final String? errorMessage;
  InstructorScheduleError(this.errorMessage);
}
