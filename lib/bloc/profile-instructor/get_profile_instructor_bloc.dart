import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sister_staff_mobile/models/Instructor-model.dart';
import 'package:sister_staff_mobile/resource/profile-provider.dart';

part 'get_profile_instructor_event.dart';
part 'get_profile_instructor_state.dart';

class GetProfileInstructorBloc
    extends Bloc<GetProfileInstructorEvent, GetProfileInstructorState> {
  GetProfileInstructorBloc() : super(GetProfileInstructorInitial()) {
    on<GetProfileInstructorList>((event, emit) async {
      final _profileData = ProfileProvider();

      try {
        emit(GetProfileInstructorLoading());
        final result = await _profileData.fetchProfileInstructor();
        emit(GetProfileInstructorLoaded(result));
      } catch (e) {
        emit(GetProfileInstructorError(e.toString()));
      }
    });
  }
}
