import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:honeybadger/profile/model/user.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<DeleteProfile>(_onDeleteProfile);
  }
  void _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) {
    emit(ProfileLoading());
    try {
      final user = User(
        id: 'honeybadger',
        firstName: 'Christian',
        lastName: 'Vergara',
        email: 'christian@email.com',
        userType: UserType.freelancer,
      );
      emit(ProfileLoaded(user));
    } catch (e) {
      print(e);
      emit(ProfileError(e.toString()));
    }
  }

  void _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) {
    emit(ProfileLoading());
    try {
      final user = event.user;
      emit(ProfileLoaded(user));
    } catch (e) {
      print(e);
      emit(ProfileError(e.toString()));
    }
  }

  void _onDeleteProfile(DeleteProfile event, Emitter<ProfileState> emit) {
    emit(ProfileLoading());
    try {
      final user = event.user;
      emit(ProfileLoaded(user));
    } catch (e) {
      print(e);
      emit(ProfileError(e.toString()));
    }
  }
}
