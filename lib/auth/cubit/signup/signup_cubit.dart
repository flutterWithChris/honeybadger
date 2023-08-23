import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:outsourcedx/auth/repository/auth_repository.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;
  String? email;
  String? password;
  SignupCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SignupState.initial());

  Future<void> signupWithGoogle() async {
    emit(state.copyWith(status: SignupStatus.submitting));
    try {
      auth.User? user = await _authRepository.signInWithGoogle();
      user != null
          ? emit(state.copyWith(status: SignupStatus.success, user: user))
          : emit(state.copyWith(status: SignupStatus.error));
    } on auth.FirebaseAuthException {
      emit(state.copyWith(status: SignupStatus.error));
    }
  }

  Future<void> signupWithApple() async {
    emit(state.copyWith(status: SignupStatus.submitting));
    try {
      auth.User? user = await _authRepository.signInWithApple();
      user != null
          ? emit(state.copyWith(status: SignupStatus.success, user: user))
          : emit(state.copyWith(status: SignupStatus.error));
    } on auth.FirebaseAuthException {
      emit(state.copyWith(status: SignupStatus.error));
    }
  }

  Future<void> signupWithGithub() async {
    emit(state.copyWith(status: SignupStatus.submitting));
    try {
      auth.User? user = await _authRepository.signInWithGitHub();
      user != null
          ? emit(state.copyWith(status: SignupStatus.success, user: user))
          : emit(state.copyWith(status: SignupStatus.error));
    } on auth.FirebaseAuthException {
      emit(state.copyWith(status: SignupStatus.error));
    }
  }

  // Change the email value
  void emailChanged(String value) {
    emit(state.copyWith(email: value));
  }

  // Change the password value
  void passwordChanged(String value) {
    emit(state.copyWith(password: value));
  }

  Future<void> signupWithEmailAndPassword() async {
    emit(state.copyWith(status: SignupStatus.submitting));
    try {
      auth.User? user = await _authRepository.signUpWithEmailAndPassword(
          state.email!, state.password!);
      user != null
          ? emit(state.copyWith(status: SignupStatus.success, user: user))
          : emit(state.copyWith(status: SignupStatus.error));
    } on auth.FirebaseAuthException {
      emit(state.copyWith(status: SignupStatus.error));
    }
  }
}
