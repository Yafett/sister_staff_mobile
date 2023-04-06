// ignore_for_file: prefer_const_constructors_in_immutables

part of 'get_leave_allocation_bloc.dart';

abstract class GetLeaveAllocationState extends Equatable {
  const GetLeaveAllocationState();

  @override
  List<Object> get props => [];
}

class GetLeaveAllocationInitial extends GetLeaveAllocationState {}

class GetLeaveAllocationLoading extends GetLeaveAllocationState {}

class GetLeaveAllocationLoaded extends GetLeaveAllocationState {
  final Allocation allocation;
  GetLeaveAllocationLoaded(this.allocation);
}

class GetLeaveAllocationError extends GetLeaveAllocationState {
  final String error;
  GetLeaveAllocationError(this.error);
}
