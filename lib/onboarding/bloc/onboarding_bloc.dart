import 'package:bloc/bloc.dart';
import 'package:honeybadger/profile/model/user.dart';
import 'package:meta/meta.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(OnboardingState.loading()) {
    on<StartOnboarding>((event, emit) {
      emit(OnboardingState.loaded(event.user));
    });
    on<UpdateUser>((event, emit) {
      emit(OnboardingState.loaded(event.user));
    });
  }
}
