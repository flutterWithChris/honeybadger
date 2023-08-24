import 'package:outsourcedx/auth/repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  LoginCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(LoginState.initial());

  Future<void> loginWithGoogle() async {
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      auth.User? user = await _authRepository.signInWithGoogle();
      user != null
          ? emit(state.copyWith(status: LoginStatus.success, user: user))
          : emit(state.copyWith(status: LoginStatus.error));
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.error));
    }
  }

  Future<void> loginWithApple() async {
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      auth.User? user = await _authRepository.signInWithApple();
      user != null
          ? emit(state.copyWith(status: LoginStatus.success, user: user))
          : emit(state.copyWith(status: LoginStatus.error));
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.error));
    }
  }

  Future<void> loginWithGithub() async {
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      auth.User? user = await _authRepository.signInWithGitHub();
      user != null
          ? emit(state.copyWith(status: LoginStatus.success, user: user))
          : emit(state.copyWith(status: LoginStatus.error));
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.error));
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      auth.User? user = await _authRepository.logInWithEmailAndPassword(
          email: email, password: password);
      user != null
          ? emit(state.copyWith(status: LoginStatus.success, user: user))
          : emit(state.copyWith(status: LoginStatus.error));
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.error));
    }
  }

  // logout
  Future<void> logout() async {
    try {
      await _authRepository.signOut();
      emit(state.copyWith(status: LoginStatus.initial));
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.error));
    }
  }
}
