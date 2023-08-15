import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:OutsourcedX/auth/repository/auth_repository.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;
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
}
