part of 'signup_cubit.dart';

enum SignupStatus { initial, submitting, success, error }

class SignupState extends Equatable {
  final SignupStatus status;
  final auth.User? user;
  final String? email;
  final String? password;
  const SignupState({
    this.status = SignupStatus.initial,
    this.user,
    this.email,
    this.password,
  });

  factory SignupState.initial() {
    return const SignupState();
  }

  SignupState copyWith({
    SignupStatus? status,
    auth.User? user,
    String? email,
    String? password,
  }) {
    return SignupState(
      status: status ?? this.status,
      user: user ?? this.user,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [status, user, email, password];
}
