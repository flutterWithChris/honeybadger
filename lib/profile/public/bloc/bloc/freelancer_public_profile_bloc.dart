import 'package:outsourcedx/profile/model/user.dart';
import 'package:outsourcedx/profile/repository/user_respository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'freelancer_public_profile_event.dart';
part 'freelancer_public_profile_state.dart';

class FreelancerPublicProfileBloc
    extends Bloc<FreelancerPublicProfileEvent, FreelancerPublicProfileState> {
  final UserRepository _userRepository;
  FreelancerPublicProfileBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(FreelancerPublicProfileInitial()) {
    on<LoadFreelancerPublicProfile>(_onLoadFreelancerPublicProfile);
  }
  void _onLoadFreelancerPublicProfile(LoadFreelancerPublicProfile event,
      Emitter<FreelancerPublicProfileState> emit) async {
    emit(FreelancerPublicProfileLoading());
    try {
      final user = await _userRepository.getFreelancerFromId(event.userId);
      user == null
          ? emit(const FreelancerPublicProfileError('User not found'))
          : emit(FreelancerPublicProfileLoaded(user));
    } catch (e) {
      print(e);
      emit(FreelancerPublicProfileError(e.toString()));
    }
  }
}
