import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:honeybadger/profile/model/skill.dart';

class SkillsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> getSkills() async {
    List<String> skills = [];
    await _firestore.collection('skills').get().then((value) {
      for (var doc in value.docs) {
        skills.add(doc['name']);
      }
    });
    return skills;
  }

  /// Create a new skill in the database.
  Future<void> createSkill(Skill skill) async {
    await _firestore.collection('skills').doc().set(skill.toDocument());
  }
}
