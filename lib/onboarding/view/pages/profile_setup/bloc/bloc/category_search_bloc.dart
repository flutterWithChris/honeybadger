import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:OutsourcedX/core/constants.dart';
import 'package:OutsourcedX/profile/model/category.dart';
import 'package:OutsourcedX/profile/portfolio/repository/category_repository.dart';
import 'package:OutsourcedX/search/repository/search_repository.dart';
part 'category_search_event.dart';
part 'category_search_state.dart';

class CategorySearchBloc
    extends Bloc<CategorySearchEvent, CategorySearchState> {
  final SearchRepository _searchRepository;
  final CategoryRepository _categoryRepository;
  CategorySearchBloc({
    required SearchRepository searchRepository,
    required CategoryRepository categoryRepository,
  })  : _searchRepository = searchRepository,
        _categoryRepository = categoryRepository,
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
    // on<ClearSearch>((event, emit) async {
    //   emit(CategorySearchLoading());
    //   try {
    //     await emit.forEach(_searchRepository.clearSearchResults('categories'),
    //         onData: (value) {
    //       return CategorySearchInitial();
    //     });
    //   } catch (e) {
    //     emit(CategorySearchError(message: e.toString()));
    //     scaffoldKey.currentState!.showSnackBar(
    //       const SnackBar(
    //         backgroundColor: Colors.red,
    //         behavior: SnackBarBehavior.floating,
    //         content: Text('Error clearing search...'),
    //       ),
    //     );
    //   }
    // });
    on<AddCategory>((event, emit) async {
      try {
        await _categoryRepository.createCategory(event.category.name!);

        scaffoldKey.currentState!.showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Category added!'),
          ),
        );
        emit(CategorySearchLoaded(
            categories: state.categories! + [event.category]));
      } catch (e) {
        emit(CategorySearchError(message: e.toString()));
        scaffoldKey.currentState!.showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            content: Text('Error adding category...'),
          ),
        );
      }
    });
  }
}
