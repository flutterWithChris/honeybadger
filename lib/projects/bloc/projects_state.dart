part of 'projects_bloc.dart';

abstract class ProjectsState extends Equatable {
  final List<Project>? projects;
  final Project? project;
  const ProjectsState({this.projects, this.project});

  @override
  List<Object?> get props => [projects, project];
}

class ProjectsInitial extends ProjectsState {}

class ProjectsLoading extends ProjectsState {
  @override
  final List<Project>? projects;

  const ProjectsLoading({this.projects});

  @override
  List<Object?> get props => [projects];
}

class ProjectsLoaded extends ProjectsState {
  @override
  final List<Project> projects;

  const ProjectsLoaded(this.projects);

  @override
  List<Object> get props => [projects];
}

class ProjectSending extends ProjectsState {
  @override
  final Project project;

  const ProjectSending(this.project);

  @override
  List<Object> get props => [project];
}

class ProjectLoading extends ProjectsState {}

class ProjectCreated extends ProjectsState {
  @override
  final Project project;

  const ProjectCreated(this.project);

  @override
  List<Object> get props => [project];
}

class ProjectUpdated extends ProjectsState {
  @override
  final Project project;

  const ProjectUpdated(this.project);

  @override
  List<Object> get props => [project];
}

class ProjectDeleted extends ProjectsState {
  @override
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
