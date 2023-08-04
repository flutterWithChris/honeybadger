part of 'portfolio_bloc.dart';

abstract class PortfolioState extends Equatable {
  final List<PortfolioProject>? projects;

  const PortfolioState({this.projects});

  @override
  List<Object?> get props => [projects];
}

class PortfolioInitial extends PortfolioState {}

class PortfolioLoading extends PortfolioState {}

class PortfolioLoaded extends PortfolioState {
  @override
  final List<PortfolioProject> projects;

  const PortfolioLoaded({required this.projects});

  @override
  List<Object?> get props => [projects];
}

class PortfolioError extends PortfolioState {
  final String message;

  const PortfolioError({required this.message});

  @override
  List<Object?> get props => [message];
}

class PortfolioUpdated extends PortfolioState {}
