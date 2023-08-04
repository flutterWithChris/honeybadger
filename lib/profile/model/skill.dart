import 'package:cloud_firestore/cloud_firestore.dart';

class Skill {
  String? id;
  String? name;
  String? description;

  Skill({this.id, this.name, this.description});

  /// From DocumentSnapshot
  Skill.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;
    name = documentSnapshot['name'];
    description = documentSnapshot['description'];
  }

  /// To DocumentSnapshot
  Map<String, dynamic> toDocument() {
    return {
      'name': name,
      'description': description,
    };
  }

  /// From Algolia Search
  Skill.fromAlgoliaSearch({required Map<String, dynamic> algoliaSearch}) {
    id = algoliaSearch['objectID'];
    name = algoliaSearch['name'];
    description = algoliaSearch['description'];
  }
}
