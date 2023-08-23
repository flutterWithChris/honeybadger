part of 'login_cubit.dart';

enum LoginStatus { initial, submitting, success, error }

class LoginState extends Equatable {
  final LoginStatus status;
  final auth.User? user;
  final String? email;
  final String? password;

  const LoginState({
    this.status = LoginStatus.initial,
    this.user,
    this.email,
    this.password,
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
    String? email,
    String? password,
  }) {
    return LoginState(
      status: status ?? this.status,
      user: user ?? this.user,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
