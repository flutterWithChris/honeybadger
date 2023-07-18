part of 'proposal_bloc.dart';

abstract class ProposalState extends Equatable {
  final Proposal? proposal;
  const ProposalState({this.proposal});

  @override
  List<Object?> get props => [proposal];
}

class ProposalLoading extends ProposalState {}

class ProposalLoaded extends ProposalState {
  @override
  final Proposal? proposal;

  const ProposalLoaded(this.proposal);

  @override
  List<Object?> get props => [proposal];
}

class ProposalsError extends ProposalState {}

class ProposalStarted extends ProposalState {
  @override
  final Proposal? proposal;

  const ProposalStarted({this.proposal});

  @override
  List<Object?> get props => [proposal];
}

class ProposalSaving extends ProposalState {
  @override
  final Proposal? proposal;

  const ProposalSaving({this.proposal});

  @override
  List<Object?> get props => [proposal];
}

class ProposalSaved extends ProposalState {
  @override
  final Proposal proposal;

  const ProposalSaved(this.proposal);

  @override
  List<Object?> get props => [proposal];
}

class ProposalSent extends ProposalState {
  @override
  final Proposal proposal;

  const ProposalSent(this.proposal);

  @override
  List<Object?> get props => [proposal];
}

class ProposalUpdated extends ProposalState {
  @override
  final Proposal proposal;

  const ProposalUpdated(this.proposal);

  @override
  List<Object?> get props => [proposal];
}

class ProposalDeleted extends ProposalState {
  @override
  final Proposal? proposal;

  const ProposalDeleted(this.proposal);

  @override
  List<Object?> get props => [proposal];
}

class ProposalSelected extends ProposalState {
  @override
  final Proposal proposal;

  const ProposalSelected(this.proposal);

  @override
  List<Object?> get props => [proposal];
}

class ProposalUnselected extends ProposalState {}
