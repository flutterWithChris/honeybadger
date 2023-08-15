import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:OutsourcedX/core/constants.dart';
import 'package:OutsourcedX/profile/model/skill.dart';
import 'package:OutsourcedX/profile/portfolio/repository/skills_repository.dart';
import 'package:OutsourcedX/search/repository/search_repository.dart';

part 'skill_search_event.dart';
part 'skill_search_state.dart';

class SkillSearchBloc extends Bloc<SkillSearchEvent, SkillSearchState> {
  final SearchRepository _searchRepository;
  final SkillsRepository _skillsRepository;
  SkillSearchBloc({
    required SearchRepository searchRepository,
    required SkillsRepository skillsRepository,
  })  : _searchRepository = searchRepository,
        _skillsRepository = skillsRepository,
        super(SkillSearchInitial()) {
    on<SearchSkills>((event, emit) async {
      emit(SkillSearchLoading());
      try {
        List<Skill> skills = [];
        _searchRepository.setQuery(event.query, 'skills');
        await emit.forEach(_searchRepository.getSearchResults('skills'),
            onData: (value) {
          for (var hit in value.hits) {
            skills.add(Skill.fromAlgoliaSearch(algoliaSearch: hit));
          }
          print('Skills: $skills');

          return SkillSearchSuccess(skills: skills);
        });
      } catch (e) {
        emit(SkillSearchFailure());
        scaffoldKey.currentState!.showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            content: Text('Error searching skills...'),
          ),
        );
      }
    });
    // on<ClearSearch>((event, emit) async {
    //   emit(SkillSearchLoading());
    //   try {
    //     await emit.forEach(_searchRepository.clearSearchResults('skills'),
    //         onData: (value) {
    //       return SkillSearchInitial();
    //     });
    //   } catch (e) {
    //     emit(SkillSearchFailure());
    //     scaffoldKey.currentState!.showSnackBar(
    //       const SnackBar(
    //         backgroundColor: Colors.red,
    //         behavior: SnackBarBehavior.floating,
    //         content: Text('Error clearing search...'),
    //       ),
    //     );
    //   }
    // });
    on<AddSkill>((event, emit) async {
      try {
        await _skillsRepository.createSkill(event.skill);
        emit(SkillSearchSuccess(skills: state.skills! + [event.skill]));
        scaffoldKey.currentState!.showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Skill added!'),
          ),
        );
      } catch (e) {
        print(e);
        emit(SkillSearchFailure());
        scaffoldKey.currentState!.showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            content: Text('Error adding skill...'),
          ),
        );
      }
    });
  }
}
