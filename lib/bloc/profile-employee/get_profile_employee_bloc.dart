// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sister_staff_mobile/models/Employee-model.dart';
import 'package:sister_staff_mobile/resource/profile-provider.dart';

part 'get_profile_employee_event.dart';
part 'get_profile_employee_state.dart';

class GetProfileEmployeeBloc
    extends Bloc<GetProfileEmployeeEvent, GetProfileEmployeeState> {
  GetProfileEmployeeBloc() : super(GetProfileEmployeeInitial()) {
    final _profileProvider = ProfileProvider();

    on<GetProfileEmployeeList>((event, emit) async {
      try {
        emit(GetProfileEmployeeLoading());
        final result = await _profileProvider.fetchProfileEmployee();
        print(result.data!.company);
        emit(GetProfileEmployeeLoaded(result));
        if (result.error != null) {
          emit(GetProfileEmployeeError(result.error.toString()));
        }
      } on NetworkError {
        emit(GetProfileEmployeeError(
            "Failed to fetch data. is your device online?"));
      }
    });
  }
}
