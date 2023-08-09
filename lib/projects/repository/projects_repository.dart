import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/profile/model/user.dart';

import '../model/project.dart';

class ProjectsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Get list of projects as a stream
  Stream<List<Project>> getProjects(User user) {
    try {
      return _firestore
          .collection('projects')
          .where('clientId', isEqualTo: user.id)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return Project.fromDocument(doc);
        }).toList();
      });
    } on FirebaseException catch (e) {
      print(e);
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          content: Text('Error loading projects'),
        ),
      );
      return const Stream.empty();
    }
  }

// Get projects from list of project ids
  Stream<List<Project>> getProjectsFromIds(List<String> projectIds) {
    try {
      return _firestore
          .collection('projects')
          .where('id', whereIn: projectIds)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return Project.fromDocument(doc);
        }).toList();
      });
    } on FirebaseException catch (e) {
      print(e);
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          content: Text('Error loading projects'),
        ),
      );
      return const Stream.empty();
    }
  }

  // Get project from list of project ids as future
  Future<List<Project>> getProjectsFromIdsFuture(
      List<String> projectIds) async {
    try {
      var snapshot = await _firestore
          .collection('projects')
          .where('id', whereIn: projectIds)
          .get();

      return snapshot.docs.map((doc) {
        return Project.fromDocument(doc);
      }).toList();
    } on FirebaseException catch (e) {
      print(e);
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          content: Text('Error loading projects'),
        ),
      );
      return [];
    }
  }

  Stream<Project>? getProject(String projectId) {
    try {
      return _firestore
          .collection('projects')
          .doc(projectId)
          .snapshots()
          .map((snapshot) {
        return Project.fromDocument(snapshot);
      });
    } on FirebaseException catch (e) {
      print(e);
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          content: Text('Error loading project'),
        ),
      );
      return null;
    }
  }

  Future<String?> createProject(Project project) async {
    try {
      var docRef = _firestore.collection('projects').doc();

      await docRef.set(project.copyWith(id: docRef.id).toDocument());

      return docRef.id;
    } on FirebaseException catch (e) {
      print(e);
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          content: Text('Error creating project'),
        ),
      );
      return null;
    }
  }

  Future<void> createProjectReference(User user, String projectId) async {
    try {
      return await _firestore.collection('users').doc(user.id).update({
        'projectIds': FieldValue.arrayUnion([projectId])
      });
    } on FirebaseException catch (e) {
      print(e);
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          content: Text('Error creating project'),
        ),
      );
    }
  }

  /// Delete project reference from user
  Future<void> deleteProjectReference(User user, Project project) async {
    try {
      return await _firestore.collection('users').doc(user.id).update({
        'projectIds': FieldValue.arrayRemove([project.id])
      });
    } on FirebaseException catch (e) {
      print(e);
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          content: Text('Error deleting project'),
        ),
      );
    }
  }

  Future<void> updateProject(Project project) async {
    try {
      return await _firestore
          .collection('projects')
          .doc(project.id)
          .update(project.toDocument());
    } on FirebaseException catch (e) {
      print(e);
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          content: Text('Error updating project'),
        ),
      );
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      return await _firestore.collection('projects').doc(projectId).delete();
    } on FirebaseException catch (e) {
      print(e);
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          content: Text('Error deleting project'),
        ),
      );
    }
  }
}
