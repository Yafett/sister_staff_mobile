import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sister_staff_mobile/bloc/leave-application/get_leave_application_bloc.dart';
import 'package:sister_staff_mobile/models/Student-Group-model.dart';
import 'package:sister_staff_mobile/resource/data-provider.dart';

part 'student_group_event.dart';
part 'student_group_state.dart';

class StudentGroupBloc extends Bloc<StudentGroupEvent, StudentGroupState> {
  StudentGroupBloc() : super(StudentGroupInitial()) {
    on<GetStudentGroupList>((event, emit) async {
      final _dataProvider = DataProvider();

      try {
        emit(StudentGroupLoading());
        final result = await _dataProvider.fetchStudentGroup();
        emit(StudentGroupLoaded(result));
        if (result.error != null) {
          emit(StudentGroupError(result.error.toString()));
        }
      } catch (e) {
        emit(StudentGroupError(e.toString()));
      }
    });
  }
}
