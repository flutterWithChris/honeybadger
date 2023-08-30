part of 'theme_cubit.dart';

sealed class ThemeState extends Equatable {
  final ThemeMode? themeMode;
  const ThemeState({this.themeMode});

  @override
  List<Object?> get props => [themeMode];
}

final class ThemeInitial extends ThemeState {}

class ThemeLoaded extends ThemeState {
  @override
  final ThemeMode? themeMode;

  const ThemeLoaded({this.themeMode});

  @override
  List<Object?> get props => [themeMode];
}
