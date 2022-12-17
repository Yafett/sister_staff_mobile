// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sister_staff_mobile/models/Instructor-model.dart';
import 'package:sister_staff_mobile/models/Schedule-model.dart';
import 'package:sister_staff_mobile/resource/data-provider.dart';

part 'instructor_schedule_event.dart';
part 'instructor_schedule_state.dart';

class InstructorScheduleBloc
    extends Bloc<InstructorScheduleEvent, InstructorScheduleState> {
  InstructorScheduleBloc() : super(InstructorScheduleInitial()) {
    final _dataProvider = DataProvider();
    on<GetScheduleList>((event, emit) async {
      try {
        emit(InstructorScheduleLoading());
        final result = await _dataProvider.fetchSchedule();
        emit(InstructorScheduleLoaded(result));
        if (result.error != null) {
          emit(InstructorScheduleError(result.error.toString()));
        }
      } on NetworkError {
        emit(InstructorScheduleError(
            "Failed to fetch data. is your device online?"));
      }
    });
  }
}
