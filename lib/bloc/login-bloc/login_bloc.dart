// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sister_staff_mobile/resource/auth-provider.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<Login>((event, emit) async {
      final _authRepository = AuthProvider();

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      try {
        emit(LoginLoading());
        final result =
            await _authRepository.login(event.username, event.password);

        if (result == 'Error') {
          emit(LoginError('Your Email or Password is incorrect!'));
        } else {
          emit(LoginSuccess(result.toString()));
        }
      } on NetworkError {
        emit(LoginError("Failed to fetch data. is your device online?"));
      }
    });
  }
}
