part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  final String? userId;
  const ProfileEvent({
    this.userId,
  });

  @override
  List<Object?> get props => [userId];
}

class LoadProfile extends ProfileEvent {
  @override
  final String userId;

  const LoadProfile({required this.userId});

  @override
  List<Object> get props => [userId];
}

class UpdateProfile extends ProfileEvent {
  final User user;

  const UpdateProfile({required this.user});

  @override
  List<Object> get props => [user];
}

class DeleteProfile extends ProfileEvent {
  final User user;

  const DeleteProfile({required this.user});

  @override
  List<Object> get props => [user];
}
