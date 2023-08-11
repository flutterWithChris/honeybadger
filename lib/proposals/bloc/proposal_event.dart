part of 'proposal_bloc.dart';

abstract class ProposalsEvent extends Equatable {
  const ProposalsEvent();

  @override
  List<Object?> get props => [];
}

class LoadProposal extends ProposalsEvent {
  final String projectId;
  final String userId;

  const LoadProposal(this.projectId, this.userId);
}

class LoadProposals extends ProposalsEvent {
  final Project project;
  final String userId;

  const LoadProposals(this.project, this.userId);

  @override
  List<Object?> get props => [project, userId];
}

class StartProposal extends ProposalsEvent {
  final String jobId;
  final Proposal proposal;

  const StartProposal(this.jobId, this.proposal);

  @override
  List<Object?> get props => [jobId, proposal];
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

class FundMilestone extends ProposalsEvent {
  final Proposal proposal;
  final Milestone milestone;

  const FundMilestone(this.milestone, this.proposal);

  @override
  List<Object?> get props => [milestone, proposal];
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

class UpdateDescription extends ProposalsEvent {
  final String description;

  const UpdateDescription(this.description);

  @override
  List<Object?> get props => [description];
}

class SubmitWork extends ProposalsEvent {
  final Proposal proposal;
  final Milestone milestone;
  final String description;
  final List<String>? urls;
  final List<PlatformFile>? files;
  final List<PlatformFile>? images;

  const SubmitWork({
    required this.proposal,
    required this.milestone,
    required this.description,
    this.urls,
    this.files,
    this.images,
  });

  @override
  List<Object?> get props =>
      [proposal, milestone, description, urls, files, images];
}
