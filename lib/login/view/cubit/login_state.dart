part of 'login_cubit.dart';

enum LoginStatus { initial, submitting, success, error }

class LoginState extends Equatable {
  final LoginStatus status;
  final auth.User? user;

  const LoginState({
    this.status = LoginStatus.initial,
    this.user,
  });

  @override
  List<Object?> get props => [
        status,
        user,
      ];

  factory LoginState.initial() {
    return const LoginState();
  }

  LoginState copyWith({
    LoginStatus? status,
    auth.User? user,
  }) {
    return LoginState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }
}
