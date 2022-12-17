part of 'get_profile_user_bloc.dart';

abstract class GetProfileUserState extends Equatable {
  const GetProfileUserState();

  @override
  List<User> get props => [];
}

class GetProfileUserInitial extends GetProfileUserState {}

class GetProfileUserLoading extends GetProfileUserState {}

class GetProfileUserLoaded extends GetProfileUserState {
  final User userModel;
  GetProfileUserLoaded(this.userModel);
}

class GetProfileUserError extends GetProfileUserState {
  final String errorMessage;
  GetProfileUserError(this.errorMessage);
}
