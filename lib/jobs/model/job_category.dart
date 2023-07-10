class JobCategory {
  final String? id;
  final String? name;
  final String? description;
  final String? image;

  JobCategory({this.id, this.name, this.description, this.image});

  factory JobCategory.fromJson(Map<String, dynamic> json) {
    return JobCategory(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
    );
  }
}
