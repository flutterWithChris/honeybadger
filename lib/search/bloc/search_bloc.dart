import 'dart:async';

import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:honeybadger/profile/bloc/profile_bloc.dart';
import 'package:honeybadger/projects/model/project.dart';
import 'package:honeybadger/projects/repository/projects_repository.dart';
import 'package:honeybadger/search/repository/search_repository.dart';

import '../../profile/model/user.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository _searchRepository;
  final ProjectsRepository _projectsRepository;
  final ProfileBloc _profileBloc;
  StreamSubscription? _profileSubscription;
  SearchBloc(
      {required ProjectsRepository projectsRepository,
      required SearchRepository searchRepository,
      required ProfileBloc profileBloc})
      : _projectsRepository = projectsRepository,
        _searchRepository = searchRepository,
        _profileBloc = profileBloc,
        super(SearchLoading()) {
    _profileSubscription = _profileBloc.stream.listen((state) {
      print('Search Bloc received Profile State: $state');
      if (state is ProfileLoaded) {
        add(LoadSearch(state.user));
      }
    });
    on<LoadSearch>((event, emit) async {
      emit(SearchLoading());
      // TODO: Set default query to user's skills
      _searchRepository.setQuery('', 'projects');

      // Get search results, then fetch the projects or freelancers
      final value = await _searchRepository.getSearchResults('projects').first;

      List<String> projectIds = [];
      for (Hit hit in value.hits) {
        print('Hit found: ${hit.toString()}');
        projectIds.add(hit['objectID']);
      }
      print('Search Bloc received Project Ids: $projectIds');

      await emit.forEach(_projectsRepository.getProjectsFromIds(projectIds),
          onData: (data) {
        print('Search Bloc received Projects: $data');
        return SearchLoaded(projects: data);
      }, onError: (error, stackTrace) {
        return SearchError();
      });
    });
  }
}
