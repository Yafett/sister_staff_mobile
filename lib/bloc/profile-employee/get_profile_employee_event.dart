part of 'get_profile_employee_bloc.dart';

abstract class GetProfileEmployeeEvent extends Equatable {
  const GetProfileEmployeeEvent();

  @override
  List<Employee> get props => [];
}

class GetProfileEmployeeList extends GetProfileEmployeeEvent {}
