import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:outsourcedx/profile/model/user.dart';
import 'package:outsourcedx/profile/repository/user_respository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final UserRepository _userRepository;
  UserType? userType;
  OnboardingBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(OnboardingState.initial()) {
    on<StartOnboarding>((event, emit) async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        emit(OnboardingState.loading());
        // TODO: Reenable this
        // Check if user exists
        User? user = await _userRepository.getUser(event.user);
        if (user != null) {
          print('User exists');
          emit(OnboardingState.loaded(user));

          await prefs.setString(
              'userType', event.user.userType.toString().split('.').last);
        } else {
          print('User does not exist');
          //  TODO: ***Reenable this***
          await _userRepository.createUser(event.user);

          await prefs.setString(
              'userType', event.user.userType.toString().split('.').last);
          emit(OnboardingState.loaded(event.user));
        }
      } catch (e) {
        print(e);
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
    on<SetUserType>((event, emit) async {
      try {
        var previousState = state;
        emit(OnboardingState.loading());
        userType = event.userType;
        emit(OnboardingState.initial());
      } catch (e) {
        emit(OnboardingState.failure());
      }
    });
  }
}
