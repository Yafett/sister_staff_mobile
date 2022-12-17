import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sister_staff_mobile/models/User-model.dart';
import 'package:sister_staff_mobile/resource/profile-provider.dart';

part 'get_profile_user_event.dart';
part 'get_profile_user_state.dart';

class GetProfileUserBloc
    extends Bloc<GetProfileUserEvent, GetProfileUserState> {
  GetProfileUserBloc() : super(GetProfileUserInitial()) {
    final _profileProvider = ProfileProvider();

    on<GetProfileUserList>((event, emit) async {
      try {
        emit(GetProfileUserLoading());
        final result = await _profileProvider.fetchProfile('');
        emit(GetProfileUserLoaded(result));
      } catch (e) {
        emit(GetProfileUserError(e.toString()));
      }
    });
  }
}
