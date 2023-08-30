import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial());
  void loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var themeMode = prefs.getString('themeMode') ?? 'system';
    emit(ThemeLoaded(
        themeMode: themeMode == 'light'
            ? ThemeMode.light
            : themeMode == 'dark'
                ? ThemeMode.dark
                : ThemeMode.system));
  }

  void changeBrightness(ThemeMode themeMode) {
    SharedPreferences.getInstance().then((value) =>
        value.setString('themeMode', themeMode.toString().split('.').last));
    emit(ThemeLoaded(themeMode: themeMode));
  }
}
