import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String? id;
  String? name;
  String? description;
  String? path;

  Category({this.id, this.name, this.description, this.path});

  // From DocumentSnapshot
  Category fromDocumentSnapshot(DocumentSnapshot snap) {
    return Category(
      id: snap.id,
      name: snap['name'] as String?,
      description: snap['description'] as String?,
    );
  }

  // To document
  Category toDocument(Category category) {
    return Category(
      name: category.name,
      description: category.description,
    );
  }

  Category.fromAlgoliaSearch(Map<String, dynamic> json) {
    id = json['objectID'];
    name = json['name'];
    description = json['description'];
    path = json['path'];
  }
}
