part of 'projects_bloc.dart';

abstract class ProjectsState extends Equatable {
  const ProjectsState();

  @override
  List<Object> get props => [];
}

class ProjectsInitial extends ProjectsState {}

class ProjectsLoading extends ProjectsState {}

class ProjectsLoaded extends ProjectsState {
  final List<Project> projects;

  const ProjectsLoaded(this.projects);

  @override
  List<Object> get props => [projects];
}

class ProjectSending extends ProjectsState {
  final Project project;

  const ProjectSending(this.project);

  @override
  List<Object> get props => [project];
}

class ProjectLoading extends ProjectsState {}

class ProjectCreated extends ProjectsState {
  final Project project;

  const ProjectCreated(this.project);

  @override
  List<Object> get props => [project];
}

class ProjectUpdated extends ProjectsState {
  final Project project;

  const ProjectUpdated(this.project);

  @override
  List<Object> get props => [project];
}

class ProjectDeleted extends ProjectsState {
  final Project project;

  const ProjectDeleted(this.project);

  @override
  List<Object> get props => [project];
}

class ProjectsError extends ProjectsState {
  final String message;

  const ProjectsError(this.message);

  @override
  List<Object> get props => [message];
}
