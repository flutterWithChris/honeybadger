import 'package:cloud_firestore/cloud_firestore.dart';

import '../../proposals/model/milestone.dart';

enum ProjectType { hourly, fixed }

enum ProjectStatus { open, closed, inProgress, completed }

enum ProjectDuration { oneTime, recurring }

enum ProjectVisibility { public, private }

class Project {
  String? id;
  String? clientId;
  String? clientName;
  double? clientRating;
  int? clientReviewCount;
  int? clientTotalSpend;
  String? clientLocation;
  String? clientProfilePicture;
  String? clientIndustry;
  String? freelancerId;
  String? freelancerName;
  String? acceptedProposalId;
  String? title;
  String? description;
  String? deliverables;
  String? location;
  List<dynamic>? skills;
  List<dynamic>? tags;
  String? category;
  ProjectType? projectType;
  ProjectStatus? status;
  ProjectDuration? duration;
  ProjectVisibility? visibility;
  double? budget;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deadline;
  int? weekEstimate;
  int? hoursPerWeek;
  int? hoursTotal;
  int? proposalCount;
  int? unreadProposalCount;
  int? viewCount;
  int? interviewCount;
  DateTime? lastViewed;
  DateTime? startDate;
  DateTime? endDate;
  List<Milestone>? milestones;

  Project({
    this.id,
    this.clientId,
    this.clientName,
    this.clientRating,
    this.clientReviewCount,
    this.clientTotalSpend,
    this.clientLocation,
    this.clientProfilePicture,
    this.clientIndustry,
    this.freelancerId,
    this.freelancerName,
    this.acceptedProposalId,
    this.title,
    this.description,
    this.deliverables,
    this.location,
    this.skills,
    this.tags,
    this.category,
    this.projectType,
    this.status,
    this.duration,
    this.visibility,
    this.budget,
    this.createdAt,
    this.updatedAt,
    this.deadline,
    this.weekEstimate,
    this.hoursPerWeek,
    this.hoursTotal,
    this.proposalCount,
    this.unreadProposalCount,
    this.viewCount,
    this.interviewCount,
    this.lastViewed,
    this.startDate,
    this.endDate,
    this.milestones,
  });

  // copyWith
  Project copyWith({
    String? id,
    String? clientId,
    String? clientName,
    double? clientRating,
    int? clientReviewCount,
    int? clientTotalSpend,
    String? clientLocation,
    String? clientProfilePicture,
    String? clientIndustry,
    String? freelancerId,
    String? freelancerName,
    String? acceptedProposalId,
    String? title,
    String? description,
    String? deliverables,
    String? location,
    List<String>? skills,
    List<String>? tags,
    String? category,
    ProjectType? projectType,
    ProjectStatus? status,
    ProjectDuration? duration,
    ProjectVisibility? visibility,
    double? budget,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deadline,
    int? weekEstimate,
    int? hoursPerWeek,
    int? hoursTotal,
    int? proposalCount,
    int? unreadProposalCount,
    int? viewCount,
    int? interviewCount,
    DateTime? lastViewed,
    DateTime? startDate,
    DateTime? endDate,
    List<Milestone>? milestones,
  }) {
    return Project(
      id: id ?? this.id,
      clientId: clientId ?? clientId,
      clientName: clientName ?? clientName,
      clientRating: clientRating ?? clientRating,
      clientReviewCount: clientReviewCount ?? clientReviewCount,
      clientTotalSpend: clientTotalSpend ?? clientTotalSpend,
      clientLocation: clientLocation ?? clientLocation,
      clientProfilePicture: clientProfilePicture ?? clientProfilePicture,
      clientIndustry: clientIndustry ?? clientIndustry,
      freelancerId: freelancerId ?? freelancerId,
      freelancerName: freelancerName ?? freelancerName,
      acceptedProposalId: acceptedProposalId ?? acceptedProposalId,
      title: title ?? title,
      description: description ?? description,
      deliverables: deliverables ?? deliverables,
      location: location ?? location,
      skills: skills ?? skills,
      tags: tags ?? tags,
      category: category ?? category,
      projectType: projectType ?? projectType,
      status: status ?? status,
      duration: duration ?? duration,
      visibility: visibility ?? visibility,
      budget: budget ?? budget,
      createdAt: createdAt ?? createdAt,
      updatedAt: updatedAt ?? updatedAt,
      deadline: deadline ?? deadline,
      weekEstimate: weekEstimate ?? weekEstimate,
      hoursPerWeek: hoursPerWeek ?? hoursPerWeek,
      hoursTotal: hoursTotal ?? hoursTotal,
      proposalCount: proposalCount ?? proposalCount,
      unreadProposalCount: unreadProposalCount ?? unreadProposalCount,
      viewCount: viewCount ?? viewCount,
      interviewCount: interviewCount ?? interviewCount,
      lastViewed: lastViewed ?? lastViewed,
      startDate: startDate ?? startDate,
      endDate: endDate ?? endDate,
      milestones: milestones ?? milestones,
    );
  }

