import 'milestone.dart';

enum ProposalStatus { pending, accepted, rejected, completed }

class Proposal {
  final String? id;
  final ProposalStatus? status;
  final String? title;
  final String? description;
  final double? budgetTotal;
  final double? budgetHourly;
  final List<Milestone>? milestones;
  final String? client;
  final String? freelancer;
  final String? jobId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Proposal({
    this.id,
    this.status,
    this.title,
    this.description,
    this.budgetTotal,
    this.budgetHourly,
    this.milestones,
    this.client,
    this.freelancer,
    this.jobId,
    this.createdAt,
    this.updatedAt,
  });
}
