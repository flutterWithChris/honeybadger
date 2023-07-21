part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  final User? user;
  const ProfileState({this.user});

  @override
  List<Object?> get props => [user];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;

  const ProfileLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileError extends ProfileState {
  final String errorMessage;

  const ProfileError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