  // toDocument
  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'clientId': clientId,
      'clientName': clientName,
      'clientRating': clientRating,
      'clientReviewCount': clientReviewCount,
      'clientTotalSpend': clientTotalSpend,
      'clientLocation': clientLocation,
      'clientProfilePicture': clientProfilePicture,
      'clientIndustry': clientIndustry,
      'freelancerId': freelancerId,
      'freelancerName': freelancerName,
      'acceptedProposalId': acceptedProposalId,
      'title': title,
      'description': description,
      'deliverables': deliverables,
      'location': location,
      'skills': skills,
      'tags': tags,
      'category': category,
      'projectType': projectType.toString().split('.').last,
      'status': status.toString().split('.').last,
      'duration': duration.toString().split('.').last,
      'visibility': visibility.toString().split('.').last,
      'budget': budget,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deadline': deadline?.toIso8601String(),
      'weekEstimate': weekEstimate,
      'hoursPerWeek': hoursPerWeek,
      'hoursTotal': hoursTotal,
      'proposalCount': proposalCount ?? 0,
      'unreadProposalCount': unreadProposalCount ?? 0,
      'viewCount': viewCount ?? 0,
      'interviewCount': interviewCount ?? 0,
      'lastViewed': lastViewed,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'milestones': milestones == null
          ? null
          : milestones?.map((e) => e.toJson()).toList(),
    };
  }

  // from document snapshot
  Project.fromDocument(DocumentSnapshot snap) {
    id = snap.id;
    clientId = snap['clientId'];
    clientName = snap['clientName'];
    clientRating = snap['clientRating'];
    clientReviewCount = snap['clientReviewCount'];
    clientTotalSpend = snap['clientTotalSpend'];
    clientLocation = snap['clientLocation'];
    clientProfilePicture = snap['clientProfilePicture'];
    clientIndustry = snap['clientIndustry'];
    freelancerId = snap['freelancerId'];
    freelancerName = snap['freelancerName'];
    acceptedProposalId = snap['acceptedProposalId'];
    title = snap['title'];
    description = snap['description'];
    deliverables = snap['deliverables'];
    location = snap['location'];
    skills = snap['skills'];
    tags = snap['tags'];
    category = snap['category'];
    projectType = snap['projectType'] == 'hourly'
        ? ProjectType.hourly
        : ProjectType.fixed;
    status = snap['status'] == 'open'
        ? ProjectStatus.open
        : snap['status'] == 'closed'
            ? ProjectStatus.closed
            : ProjectStatus.inProgress;
    duration = snap['duration'] == 'oneTime'
        ? ProjectDuration.oneTime
        : ProjectDuration.recurring;
    visibility = snap['visibility'] == 'public'
        ? ProjectVisibility.public
        : ProjectVisibility.private;
    budget = snap['budget'];
    createdAt = snap['createdAt'] == null
        ? null
        : DateTime.parse(snap['createdAt'] as String);
    updatedAt = snap['updatedAt'] == null
        ? null
        : DateTime.parse(snap['updatedAt'] as String);
    deadline = snap['deadline'] == null
        ? null
        : DateTime.parse(snap['deadline'] as String);
    weekEstimate = snap['weekEstimate'];
    hoursPerWeek = snap['hoursPerWeek'];
    hoursTotal = snap['hoursTotal'];
    proposalCount = snap['proposalCount'];
    unreadProposalCount = snap['unreadProposalCount'];
    viewCount = snap['viewCount'];
    interviewCount = snap['interviewCount'];
    lastViewed = snap['lastViewed'] == null
        ? null
        : DateTime.parse(snap['lastViewed'] as String);
    startDate = snap['startDate'] == null
        ? null
        : DateTime.parse(snap['startDate'] as String);
    endDate = snap['endDate'] == null
        ? null
        : DateTime.parse(snap['endDate'] as String);
    milestones = snap['milestones'] != null
        ? (snap['milestones'] as List)
            .map((e) => Milestone.fromJson(e))
            .toList()
        : null;
  }
}
