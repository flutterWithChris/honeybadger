class Milestone {
  final String? id;
  final String? title;
  final String? description;
  final double? amount;
  final bool? isPaid;
  final bool? isCompleted;
  final DateTime? paidAt;
  final DateTime? completedAt;
  final DateTime? startDate;
  final DateTime? dueDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? proposalId;
  final String? projectId;

  Milestone({
    this.id,
    this.title,
    this.description,
    this.amount,
    this.isPaid,
    this.isCompleted,
    this.paidAt,
    this.completedAt,
    this.startDate,
    this.dueDate,
    this.createdAt,
    this.updatedAt,
    this.proposalId,
    this.projectId,
  });
}
