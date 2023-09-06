import 'dart:async';

import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:outsourcedx/profile/bloc/profile_bloc.dart';
import 'package:outsourcedx/projects/model/project.dart';
import 'package:outsourcedx/projects/repository/projects_repository.dart';
import 'package:outsourcedx/search/repository/search_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../profile/model/user.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository _searchRepository;
  final ProjectsRepository _projectsRepository;
  final ProfileBloc _profileBloc;
  StreamSubscription? _profileSubscription;
  static String? _query;
  StreamSubscription<SearchResponse>? _searchSubscription;
  StreamSubscription<List<Project>>? projectsSubscription;
  StreamSubscription<SearchResponse>? reloadSubscription;
  SearchBloc(
      {required ProjectsRepository projectsRepository,
      required SearchRepository searchRepository,
      required ProfileBloc profileBloc})
      : _projectsRepository = projectsRepository,
        _searchRepository = searchRepository,
        _profileBloc = profileBloc,
        super(SearchLoading()) {
    _profileSubscription = _profileBloc.stream.listen((profileState) {
      if (profileState is ProfileLoaded && state is! SearchLoaded) {
        add(LoadSearch(profileState.user));
      }
    });
    on<ReloadSearch>((event, emit) async {
      emit(SearchLoading());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userType = prefs.getString('userType');
      _profileBloc.state.user?.userType == UserType.client
          ? _searchRepository.reload('freelancers')
          : _searchRepository.reload('projects');
    });
    on<LoadSearch>((event, emit) async {
      try {
        emit(SearchLoading());

        if (_profileBloc.state.user?.userType == UserType.freelancer) {
          if (event.query != null &&
              event.query!.isNotEmpty &&
              event.query == _query) {
            _searchRepository.reload('projects');
            return;
          }
          final searchQuery = event.query ?? '';

          _searchRepository.setQuery(searchQuery, 'projects');

          final searchStream = _searchRepository.getSearchResults('projects');
          final projectsStream = searchStream.switchMap((searchResponse) {
            final projectIds = searchResponse.hits.map<String>((hit) {
              // Check if hit contains null values for fields used in freelancer card
              if (hit['title'] == null ||
                  hit['description'] == null ||
                  hit['skills'] == null ||
                  hit['budget'] == null ||
                  hit['deadline'] == null ||
                  hit['objectID'] == null) {
                return '';
              }
              return hit['objectID'] as String;
            }).toList();

            return _projectsRepository
                .getProjectsFromIds(projectIds)
                .startWith([]);
          });
          await emit.forEach(projectsStream, onData: (projects) {
            _query = event.query;
            return SearchLoaded(projects: projects);
          });
          // projectsStream.listen((projects) {
          //   emit(SearchLoaded(projects: projects));
          // });
        } else {
          // Handle the case for freelancers here
          if (event.query != null &&
              event.query!.isNotEmpty &&
              event.query == _query) {
            _searchRepository.reload('freelancers');
            return;
          }
          _searchRepository.setQuery(event.query ?? '', 'freelancers');

          await emit.forEach(
            _searchRepository.getSearchResults('freelancers'),
            onData: (value) {
              List<User> freelancers = [];
              for (Hit hit in value.hits) {
                // Check if hit contains null values for fields used in freelancer card
                if (hit['firstName'] == null ||
                    hit['lastName'] == null ||
                    hit['photoUrl'] == null) {
                  continue;
                }
                freelancers.add(User.fromAlgoliaSearch(hit));
              }
              return SearchLoaded(freelancers: freelancers);
            },
          );
        }
      } catch (e) {
        emit(SearchError());
      }
    });
  }
  dispose() {
    _profileSubscription?.cancel();
    _searchSubscription?.cancel();
    projectsSubscription?.cancel();
    reloadSubscription?.cancel();
    super.close();
  }
}
