import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:honeybadger/projects/model/project.dart';
import 'package:honeybadger/projects/repository/projects_repository.dart';

part 'projects_event.dart';
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
  void _onLoadProjects(LoadProjects event, Emitter<ProjectsState> emit) {
    emit(ProjectsLoading());
    emit(const ProjectsLoaded([]));
  }

  void _onLoadProject(LoadProject event, Emitter<ProjectsState> emit) {
    emit(ProjectLoading());
    emit(const ProjectsLoaded([]));
  }

  void _onCreateProject(
      CreateProject event, Emitter<ProjectsState> emit) async {
    emit(ProjectSending(event.project));
    await _projectsRepository.createProject(event.project);
    await Future.delayed(const Duration(seconds: 2));
    emit(ProjectCreated(event.project));
    await Future.delayed(const Duration(seconds: 2));
    emit(const ProjectsLoaded([]));
  }

  void _onUpdateProject(
      UpdateProject event, Emitter<ProjectsState> emit) async {
    emit(ProjectsLoading());
    await Future.delayed(const Duration(seconds: 2));
    emit(ProjectUpdated(event.project));
  }
}
