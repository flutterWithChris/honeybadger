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
  final String? clientName;
  final String? freelancerId;
  final String? freelancerName;
  final String? jobId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? sentAt;
  final DateTime? savedAt;

  Proposal({
    this.id,
    this.status,
    this.title,
    this.description,
    this.budgetTotal,
    this.budgetHourly,
    this.milestones,
    this.clientId,
    this.clientName,
    this.freelancerId,
    this.freelancerName,
    this.jobId,
    this.createdAt,
    this.updatedAt,
    this.sentAt,
    this.savedAt,
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
      'clientName': clientName,
      'freelancerId': freelancerId,
      'freelancerName': freelancerName,
      'jobId': jobId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'sentAt': sentAt,
      'savedAt': savedAt,
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
      clientName: json['clientName'] as String?,
      freelancerId: json['freelancerId'] as String?,
      freelancerName: json['freelancerName'] as String?,
      jobId: json['jobId'] as String?,
      createdAt: json['createdAt'] as DateTime?,
      updatedAt: json['updatedAt'] as DateTime?,
      sentAt: json['sentAt'] as DateTime?,
      savedAt: json['savedAt'] as DateTime?,
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
    DateTime? sentAt,
    DateTime? savedAt,
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
      sentAt: sentAt ?? this.sentAt,
      savedAt: savedAt ?? this.savedAt,
    );
  }
}
