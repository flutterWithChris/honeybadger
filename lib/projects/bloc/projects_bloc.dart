import 'package:bloc/bloc.dart';
import 'package:honeybadger/projects/model/project.dart';
import 'package:equatable/equatable.dart';

part 'projects_event.dart';
part 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  ProjectsBloc() : super(ProjectsInitial()) {
    on<LoadProjects>(_onLoadProjects);
    on<LoadProject>(_onLoadProject);
    on<CreateProject>(_onCreateProject);
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
    emit(ProjectsLoading());
    await Future.delayed(const Duration(seconds: 2));
    emit(ProjectCreated(event.project));
  }
}
