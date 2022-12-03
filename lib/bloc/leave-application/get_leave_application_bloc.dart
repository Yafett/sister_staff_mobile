import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sister_staff_mobile/models/Leave-model.dart';
import 'package:sister_staff_mobile/resource/data-provider.dart';

part 'get_leave_application_event.dart';
part 'get_leave_application_state.dart';

class GetLeaveApplicationBloc
    extends Bloc<GetLeaveApplicationEvent, GetLeaveApplicationState> {
  GetLeaveApplicationBloc() : super(GetLeaveApplicationInitial()) {
    final _dataProvide = DataProvider();

    on<GetLeaveApplicationList>((event, emit) async {
      try {
        emit(GetLeaveApplicationLoading());
        final result = await _dataProvide.fetchLeaveApplication();
        emit(GetLeaveApplicationLoaded(result));
        if (result.error != null) {
          emit(GetLeaveApplicationError(result.error.toString()));
        }
      } on NetworkError {
        emit(GetLeaveApplicationError(
            "Failed to fetch data. is your device online?"));
      }
    });
  }
}
