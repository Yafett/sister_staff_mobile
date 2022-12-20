part of 'student_group_bloc.dart';

abstract class StudentGroupState extends Equatable {
  const StudentGroupState();

  @override
  List<Object> get props => [];
}

class StudentGroupInitial extends StudentGroupState {}

class StudentGroupLoading extends StudentGroupState {}

class StudentGroupLoaded extends StudentGroupState {
  final StudentGroup sgroupModel;
  StudentGroupLoaded(this.sgroupModel);
}

class StudentGroupError extends StudentGroupState {
  final String errorMessage;
  StudentGroupError(this.errorMessage);
}
