// ignore_for_file: prefer_const_constructors_in_immutables

part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String? role;
  LoginSuccess(this.role);
}

class LoginError extends LoginState {
  final String? error;
  LoginError(this.error);
}
