part of 'onboarding_bloc.dart';

enum OnboardingStatus { initial, loading, loaded, failure }

@immutable
class OnboardingState extends Equatable {
  final OnboardingStatus status;
  final User? user;
  UserType? userType;
  OnboardingState({required this.status, this.user, this.userType});

  factory OnboardingState.initial() {
    return OnboardingState(
        status: OnboardingStatus.initial, userType: UserType.freelancer);
  }

  factory OnboardingState.loading() {
    return OnboardingState(status: OnboardingStatus.loading);
  }

  factory OnboardingState.loaded(User user) {
    return OnboardingState(status: OnboardingStatus.loaded, user: user);
  }

  factory OnboardingState.failure() {
    return OnboardingState(status: OnboardingStatus.failure);
  }

  OnboardingState copyWith({
    OnboardingStatus? status,
    User? user,
    UserType? userType,
  }) {
    return OnboardingState(
      status: status ?? this.status,
      user: user ?? this.user,
      userType: userType ?? this.userType,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [status, user];
}
