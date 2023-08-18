class Review {
  String? id;
  String? userId;
  String? authorId;
  String? authorName;
  String? authorTitle;
  String? authorPhoto;
  String? review;
  String? projectId;
  String? projectTitle;
  int? rating;
  String? createdAt;
  String? updatedAt;

  Review({
    this.id,
    this.userId,
    this.authorId,
    this.authorName,
    this.authorTitle,
    this.authorPhoto,
    this.review,
    this.projectId,
    this.projectTitle,
    this.rating,
    this.createdAt,
    this.updatedAt,
  });

  Review.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    authorId = json['authorId'];
    authorName = json['authorName'];
    authorTitle = json['authorTitle'];
    authorPhoto = json['authorPhoto'];
    review = json['review'];
    projectId = json['projectId'];
    projectTitle = json['projectTitle'];
    rating = json['rating'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'authorId': authorId,
      'authorName': authorName,
      'authorTitle': authorTitle,
      'authorPhoto': authorPhoto,
      'review': review,
      'projectId': projectId,
      'projectTitle': projectTitle,
      'rating': rating,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
