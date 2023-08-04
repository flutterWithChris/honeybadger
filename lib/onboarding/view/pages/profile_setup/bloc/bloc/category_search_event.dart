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

class ClearSearch extends CategorySearchEvent {}

class AddCategory extends CategorySearchEvent {
  final Category category;

  const AddCategory({required this.category});

  @override
  List<Object?> get props => [category];
}

class UpdateUserCategories extends CategorySearchEvent {
  final List<Category> categories;

  const UpdateUserCategories({required this.categories});

  @override
  List<Object?> get props => [categories];
}
