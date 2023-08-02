part of 'projects_bloc.dart';

abstract class ProjectsEvent {
  const ProjectsEvent();

  @override
  List<Object> get props => [];
}

class LoadProjects extends ProjectsEvent {
  final User user;

  const LoadProjects({required this.user});

  @override
  List<Object> get props => [user];
}

class LoadProject extends ProjectsEvent {
  final String projectId;

  const LoadProject({required this.projectId});

  @override
  List<Object> get props => [projectId];
}

class CreateProject extends ProjectsEvent {
  @override
  final Project project;
  final User user;

  const CreateProject({required this.project, required this.user});

  @override
  List<Object> get props => [project, user];
}

class UpdateProject extends ProjectsEvent {
  @override
  final Project project;

  const UpdateProject({required this.project});

  @override
  List<Object> get props => [project];
}

class DeleteProject extends ProjectsEvent {
  final String projectId;
  final User user;

  const DeleteProject({required this.projectId, required this.user});

  @override
  List<Object> get props => [projectId, user];
}

class LoadProjectReference extends ProjectsEvent {
  final String projectId;

  const LoadProjectReference({required this.projectId});

  @override
  List<Object> get props => [projectId];
}

class CreateProjectReference extends ProjectsEvent {
  final Project project;
  final User user;

  const CreateProjectReference({required this.project, required this.user});

  @override
  List<Object> get props => [project, user];
}

class UpdateProjectReference extends ProjectsEvent {
  final Project project;

  const UpdateProjectReference({required this.project});

  @override
  List<Object> get props => [project];
}

class DeleteProjectReference extends ProjectsEvent {
  final String projectId;
  final User user;

  const DeleteProjectReference({required this.projectId, required this.user});

  @override
  List<Object> get props => [projectId, user];
}
