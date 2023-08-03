part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class LoadSearch extends SearchEvent {
  final User user;
  final String? query;

  const LoadSearch(this.user, {this.query});

  @override
  List<Object?> get props => [user, query];
}

class SearchProjects extends SearchEvent {
  final String query;

  const SearchProjects(this.query);

  @override
  List<Object> get props => [query];
}

class SearchFreelancers extends SearchEvent {
  final String query;

  const SearchFreelancers(this.query);

  @override
  List<Object> get props => [query];
}

class SearchClear extends SearchEvent {}

class SearchLoadMore extends SearchEvent {
  final String query;

  const SearchLoadMore(this.query);

  @override
  List<Object> get props => [query];
}
