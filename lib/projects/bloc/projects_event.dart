part of 'projects_bloc.dart';

abstract class ProjectsEvent {
  final Project? project;
  const ProjectsEvent({this.project});

  @override
  List<Object> get props => [];
}

class LoadProjects extends ProjectsEvent {}

class LoadProject extends ProjectsEvent {
  final String projectId;

  const LoadProject({required this.projectId});

  @override
  List<Object> get props => [projectId];
}

class CreateProject extends ProjectsEvent {
  @override
  @override
  @override
  final Project project;

  const CreateProject({required this.project});

  @override
  List<Object> get props => [project];
}

class UpdateProject extends ProjectsEvent {
  @override
  @override
  @override
  final Project project;

  const UpdateProject({required this.project});

  @override
  List<Object> get props => [project];
}
