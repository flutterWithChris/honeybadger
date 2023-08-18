part of 'freelancer_public_profile_bloc.dart';

sealed class FreelancerPublicProfileState extends Equatable {
  const FreelancerPublicProfileState();

  @override
  List<Object> get props => [];
}

final class FreelancerPublicProfileInitial
    extends FreelancerPublicProfileState {}

final class FreelancerPublicProfileLoading
    extends FreelancerPublicProfileState {}

final class FreelancerPublicProfileLoaded extends FreelancerPublicProfileState {
  final User user;

  const FreelancerPublicProfileLoaded(this.user);

  @override
  List<Object> get props => [user];
}

final class FreelancerPublicProfileError extends FreelancerPublicProfileState {
  final String message;

  const FreelancerPublicProfileError(this.message);

  @override
  List<Object> get props => [message];
}
