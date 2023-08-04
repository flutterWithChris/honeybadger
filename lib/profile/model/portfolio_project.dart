import 'package:cloud_firestore/cloud_firestore.dart';

class PortfolioProject {
  String? id;
  String? title;
  String? description;
  String? url;
  List<String>? images;
  DateTime? startDate;
  DateTime? endDate;

  PortfolioProject({
    this.id,
    this.title,
    this.description,
    this.url,
    this.images,
    this.startDate,
    this.endDate,
  });

  // fromDocumentSnapshot
  PortfolioProject.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.id;
    title = snapshot['title'];
    description = snapshot['description'];
    url = snapshot['url'];
    images = snapshot['images'] != null
        ? List<String>.from(snapshot['images'])
        : null;
    startDate = snapshot['startDate'] != null
        ? (snapshot['startDate'] as Timestamp).toDate()
        : null;
    endDate = snapshot['endDate'] != null
        ? (snapshot['endDate'] as Timestamp).toDate()
        : null;
  }

  // toDocumentSnapshot
  Map<String, dynamic> toDocumentSnapshot() {
    return {
      'title': title,
      'description': description,
      'url': url,
      'images': images,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  // copyWith
  PortfolioProject copyWith({
    String? id,
    String? title,
    String? description,
    String? url,
    List<String>? images,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return PortfolioProject(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      images: images ?? this.images,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
