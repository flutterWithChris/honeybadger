import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:outsourcedx/auth/repository/auth_repository.dart';
import 'package:outsourcedx/settings/models/bug.dart';
import 'package:outsourcedx/settings/repository/bug_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final AuthRepository _authRepository;
  final BugRepository _bugRepository;
  SettingsCubit(
      {required AuthRepository authRepository,
      required BugRepository bugRepository})
      : _authRepository = authRepository,
        _bugRepository = bugRepository,
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
}
