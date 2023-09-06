import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:outsourcedx/auth/repository/auth_repository.dart';
import 'package:outsourcedx/profile/model/user.dart';
import 'package:outsourcedx/profile/repository/user_respository.dart';
import 'package:outsourcedx/settings/models/bug.dart';
import 'package:outsourcedx/settings/repository/bug_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final AuthRepository _authRepository;
  final BugRepository _bugRepository;
  final UserRepository _userRepository;
  SettingsCubit(
      {required AuthRepository authRepository,
      required BugRepository bugRepository,
      required UserRepository userRepository})
      : _authRepository = authRepository,
        _bugRepository = bugRepository,
        _userRepository = userRepository,
        super(SettingsInitial());
  void deleteAccount() async {
    emit(SettingsLoading());
    try {
      await _authRepository.deleteUser();
      emit(SettingsLoaded());
    } catch (e) {
      emit(SettingsError());
    }
  }

  void reportBug(Bug bug) async {
    emit(SettingsLoading());
    try {
      await _bugRepository.reportBug(bug);
      emit(SettingsLoaded());
    } catch (e) {
      emit(SettingsError());
    }
  }

  void updateName(String name) async {
    emit(SettingsLoading());
    try {
      await _userRepository.updateUser(
        User(firstName: name.split(' ')[0], lastName: name.split(' ')[1]),
      );
      emit(SettingsLoaded());
    } catch (e) {
      emit(SettingsError());
    }
  }

  void updateTitle(String title) async {
    emit(SettingsLoading());
    try {
      await _userRepository.updateUser(
        User(title: title),
      );
      emit(SettingsLoaded());
    } catch (e) {
      emit(SettingsError());
    }
  }

  void updateBio(String bio) async {
    emit(SettingsLoading());
    try {
      await _userRepository.updateUser(
        User(bio: bio),
      );
      emit(SettingsLoaded());
    } catch (e) {
      emit(SettingsError());
    }
  }

  void updateEmail(String email) async {
    emit(SettingsLoading());
    try {
      await _userRepository.updateUser(
        User(email: email),
      );
      emit(SettingsLoaded());
    } catch (e) {
      emit(SettingsError());
    }
  }

  void changeAddress(String address) async {
    emit(SettingsLoading());
    try {
      await _userRepository.updateUser(
        User(address: address),
      );
      emit(SettingsLoaded());
    } catch (e) {
      emit(SettingsError());
    }
  }
}
