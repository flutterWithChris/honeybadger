import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:honeybadger/profile/model/portfolio_project.dart';

class PortfolioRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get Portfolio Projects List
  Stream<List<PortfolioProject>> getPortfolioProjects(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('portfolio')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PortfolioProject.fromDocumentSnapshot(doc))
            .toList());
  }

  // Add Portfolio Project
  Future<void> addPortfolioProject(
      String userId, PortfolioProject project) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('portfolio')
        .add(project.toDocumentSnapshot());
  }

  // Update Portfolio Project
  Future<void> updatePortfolioProject(
      String userId, PortfolioProject project) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('portfolio')
        .doc(project.id)
        .update(project.toDocumentSnapshot());
  }

  // Delete Portfolio Project
  Future<void> deletePortfolioProject(
      String userId, PortfolioProject project) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('portfolio')
        .doc(project.id)
        .delete();
  }
}
