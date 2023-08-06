part of 'onboarding_bloc.dart';

@immutable
abstract class OnboardingEvent {}

class StartOnboarding extends OnboardingEvent {
  final User user;
  StartOnboarding(this.user);
}

class UpdateUser extends OnboardingEvent {
  final User user;
  UpdateUser(this.user);
}

class CompleteOnboarding extends OnboardingEvent {}

class SetUserProfilePicture extends OnboardingEvent {
  final XFile profilePicture;
  final User user;
  SetUserProfilePicture(this.profilePicture, this.user);
}

class SetUserType extends OnboardingEvent {
  final UserType userType;
  SetUserType(this.userType);
}
