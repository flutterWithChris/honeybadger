import 'package:honeybadger/jobs/model/job_category.dart';
import 'package:honeybadger/profile/model/user.dart';

import '../../proposals/model/milestone.dart';

enum PaymentType { hourly, fixedPrice }

enum JobStatus { open, closed, inProgress }

enum JobDuration { oneTime, recurring }

enum JobVisibility { public, private }

class Job {
  final String? id;
  final User? client;
  final User? freelancer;
  final String? title;
  final String? description;
  final String? location;
  final List<String>? skills;
  final List<String>? tags;
  final JobCategory? category;
  final PaymentType? paymentType;
  final JobStatus? status;
  final JobDuration? duration;
  final JobVisibility? visibility;
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

  Job({
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
