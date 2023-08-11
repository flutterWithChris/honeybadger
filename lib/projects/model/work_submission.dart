class WorkSubmission {
  String? id;
  String? projectId;
  String? userId;
  String? proposalId;
  String? milestoneId;
  String? description;
  List<String>? files;
  List<String>? images;
  List<String>? urls;
  int? createdAt;

  WorkSubmission({
    this.id,
    this.projectId,
    this.userId,
    this.proposalId,
    this.milestoneId,
    this.description,
    this.files,
    this.images,
    this.urls,
    this.createdAt,
  });

  // copyWith
  WorkSubmission copyWith({
    String? id,
    String? projectId,
    String? userId,
    String? proposalId,
    String? milestoneId,
    String? description,
    List<String>? files,
    List<String>? images,
    List<String>? urls,
    int? createdAt,
  }) {
    return WorkSubmission(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      userId: userId ?? this.userId,
      proposalId: proposalId ?? this.proposalId,
      milestoneId: milestoneId ?? this.milestoneId,
      description: description ?? this.description,
      files: files ?? this.files,
      images: images ?? this.images,
      urls: urls ?? this.urls,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // toJson
  Map<String, dynamic> toJson() => {
        'id': id,
        'project_id': projectId,
        'user_id': userId,
        'proposal_id': proposalId,
        'milestone_id': milestoneId,
        'description': description,
        'files': files,
        'images': images,
        'urls': urls,
        'created_at': createdAt
      };

  // fromJson
  factory WorkSubmission.fromJson(Map<String, dynamic> json) => WorkSubmission(
      id: json['id'] as String?,
      projectId: json['project_id'] as String?,
      userId: json['user_id'] as String?,
      proposalId: json['proposal_id'] as String?,
      milestoneId: json['milestone_id'] as String?,
      description: json['description'] as String?,
      files: json['files'] != null
          ? (json['files'] as List<dynamic>).map((e) => e as String).toList()
          : null,
      images: json['images'] != null
          ? (json['images'] as List<dynamic>).map((e) => e as String).toList()
          : null,
      urls: json['urls'] != null
          ? (json['urls'] as List<dynamic>).map((e) => e as String).toList()
          : null,
      createdAt: json['created_at']);
}
