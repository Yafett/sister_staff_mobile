part of 'get_leave_application_bloc.dart';

abstract class GetLeaveApplicationState extends Equatable {
  const GetLeaveApplicationState();

  @override
  List<Object> get props => [];
}

class GetLeaveApplicationInitial extends GetLeaveApplicationState {}

class GetLeaveApplicationLoading extends GetLeaveApplicationState {}

class GetLeaveApplicationLoaded extends GetLeaveApplicationState {
  final Leave leaveModel;
  GetLeaveApplicationLoaded(this.leaveModel);
}

class GetLeaveApplicationError extends GetLeaveApplicationState {
  final String errorMessage;
  GetLeaveApplicationError(this.errorMessage);
}
