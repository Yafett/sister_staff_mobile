part of 'get_leave_application_bloc.dart';

abstract class GetLeaveApplicationEvent extends Equatable {
  const GetLeaveApplicationEvent();

  @override
  List<Leave> get props => [];
}

class GetLeaveApplicationList extends GetLeaveApplicationEvent {}
