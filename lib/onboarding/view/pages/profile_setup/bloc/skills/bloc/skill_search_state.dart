part of 'skill_search_bloc.dart';

abstract class SkillSearchState extends Equatable {
  final List<Skill>? skills;
  const SkillSearchState({this.skills});

  @override
  List<Object?> get props => [skills];
}

class SkillSearchInitial extends SkillSearchState {}

class SkillSearchLoading extends SkillSearchState {}

class SkillSearchSuccess extends SkillSearchState {
  @override
  final List<Skill> skills;

  const SkillSearchSuccess({required this.skills});

  @override
  List<Object> get props => [skills];
}

class SkillSearchFailure extends SkillSearchState {}

class SkillSearchEmpty extends SkillSearchState {}

class SkillSearchAdded extends SkillSearchState {
  final Skill skill;

  const SkillSearchAdded({required this.skill});

  @override
  List<Object> get props => [skill];
}
