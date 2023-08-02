import 'package:cloud_firestore/cloud_firestore.dart';

import '../../proposals/model/milestone.dart';

enum ProjectType { hourly, fixed }

enum ProjectStatus { open, closed, inProgress }

enum ProjectDuration { oneTime, recurring }

enum ProjectVisibility { public, private }

class Project {
  String? id;
  String? clientId;
  String? clientName;
  String? freelancerId;
  String? freelancerName;
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
    this.freelancerId,
    this.freelancerName,
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
    String? freelancerId,
    String? freelancerName,
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
      freelancerId: freelancerId ?? freelancerId,
      freelancerName: freelancerName ?? freelancerName,
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
      'freelancerId': freelancerId,
      'freelancerName': freelancerName,
      'title': title,
      'description': description,
      'deliverables': deliverables,
      'location': location,
      'skills': skills,
      'tags': tags,
      'category': category,
      'projectType': projectType.toString(),
      'status': status.toString(),
      'duration': duration.toString(),
      'visibility': visibility,
      'budget': budget,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deadline': deadline?.toIso8601String(),
      'weekEstimate': weekEstimate,
      'hoursPerWeek': hoursPerWeek,
      'hoursTotal': hoursTotal,
      'proposalCount': proposalCount,
      'viewCount': viewCount,
      'interviewCount': interviewCount,
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
    freelancerId = snap['freelancerId'];
    freelancerName = snap['freelancerName'];
    title = snap['title'];
    description = snap['description'];
    deliverables = snap['deliverables'];
    location = snap['location'];
    skills = snap['skills'];
    tags = snap['tags'];
    category = snap['category'];
    projectType = snap['projectType'] == 'ProjectType.hourly'
        ? ProjectType.hourly
        : ProjectType.fixed;
    status = snap['status'] == 'ProjectStatus.open'
        ? ProjectStatus.open
        : snap['status'] == 'ProjectStatus.closed'
            ? ProjectStatus.closed
            : ProjectStatus.inProgress;
    duration = snap['duration'] == 'ProjectDuration.oneTime'
        ? ProjectDuration.oneTime
        : ProjectDuration.recurring;
    visibility = snap['visibility'] == 'ProjectVisibility.public'
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
