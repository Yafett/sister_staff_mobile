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
        emit(GetProfileEmployeeLoaded(result));
      } catch (e) {
        emit(GetProfileEmployeeError(e.toString()));
      }
    });
  }
}
