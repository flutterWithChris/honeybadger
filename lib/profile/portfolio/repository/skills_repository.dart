import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:OutsourcedX/profile/model/skill.dart';

class SkillsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> getSkills() async {
    try {
      List<String> skills = [];
      await _firestore.collection('skills').get().then((value) {
        for (var doc in value.docs) {
          skills.add(doc['name']);
        }
      });
      return skills;
    } on FirebaseException catch (e) {
      print(e);
      return [];
    }
  }

  /// Create a new skill in the database.
  Future<void> createSkill(Skill skill) async {
    try {
      await _firestore.collection('skills').doc().set(skill.toDocument());
    } on FirebaseException catch (e) {
      print(e);
      rethrow;
    }
  }
}
