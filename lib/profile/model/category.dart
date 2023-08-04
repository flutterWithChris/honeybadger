import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String? id;
  String? name;
  String? description;
  String? path;

  Category({this.id, this.name, this.description, this.path});

  // From DocumentSnapshot
  Category.fromDocumentSnapshot(DocumentSnapshot snap) {
    id = snap.id;
    name = snap['name'];
    description = snap['description'];
  }

  // To document
  Map<String, dynamic> toDocument() {
    return {
      'name': name,
      'description': description,
    };
  }

  Category.fromAlgoliaSearch(Map<String, dynamic> json) {
    id = json['objectID'];
    name = json['name'];
    description = json['description'];
    path = json['path'];
  }
}
