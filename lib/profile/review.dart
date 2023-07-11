class Review {
  String? id;
  String? userId;
  String? authorId;
  String? review;
  int? rating;
  String? createdAt;
  String? updatedAt;

  Review({
    this.id,
    this.userId,
    this.authorId,
    this.review,
    this.rating,
    this.createdAt,
    this.updatedAt,
  });

  Review.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    authorId = json['authorId'];
    review = json['review'];
    rating = json['rating'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'authorId': authorId,
      'review': review,
      'rating': rating,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
