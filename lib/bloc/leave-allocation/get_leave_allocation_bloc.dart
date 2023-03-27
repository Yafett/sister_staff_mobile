import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sister_staff_mobile/models/Allocation-model.dart';
import 'package:sister_staff_mobile/resource/data-provider.dart';

part 'get_leave_allocation_event.dart';
part 'get_leave_allocation_state.dart';

class GetLeaveAllocationBloc
    extends Bloc<GetLeaveAllocationEvent, GetLeaveAllocationState> {
  GetLeaveAllocationBloc() : super(GetLeaveAllocationInitial()) {
    final dataProvider = DataProvider();

    on<GetLeaveAllocationEvent>((event, emit) async {
      try {
        emit(GetLeaveAllocationLoading());
        final result = await dataProvider.fetchLeaveAllocation();
        emit(GetLeaveAllocationLoaded(result));
        print(result.toString());
        if (result.error != null) {
          emit(GetLeaveAllocationError(result.error.toString()));
        }
      } on NetworkError {
        emit(GetLeaveAllocationError(
            "Failed to fetch data. is your device online?"));
      }
    });
  }
}
