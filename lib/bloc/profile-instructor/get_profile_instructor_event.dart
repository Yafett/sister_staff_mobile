part of 'get_profile_instructor_bloc.dart';

abstract class GetProfileInstructorEvent extends Equatable {
  const GetProfileInstructorEvent();

  @override
  List<Instructor> get props => [];
}

class GetProfileInstructorList extends GetProfileInstructorEvent {}
