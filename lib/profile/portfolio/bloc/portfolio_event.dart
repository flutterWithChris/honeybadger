part of 'portfolio_bloc.dart';

abstract class PortfolioEvent extends Equatable {
  const PortfolioEvent();

  @override
  List<Object> get props => [];
}

class LoadPortfolio extends PortfolioEvent {}

class AddProject extends PortfolioEvent {
  final PortfolioProject project;

  const AddProject({required this.project});

  @override
  List<Object> get props => [project];
}

class UpdateProject extends PortfolioEvent {
  final PortfolioProject project;

  const UpdateProject({required this.project});

  @override
  List<Object> get props => [project];
}

class DeleteProject extends PortfolioEvent {
  final PortfolioProject project;

  const DeleteProject({required this.project});

  @override
  List<Object> get props => [project];
}
