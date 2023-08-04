part of 'skill_search_bloc.dart';

abstract class SkillSearchEvent extends Equatable {
  final String? query;
  final Skill? skill;
  const SkillSearchEvent({this.query, this.skill});

  @override
  List<Object?> get props => [query, skill];
}

class SearchSkills extends SkillSearchEvent {
  @override
  final String query;

  const SearchSkills({required this.query});

  @override
  List<Object> get props => [query];
}

class ClearSearch extends SkillSearchEvent {}

class AddSkill extends SkillSearchEvent {
  @override
  final Skill skill;

  const AddSkill({required this.skill});

  @override
  List<Object> get props => [skill];
}
