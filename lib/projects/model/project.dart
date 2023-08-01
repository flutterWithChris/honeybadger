import 'package:honeybadger/profile/model/user.dart';
import 'package:honeybadger/projects/model/project_category.dart';

import '../../proposals/model/milestone.dart';

enum PaymentType { hourly, fixedPrice }

enum ProjectStatus { open, closed, inProgress }

enum ProjectDuration { oneTime, recurring }

enum ProjectVisibility { public, private }

class Project {
  final String? id;
  final User? client;
  final User? freelancer;
  final String? title;
  final String? description;
  final String? location;
  final List<String>? skills;
  final List<String>? tags;
  final ProjectCategory? category;
  final PaymentType? paymentType;
  final ProjectStatus? status;
  final ProjectDuration? duration;
  final ProjectVisibility? visibility;
  final double? budget;
  final DateTime? createdAt;
  final DateTime? updatedAt;
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
    this.location,
    this.skills,
    this.tags,
    this.category,
    this.paymentType,
    this.status,
    this.duration,
    this.visibility,
    this.budget,
    this.createdAt,
    this.updatedAt,
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
}
