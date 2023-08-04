part of 'category_search_bloc.dart';

abstract class CategorySearchState extends Equatable {
  final String? query;
  final List<Category>? categories;
  const CategorySearchState({this.query, this.categories});

  @override
  List<Object?> get props => [query, categories];
}

class CategorySearchInitial extends CategorySearchState {}

class CategorySearchLoading extends CategorySearchState {}

class CategorySearchLoaded extends CategorySearchState {
  @override
  final List<Category> categories;

  const CategorySearchLoaded({required this.categories});

  @override
  List<Object> get props => [categories];
}

class CategorySearchError extends CategorySearchState {
  final String message;

  const CategorySearchError({required this.message});

  @override
  List<Object> get props => [message];
}
