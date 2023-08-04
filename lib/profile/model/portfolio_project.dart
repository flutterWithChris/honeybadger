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
    images = snapshot['images'];
    startDate = snapshot['startDate'];
    endDate = snapshot['endDate'];
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
}
