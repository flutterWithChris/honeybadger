part of 'category_search_bloc.dart';

abstract class CategorySearchEvent extends Equatable {
  final String? query;
  const CategorySearchEvent({this.query});

  @override
  List<Object?> get props => [query];
}

class SearchCategories extends CategorySearchEvent {
  @override
  final String query;

  const SearchCategories({required this.query});

  @override
  List<Object?> get props => [query];
}
