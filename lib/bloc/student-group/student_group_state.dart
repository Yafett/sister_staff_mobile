part of 'student_group_bloc.dart';

abstract class StudentGroupState extends Equatable {
  const StudentGroupState();
  
  @override
  List<Object> get props => [];
}

class StudentGroupInitial extends StudentGroupState {}
