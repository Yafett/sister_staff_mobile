part of 'get_profile_instructor_bloc.dart';

abstract class GetProfileInstructorState extends Equatable {
  const GetProfileInstructorState();

  @override
  List<Instructor> get props => [];
}

class GetProfileInstructorInitial extends GetProfileInstructorState {}

class GetProfileInstructorLoading extends GetProfileInstructorState {}

class GetProfileInstructorLoaded extends GetProfileInstructorState {
  final Instructor instructorModel;
  GetProfileInstructorLoaded(this.instructorModel);
}

class GetProfileInstructorError extends GetProfileInstructorState {
  final String? errorMessage;
  GetProfileInstructorError(this.errorMessage);
}
