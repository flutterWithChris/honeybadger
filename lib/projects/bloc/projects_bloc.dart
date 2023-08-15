import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:OutsourcedX/profile/bloc/profile_bloc.dart';
import 'package:OutsourcedX/profile/model/user.dart';
import 'package:OutsourcedX/projects/model/project.dart';
import 'package:OutsourcedX/projects/repository/projects_repository.dart';

part 'rojects_event.dart';
part 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  Project project = Project();
  final ProfileBloc _profileBloc;
  StreamSubscription? _profileSubscription;
  final ProjectsRepository _projectsRepository;
  ProjectsBloc({
    required ProjectsRepository projectsRepository,
    required ProfileBloc profileBloc,
  })  : _projectsRepository = projectsRepository,
        _profileBloc = profileBloc,
        super(ProjectsInitial()) {
    _profileSubscription = _profileBloc.stream.listen((state) {
      print('Projects Bloc received Profile State: $state');
      if (state is ProfileLoaded) {
        add(LoadProjects(user: state.user));
      }
    });
    on<LoadProjects>(_onLoadProjects);
    on<LoadProject>(_onLoadProject);
    on<CreateProject>(_onCreateProject);
    on<UpdateProject>(_onUpdateProject);
  }
  void _onLoadProjects(LoadProjects event, Emitter<ProjectsState> emit) async {
    emit(ProjectsLoading(projects: state.projects));
    await emit.forEach(_projectsRepository.getProjects(event.user),
        onData: (data) {
      print('Projects Bloc received Projects State: $data');
      return ProjectsLoaded(data);
    }, onError: (error, stackTrace) {
      return ProjectsError(error.toString());
    });
  }

  void _onLoadProject(LoadProject event, Emitter<ProjectsState> emit) {
    emit(ProjectLoading());
    emit(const ProjectsLoaded([]));
  }

  void _onCreateProject(
      CreateProject event, Emitter<ProjectsState> emit) async {
    emit(ProjectSending(event.project));
    String? newProjectId =
        await _projectsRepository.createProject(event.project);
    if (newProjectId == null) {
      emit(const ProjectsError('Error creating project'));
      return;
    }
    await _projectsRepository.createProjectReference(event.user, newProjectId);
    await Future.delayed(const Duration(seconds: 2));
    emit(ProjectCreated(event.project));
  }

  void _onUpdateProject(
      UpdateProject event, Emitter<ProjectsState> emit) async {
    emit(const ProjectsLoading());
    await Future.delayed(const Duration(seconds: 2));
    emit(ProjectUpdated(event.project));
  }
}
