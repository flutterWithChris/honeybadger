part of 'freelancer_public_profile_bloc.dart';

sealed class FreelancerPublicProfileEvent extends Equatable {
  const FreelancerPublicProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadFreelancerPublicProfile extends FreelancerPublicProfileEvent {
  final String userId;

  const LoadFreelancerPublicProfile(this.userId);

  @override
  List<Object> get props => [userId];
}
