part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  final List<Project>? projects;
  final List<User>? freelancers;
  const SearchState({this.projects, this.freelancers});

  @override
  List<Object?> get props => [projects, freelancers];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  @override
  final List<Project>? projects;
  @override
  final List<User>? freelancers;

  const SearchLoaded({this.projects, this.freelancers});

  @override
  List<Object?> get props => [projects, freelancers];
}

class SearchError extends SearchState {}
