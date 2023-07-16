import 'milestone.dart';

enum ProposalStatus { draft, sent, accepted, rejected, completed }

class Proposal {
  final String? id;
  final ProposalStatus? status;
  final String? title;
  final String? description;
  final double? budgetTotal;
  final double? budgetHourly;
  final List<Milestone>? milestones;
  final String? clientId;
  final String? freelancerId;
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
    this.clientId,
    this.freelancerId,
    this.jobId,
    this.createdAt,
    this.updatedAt,
  });

  //toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'title': title,
      'description': description,
      'budgetTotal': budgetTotal,
      'budgetHourly': budgetHourly,
      'milestones': milestones,
      'clientId': clientId,
      'freelancerId': freelancerId,
      'jobId': jobId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // fromJson
  factory Proposal.fromJson(Map<String, dynamic> json) {
    return Proposal(
      id: json['id'] as String?,
      status: json['status'] as ProposalStatus?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      budgetTotal: json['budgetTotal'] as double?,
      budgetHourly: json['budgetHourly'] as double?,
      milestones: json['milestones'] as List<Milestone>?,
      clientId: json['clientId'] as String?,
      freelancerId: json['freelancerId'] as String?,
      jobId: json['jobId'] as String?,
      createdAt: json['createdAt'] as DateTime?,
      updatedAt: json['updatedAt'] as DateTime?,
    );
  }

  Proposal copyWith({
    String? id,
    ProposalStatus? status,
    String? title,
    String? description,
    double? budgetTotal,
    double? budgetHourly,
    List<Milestone>? milestones,
    String? clientId,
    String? freelancerId,
    String? jobId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Proposal(
      id: id ?? this.id,
      status: status ?? this.status,
      title: title ?? this.title,
      description: description ?? this.description,
      budgetTotal: budgetTotal ?? this.budgetTotal,
      budgetHourly: budgetHourly ?? this.budgetHourly,
      milestones: milestones ?? this.milestones,
      clientId: clientId ?? this.clientId,
      freelancerId: freelancerId ?? this.freelancerId,
      jobId: jobId ?? this.jobId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
