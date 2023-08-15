import 'dart:async';

import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:OutsourcedX/profile/bloc/profile_bloc.dart';
import 'package:OutsourcedX/projects/model/project.dart';
import 'package:OutsourcedX/projects/repository/projects_repository.dart';
import 'package:OutsourcedX/search/repository/search_repository.dart';

import '../../profile/model/user.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository _searchRepository;
  final ProjectsRepository _projectsRepository;
  final ProfileBloc _profileBloc;
  StreamSubscription? _profileSubscription;
  final String _query = '';
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
      try {
        emit(SearchLoading());
        return;
        // TODO: Set default query to user's skills
        if (_profileBloc.state.user?.userType == UserType.freelancer) {
          _searchRepository.setQuery(event.query ?? '', 'projects');

          // Get search results, then fetch the projects or freelancers
          final value =
              await _searchRepository.getSearchResults('projects').first;

          List<String> projectIds = [];
          for (Hit hit in value.hits) {
            print('Hit found: ${hit.toString()}');
            projectIds.add(hit['objectID']);
          }
          print('Search Bloc received Project Ids: $projectIds');

          final projects =
              await _projectsRepository.getProjectsFromIdsFuture(projectIds);

          emit(SearchLoaded(projects: projects));
        } else {
          _searchRepository.setQuery(event.query ?? '', 'freelancers');

          final value =
              await _searchRepository.getSearchResults('freelancers').first;

          List<User> freelancers = [];

          for (Hit hit in value.hits) {
            print('Hit found: ${hit.toString()}');
            freelancers.add(User.fromAlgoliaSearch(hit));
          }

          emit(SearchLoaded(freelancers: freelancers));
          print('Search Bloc received Freelancer Ids: $freelancers');
        }
      } catch (e) {
        print('Search Bloc received Error: $e');
        emit(SearchError());
      }
    });
  }
}
