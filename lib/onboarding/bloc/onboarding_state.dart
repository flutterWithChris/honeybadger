part of 'onboarding_bloc.dart';

enum OnboardingStatus { initial, loading, loaded, failure }

@immutable
class OnboardingState extends Equatable {
  final OnboardingStatus status;
  final User? user;
  const OnboardingState({required this.status, this.user});

  factory OnboardingState.initial() {
    return const OnboardingState(status: OnboardingStatus.initial);
  }

  factory OnboardingState.loading() {
    return const OnboardingState(status: OnboardingStatus.loading);
  }

  factory OnboardingState.loaded(User user) {
    return OnboardingState(status: OnboardingStatus.loaded, user: user);
  }

  factory OnboardingState.failure() {
    return const OnboardingState(status: OnboardingStatus.failure);
  }

  OnboardingState copyWith({
    OnboardingStatus? status,
    User? user,
  }) {
    return OnboardingState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [status, user];
}
