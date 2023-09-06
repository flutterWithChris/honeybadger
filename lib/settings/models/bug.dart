enum BugStatus { pending, inProgress, solved }

class Bug {
  final String? id;
  final String? userId;
  final String? platform;
  final String? title;
  final String? description;
  final List<String>? images;
  final String? date;
  final BugStatus? status;

  Bug({
    this.id,
    this.userId,
    this.platform,
    this.title,
    this.description,
    this.images,
    this.date,
    this.status,
  });

  factory Bug.fromDocument(Map<String, dynamic> document) {
    return Bug(
      id: document['id'],
      userId: document['user_id'],
      platform: document['platform'],
      title: document['title'],
      description: document['description'],
      images: document['images'],
      date: document['date'],
      status: document['status'] == 'BugStatus.pending'
          ? BugStatus.pending
          : document['status'] == 'BugStatus.inProgress'
              ? BugStatus.inProgress
              : BugStatus.solved,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'userId': userId,
      'platform': platform,
      'title': title,
      'description': description,
      'images': images,
      'date': date,
      'status': status.toString(),
    };
  }
}
