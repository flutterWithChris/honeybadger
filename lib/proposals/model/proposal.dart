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
  String? projectId;
  String? projectName;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? sentAt;
  DateTime? savedAt;

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
    this.projectId,
    this.projectName,
    this.createdAt,
    this.updatedAt,
    this.sentAt,
    this.savedAt,
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
      'projectId': projectId,
      'projectName': projectName,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'sentAt': sentAt,
      'savedAt': savedAt,
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
    projectId = snap['projectId'];
    projectName = snap['projectName'];
    createdAt = snap['createdAt']?.toDate();
    updatedAt = snap['updatedAt']?.toDate();
    sentAt = snap['sentAt']?.toDate();
    savedAt = snap['savedAt']?.toDate();
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
    String? projectId,
    String? projectName,
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
      clientName: clientName ?? this.clientName,
      freelancerId: freelancerId ?? this.freelancerId,
      freelancerName: freelancerName ?? this.freelancerName,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sentAt: sentAt ?? this.sentAt,
      savedAt: savedAt ?? this.savedAt,
    );
  }
}
