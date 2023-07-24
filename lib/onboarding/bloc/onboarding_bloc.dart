import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:honeybadger/profile/model/user.dart';
import 'package:honeybadger/profile/repository/user_respository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final UserRepository _userRepository;
  UserType userType = UserType.freelancer;
  OnboardingBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(OnboardingState.initial()) {
    on<StartOnboarding>((event, emit) async {
      try {
        emit(OnboardingState.loading());
        await _userRepository.createUser(event.user);
        emit(OnboardingState.loaded(event.user));
      } catch (e) {
        emit(OnboardingState.failure());
      }
    });
    on<UpdateUser>((event, emit) async {
      try {
        emit(OnboardingState.loading());
        await _userRepository.updateUser(event.user);
        emit(OnboardingState.loaded(event.user));
      } catch (e) {
        emit(OnboardingState.failure());
      }
    });
    on<SetUserProfilePicture>((event, emit) async {
      emit(OnboardingState.loading());
      try {
        String? profilePictureUrl = await _userRepository.setUserProfilePicture(
            event.profilePicture, event.user);
        profilePictureUrl != null
            ? emit(OnboardingState.loaded(event.user.copyWith(
                photoUrl: profilePictureUrl,
              )))
            : emit(OnboardingState.failure());
      } catch (e) {
        emit(OnboardingState.failure());
      }
    });
  }
}
