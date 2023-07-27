import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:honeybadger/auth/bloc/auth_bloc.dart';
import 'package:honeybadger/profile/model/user.dart';
import 'package:honeybadger/profile/repository/user_respository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;
  final AuthBloc _authBloc;
  StreamSubscription<AuthState>? _authSubscription;
  ProfileBloc({
    required UserRepository userRepository,
    required AuthBloc authBloc,
  })  : _userRepository = userRepository,
        _authBloc = authBloc,
        super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<DeleteProfile>(_onDeleteProfile);
    _authSubscription = _authBloc.stream.listen((state) {
      if (state.status == AuthStatus.authenticated) {
        add(LoadProfile(userId: state.user!.uid));
      }
    });
  }
  void _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final user = await _userRepository.getUser(event.userId);
      emit(ProfileLoaded(user));
    } catch (e) {
      print(e);
      emit(ProfileError(e.toString()));
    }
  }

  void _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      await _userRepository.updateUser(event.user);
      emit(ProfileLoaded(event.user));
    } catch (e) {
      print(e);
      emit(ProfileError(e.toString()));
    }
  }

  void _onDeleteProfile(DeleteProfile event, Emitter<ProfileState> emit) {
    emit(ProfileLoading());
    try {
      final user = event.user;
      emit(ProfileLoaded(user));
    } catch (e) {
      print(e);
      emit(ProfileError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    // TODO: implement close
    _authSubscription?.cancel();
    return super.close();
  }
}
