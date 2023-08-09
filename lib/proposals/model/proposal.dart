import 'package:cloud_firestore/cloud_firestore.dart';

import 'milestone.dart';

enum ProposalStatus { draft, sent, accepted, rejected, completed }

class Proposal {
  String? id;
  ProposalStatus? status;
  String? title;
  String? description;
  int? budgetTotal;
  int? budgetHourly;
  List<Milestone>? milestones;
  String? clientId;
  String? clientName;
  String? freelancerId;
  String? freelancerName;
  String? freelancerAvatar;
  String? freelancerStripeAccountId;
  String? projectId;
  String? projectName;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? sentAt;
  DateTime? savedAt;
  bool? viewed;

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
    this.freelancerAvatar,
    this.freelancerStripeAccountId,
    this.projectId,
    this.projectName,
    this.createdAt,
    this.updatedAt,
    this.sentAt,
    this.savedAt,
    this.viewed,
  });

// toDocument
  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'status': status.toString().split('.').last,
      'title': title,
      'description': description,
      'budgetTotal': budgetTotal,
      'budgetHourly': budgetHourly,
      'milestones': milestones?.map((e) => e.toJson()).toList(),
      'clientId': clientId,
      'clientName': clientName,
      'freelancerId': freelancerId,
      'freelancerName': freelancerName,
      'freelancerAvatar': freelancerAvatar,
      'freelancerStripeAccountId': freelancerStripeAccountId,
      'projectId': projectId,
      'projectName': projectName,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'sentAt': sentAt?.toIso8601String(),
      'savedAt': savedAt?.toIso8601String(),
      'viewed': viewed ?? false,
    };
  }

// fromDocument
  Proposal.fromDocument(DocumentSnapshot snap) {
    id = snap.id;
    status = ProposalStatus.values
        .firstWhere((e) => e.toString().split('.').last == snap['status']);
    title = snap['title'];
    description = snap['description'];
    budgetTotal = snap['budgetTotal'];
    budgetHourly = snap['budgetHourly'];
    milestones = snap['milestones'] != null
        ? List<Milestone>.from(
            snap['milestones'].map((e) => Milestone.fromJson(e)))
        : null;
    clientId = snap['clientId'];
    clientName = snap['clientName'];
    freelancerId = snap['freelancerId'];
    freelancerName = snap['freelancerName'];
    freelancerAvatar = snap['freelancerAvatar'];
    freelancerStripeAccountId = snap['freelancerStripeAccountId'];
    projectId = snap['projectId'];
    projectName = snap['projectName'];
    createdAt = DateTime.tryParse(snap['createdAt'] ?? '');
    updatedAt = DateTime.tryParse(snap['updatedAt'] ?? '');
    sentAt = DateTime.tryParse(snap['sentAt'] ?? '');
    savedAt = DateTime.tryParse(snap['savedAt'] ?? '');
    viewed = snap['viewed'] ?? false;
  }

  Proposal copyWith({
    String? id,
    ProposalStatus? status,
    String? title,
    String? description,
    int? budgetTotal,
    int? budgetHourly,
    List<Milestone>? milestones,
    String? clientId,
    String? clientName,
    String? freelancerId,
    String? freelancerName,
    String? freelancerAvatar,
    String? freelancerStripeAccountId,
    String? projectId,
    String? projectName,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? sentAt,
    DateTime? savedAt,
    bool? viewed,
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
      clientName: clientName ?? this.clientName,
      freelancerId: freelancerId ?? this.freelancerId,
      freelancerName: freelancerName ?? this.freelancerName,
      freelancerAvatar: freelancerAvatar ?? this.freelancerAvatar,
      freelancerStripeAccountId:
          freelancerStripeAccountId ?? this.freelancerStripeAccountId,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sentAt: sentAt ?? this.sentAt,
      savedAt: savedAt ?? this.savedAt,
      viewed: viewed ?? this.viewed,
    );
  }
}
