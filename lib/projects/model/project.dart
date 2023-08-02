import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:honeybadger/profile/model/user.dart';
import 'package:honeybadger/projects/model/project_category.dart';

import '../../proposals/model/milestone.dart';

enum ProjectType { hourly, fixed }

enum ProjectStatus { open, closed, inProgress }

enum ProjectDuration { oneTime, recurring }

enum ProjectVisibility { public, private }

class Project {
  final String? id;
  final User? client;
  final User? freelancer;
  final String? title;
  final String? description;
  final String? deliverables;
  final String? location;
  final List<String>? skills;
  final List<String>? tags;
  final ProjectCategory? category;
  final ProjectType? projectType;
  final ProjectStatus? status;
  final ProjectDuration? duration;
  final ProjectVisibility? visibility;
  final double? budget;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deadline;
  final int? weekEstimate;
  final int? hoursPerWeek;
  final int? hoursTotal;
  final int? proposalCount;
  final int? viewCount;
  final int? interviewCount;
  final DateTime? lastViewed;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<Milestone>? milestones;

  Project({
    this.id,
    this.client,
    this.freelancer,
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
    final String? id,
    final User? client,
    final User? freelancer,
    final String? title,
    final String? description,
    final String? deliverables,
    final String? location,
    final List<String>? skills,
    final List<String>? tags,
    final ProjectCategory? category,
    final ProjectType? projectType,
    final ProjectStatus? status,
    final ProjectDuration? duration,
    final ProjectVisibility? visibility,
    final double? budget,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final DateTime? deadline,
    final int? weekEstimate,
    final int? hoursPerWeek,
    final int? hoursTotal,
    final int? proposalCount,
    final int? viewCount,
    final int? interviewCount,
    final DateTime? lastViewed,
    final DateTime? startDate,
    final DateTime? endDate,
    final List<Milestone>? milestones,
  }) {
    return Project(
      id: id ?? this.id,
      client: client ?? client,
      freelancer: freelancer ?? freelancer,
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
      'client': client,
      'freelancer': freelancer,
      'title': title,
      'description': description,
      'deliverables': deliverables,
      'location': location,
      'skills': skills,
      'tags': tags,
      'category': category?.toJson(),
      'projectType': projectType.toString(),
      'status': status.toString(),
      'duration': duration,
      'visibility': visibility,
      'budget': budget,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deadline': deadline,
      'weekEstimate': weekEstimate,
      'hoursPerWeek': hoursPerWeek,
      'hoursTotal': hoursTotal,
      'proposalCount': proposalCount,
      'viewCount': viewCount,
      'interviewCount': interviewCount,
      'lastViewed': lastViewed,
      'startDate': startDate,
      'endDate': endDate,
      'milestones': milestones,
    };
  }

  // from document snapshot
  factory Project.fromDocument(DocumentSnapshot doc) {
    return Project(
      id: doc['id'],
      client: doc['client'],
      freelancer: doc['freelancer'],
      title: doc['title'],
      description: doc['description'],
      deliverables: doc['deliverables'],
      location: doc['location'],
      skills: doc['skills'],
      tags: doc['tags'],
      category: doc['category'],
      projectType: doc['projectType'],
      status: doc['status'],
      duration: doc['duration'],
      visibility: doc['visibility'],
      budget: doc['budget'],
      createdAt: doc['createdAt'],
      updatedAt: doc['updatedAt'],
      deadline: doc['deadline'],
      weekEstimate: doc['weekEstimate'],
      hoursPerWeek: doc['hoursPerWeek'],
      hoursTotal: doc['hoursTotal'],
      proposalCount: doc['proposalCount'],
      viewCount: doc['viewCount'],
      interviewCount: doc['interviewCount'],
      lastViewed: doc['lastViewed'],
      startDate: doc['startDate'],
      endDate: doc['endDate'],
      milestones: doc['milestones'],
    );
  }
}
