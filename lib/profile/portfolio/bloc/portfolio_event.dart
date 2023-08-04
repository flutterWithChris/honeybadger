part of 'portfolio_bloc.dart';

abstract class PortfolioEvent extends Equatable {
  final String? userId;
  final PortfolioProject? project;
  final List<XFile>? images;
  const PortfolioEvent({this.userId, this.project, this.images});

  @override
  List<Object?> get props => [userId, project, images];
}

class LoadPortfolio extends PortfolioEvent {
  @override
  final String userId;

  const LoadPortfolio({required this.userId}) : super(userId: userId);

  @override
  List<Object> get props => [userId];
}

class AddProject extends PortfolioEvent {
  @override
  final PortfolioProject project;
  @override
  final List<XFile> images;
  @override
  final String userId;

  const AddProject(
      {required this.project, required this.userId, required this.images});

  @override
  List<Object> get props => [project, userId];
}

class UpdateProject extends PortfolioEvent {
  @override
  final String userId;
  @override
  final PortfolioProject project;
  @override
  final List<XFile>? images;

  const UpdateProject(
      {required this.project, required this.userId, this.images});

  @override
  List<Object> get props => [project];
}

class DeleteProject extends PortfolioEvent {
  @override
  final PortfolioProject project;
  @override
  final String userId;

  const DeleteProject({required this.project, required this.userId});

  @override
  List<Object> get props => [project, userId];
}
