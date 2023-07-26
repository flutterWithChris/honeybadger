part of 'auth_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  final auth.User? user;
  final AuthStatus status;

  const AuthState({this.user, required this.status});

  factory AuthState.initial() => const AuthState(status: AuthStatus.unknown);

  AuthState copyWith({auth.User? user, AuthStatus? status}) {
    return AuthState(user: user ?? this.user, status: status ?? this.status);
  }

  factory AuthState.unknown() {
    return const AuthState(status: AuthStatus.unknown);
  }

  factory AuthState.authenticated({required auth.User user}) {
    return AuthState(user: user, status: AuthStatus.authenticated);
  }

  factory AuthState.unauthenticated() {
    return const AuthState(status: AuthStatus.unauthenticated);
  }

  @override
  List<Object?> get props => [user];
}
