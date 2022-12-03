part of 'get_profile_employee_bloc.dart';

abstract class GetProfileEmployeeState extends Equatable {
  const GetProfileEmployeeState();

  @override
  List<Employee> get props => [];
}

class GetProfileEmployeeInitial extends GetProfileEmployeeState {}

class GetProfileEmployeeLoading extends GetProfileEmployeeState {}

class GetProfileEmployeeLoaded extends GetProfileEmployeeState {
  final Employee employeeModel;
  GetProfileEmployeeLoaded(this.employeeModel);
}

class GetProfileEmployeeError extends GetProfileEmployeeState {
  final String errorMessage;
  GetProfileEmployeeError(this.errorMessage);
}
