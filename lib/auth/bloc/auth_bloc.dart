import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:outsourcedx/auth/repository/auth_repository.dart';
import 'package:outsourcedx/core/router/app_router.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<auth.User?>? _authUserSubscription;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthState.unknown()) {
    on<AuthUserChanged>(_onAuthUserChanged);

    _authUserSubscription = _authRepository.user.listen((user) {
      add(AuthUserChanged(user: user));
    });
  }

  void _onAuthUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    emit(event.user != null
        ? AuthState.authenticated(user: event.user!)
        : AuthState.unauthenticated());

    goRouter.refresh();
  }

  @override
  Future<void> close() {
    // TODO: implement close
    _authUserSubscription?.cancel();
    return super.close();
  }
}
