import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:honeybadger/core/constants.dart';

import '../model/project.dart';

class ProjectsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Project>>? getProjects() {
    try {
      return _firestore.collection('projects').snapshots().map((snapshot) {
        return snapshot.docs.map((doc) => Project.fromDocument(doc)).toList();
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
      return null;
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

  Future<void> createProject(Project project) async {
    try {
      return await _firestore
          .collection('projects')
          .doc(project.id)
          .set(project.toDocument());
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
