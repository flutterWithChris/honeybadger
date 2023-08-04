import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/profile/model/category.dart';
import 'package:honeybadger/search/repository/search_repository.dart';
part 'category_search_event.dart';
part 'category_search_state.dart';

class CategorySearchBloc
    extends Bloc<CategorySearchEvent, CategorySearchState> {
  final SearchRepository _searchRepository;
  CategorySearchBloc({
    required SearchRepository searchRepository,
  })  : _searchRepository = searchRepository,
        super(CategorySearchInitial()) {
    on<SearchCategories>((event, emit) async {
      emit(CategorySearchLoading());
      try {
        _searchRepository.setQuery(event.query, 'categories');
        await emit.forEach(_searchRepository.getSearchResults('categories'),
            onData: (value) {
          List<Category> categories = [];
          for (var hit in value.hits) {
            categories.add(Category.fromAlgoliaSearch(hit));
          }
          print('Categories: $categories');
          return CategorySearchLoaded(categories: categories);
        });
      } catch (e) {
        emit(CategorySearchError(message: e.toString()));
        scaffoldKey.currentState!.showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            content: Text('Error searching categories...'),
          ),
        );
      }
    });
  }
}
