class PortfolioProject {
  final String? id;
  final String? title;
  final String? description;
  final String? url;
  final List<String>? images;
  final DateTime? startDate;
  final DateTime? endDate;

  const PortfolioProject({
    this.id,
    this.title,
    this.description,
    this.url,
    this.images,
    this.startDate,
    this.endDate,
  });

  factory PortfolioProject.fromJson(Map<String, dynamic> json) {
    return PortfolioProject(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'url': url,
      'images': images,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}
