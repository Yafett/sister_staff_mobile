part of 'get_leave_allocation_bloc.dart';

abstract class GetLeaveAllocationEvent extends Equatable {
  const GetLeaveAllocationEvent();

  @override
  List<Object> get props => [];
}

class GetLeaveAllocationList extends GetLeaveAllocationEvent {}
