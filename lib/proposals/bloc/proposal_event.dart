part of 'proposal_bloc.dart';

abstract class ProposalsEvent extends Equatable {
  const ProposalsEvent();

  @override
  List<Object?> get props => [];
}

class LoadProposal extends ProposalsEvent {
  final String jobId;

  const LoadProposal(this.jobId);
}

class StartProposal extends ProposalsEvent {
  final String jobId;

  const StartProposal(this.jobId);

  @override
  List<Object?> get props => [jobId];
}

class AutoSaveProposal extends ProposalsEvent {
  final Proposal proposal;

  const AutoSaveProposal(this.proposal);

  @override
  List<Object?> get props => [proposal];
}

class SendProposal extends ProposalsEvent {
  final Proposal proposal;

  const SendProposal(this.proposal);

  @override
  List<Object?> get props => [proposal];
}

class UpdateProposal extends ProposalsEvent {
  final Proposal proposal;

  const UpdateProposal(this.proposal);

  @override
  List<Object?> get props => [proposal];
}

class DeleteProposal extends ProposalsEvent {
  final Proposal? proposal;

  const DeleteProposal(this.proposal);

  @override
  List<Object?> get props => [proposal];
}

class SelectProposal extends ProposalsEvent {
  final Proposal proposal;

  const SelectProposal(this.proposal);

  @override
  List<Object?> get props => [proposal];
}

class UnselectProposal extends ProposalsEvent {}

class AcceptProposal extends ProposalsEvent {
  final Proposal proposal;

  const AcceptProposal(this.proposal);

  @override
  List<Object?> get props => [proposal];
}

class DeclineProposal extends ProposalsEvent {
  final Proposal proposal;

  const DeclineProposal(this.proposal);

  @override
  List<Object?> get props => [proposal];
}

class AddMilestone extends ProposalsEvent {
  final Milestone milestone;

  const AddMilestone(this.milestone);

  @override
  List<Object?> get props => [milestone];
}

class UpdateMilestone extends ProposalsEvent {
  final Milestone milestone;

  const UpdateMilestone(this.milestone);

  @override
  List<Object?> get props => [milestone];
}

class DeleteMilestone extends ProposalsEvent {
  final Milestone milestone;

  const DeleteMilestone(this.milestone);

  @override
  List<Object?> get props => [milestone];
}
