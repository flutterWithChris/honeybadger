import 'dart:async';

import 'package:OutsourcedX/core/constants.dart';
import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:OutsourcedX/profile/bloc/profile_bloc.dart';
import 'package:OutsourcedX/projects/model/project.dart';
import 'package:OutsourcedX/projects/repository/projects_repository.dart';
import 'package:OutsourcedX/search/repository/search_repository.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import '../../profile/model/user.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository _searchRepository;
  final ProjectsRepository _projectsRepository;
  final ProfileBloc _profileBloc;
  StreamSubscription? _profileSubscription;
  final String _query = '';
  StreamSubscription<SearchResponse>? _searchSubscription;
  SearchBloc(
      {required ProjectsRepository projectsRepository,
      required SearchRepository searchRepository,
      required ProfileBloc profileBloc})
      : _projectsRepository = projectsRepository,
        _searchRepository = searchRepository,
        _profileBloc = profileBloc,
        super(SearchLoading()) {
    _profileSubscription = _profileBloc.stream.listen((profileState) {
      print('Search Bloc received Profile State: $state');
      if (profileState is ProfileLoaded && state is! SearchLoaded) {
        add(LoadSearch(profileState.user));
      }
    });
    on<LoadSearch>((event, emit) async {
      try {
        emit(SearchLoading());

        if (_profileBloc.state.user?.userType == UserType.freelancer) {
          _searchRepository.setQuery(event.query ?? '', 'projects');
          final searchStream = _searchRepository.getSearchResults('projects');

          final projectsStream = searchStream.switchMap((searchResponse) {
            final projectIds = searchResponse.hits
                .map<String>((hit) => hit['objectID'] as String)
                .toList();

            return _projectsRepository
                .getProjectsFromIds(projectIds)
                .map((projects) {
              return Tuple2(searchResponse,
                  projects); // Combine searchResponse and projects
            });
          });

          final combinedStream = Rx.combineLatest2(
            searchStream,
            projectsStream,
            (SearchResponse searchResponse,
                Tuple2<SearchResponse, List<Project>> tuple) {
              final projects = tuple.item2; // Extract projects from the tuple
              final projectList = projects.map((project) {
                return Project.fromAlgoliaSearch(tuple.item1.hits
                    .firstWhere((hit) => hit['objectID'] == project.id));
              }).toList();
              return projectList;
            },
          );
          await emit.forEach(
            combinedStream,
            onData: (data) {
              print('Search Bloc received Data: $data');
              return SearchLoaded(projects: data);
            },
            onError: (e, s) {
              print('Search Bloc received Error: $e');
              scaffoldKey.currentState?.showSnackBar(
                const SnackBar(
                  content: Text('Error loading search results'),
                ),
              );
              return SearchError();
            },
          );
        } else {
          // Handle the case for freelancers here
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
  dispose() {
    _profileSubscription?.cancel();
    _searchSubscription?.cancel();
    super.close();
  }
}
