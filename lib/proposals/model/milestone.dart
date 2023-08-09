class Milestone {
  final String? id;
  final String? title;
  final String? description;
  final int? amount;
  final bool? isPaid;
  final bool? isCompleted;
  final bool? funded;
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
    this.funded,
    this.paidAt,
    this.completedAt,
    this.startDate,
    this.dueDate,
    this.createdAt,
    this.updatedAt,
    this.proposalId,
    this.projectId,
  });

  Milestone copyWith({
    final String? id,
    final String? title,
    final String? description,
    final int? amount,
    final bool? isPaid,
    final bool? isCompleted,
    final bool? funded,
    final DateTime? paidAt,
    final DateTime? completedAt,
    final DateTime? startDate,
    final DateTime? dueDate,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final String? proposalId,
    final String? projectId,
  }) {
    return Milestone(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      isPaid: isPaid ?? this.isPaid,
      funded: funded ?? this.funded,
      isCompleted: isCompleted ?? this.isCompleted,
      paidAt: paidAt ?? this.paidAt,
      completedAt: completedAt ?? this.completedAt,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      proposalId: proposalId ?? this.proposalId,
      projectId: projectId ?? this.projectId,
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'isPaid': isPaid,
      'funded': funded,
      'isCompleted': isCompleted,
      'paidAt': paidAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'startDate': startDate?.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'proposalId': proposalId,
      'projectId': projectId,
    };
  }

  // fromJson
  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      id: json['id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      amount: json['amount'] as int?,
      isPaid: json['isPaid'] as bool?,
      funded: json['funded'] as bool?,
      isCompleted: json['isCompleted'] as bool?,
      paidAt: json['paidAt'] == null
          ? null
          : DateTime.parse(json['paidAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      proposalId: json['proposalId'] as String?,
      projectId: json['projectId'] as String?,
    );
  }

  @override
  String toString() {
    return 'Milestone(id: $id, title: $title, description: $description, amount: $amount, isPaid: $isPaid, funded: $funded, isCompleted: $isCompleted, paidAt: $paidAt, completedAt: $completedAt, startDate: $startDate, dueDate: $dueDate, createdAt: $createdAt, updatedAt: $updatedAt, proposalId: $proposalId, projectId: $projectId)';
  }
}
