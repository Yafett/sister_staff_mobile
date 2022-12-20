part of 'student_group_bloc.dart';

abstract class StudentGroupEvent extends Equatable {
  const StudentGroupEvent();

  @override
  List<Object> get props => [];
}

class GetStudentGroupList extends StudentGroupEvent {}
