import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:honeybadger/profile/model/user.dart';
import 'package:honeybadger/projects/model/project.dart';
import 'package:honeybadger/projects/repository/projects_repository.dart';

part 'rojects_event.dart';
part 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  Project project = Project();
  final ProjectsRepository _projectsRepository;
  ProjectsBloc({
    required ProjectsRepository projectsRepository,
  })  : _projectsRepository = projectsRepository,
        super(ProjectsInitial()) {
    on<LoadProjects>(_onLoadProjects);
    on<LoadProject>(_onLoadProject);
    on<CreateProject>(_onCreateProject);
    on<UpdateProject>(_onUpdateProject);
  }
  void _onLoadProjects(LoadProjects event, Emitter<ProjectsState> emit) async {
    emit(ProjectsLoading());
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
    emit(ProjectsLoading());
    await Future.delayed(const Duration(seconds: 2));
    emit(ProjectUpdated(event.project));
  }
}
