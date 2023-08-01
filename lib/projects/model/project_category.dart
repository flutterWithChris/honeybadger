class ProjectCategory {
  final String? id;
  final String? name;
  final String? description;
  final String? image;

  ProjectCategory({this.id, this.name, this.description, this.image});

  factory ProjectCategory.fromJson(Map<String, dynamic> json) {
    return ProjectCategory(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
    );
  }
}
