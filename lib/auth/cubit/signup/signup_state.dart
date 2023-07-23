part of 'signup_cubit.dart';

enum SignupStatus { initial, submitting, success, error }

class SignupState extends Equatable {
  final SignupStatus status;
  final auth.User? user;
  const SignupState({
    this.status = SignupStatus.initial,
    this.user,
  });

  factory SignupState.initial() {
    return const SignupState();
  }

  SignupState copyWith({
    SignupStatus? status,
    auth.User? user,
  }) {
    return SignupState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [status, user];
}
