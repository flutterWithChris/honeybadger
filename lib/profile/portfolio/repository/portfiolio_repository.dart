import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/profile/model/portfolio_project.dart';
import 'package:image_picker/image_picker.dart';

class PortfolioRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  // Get Portfolio Projects List
  Stream<List<PortfolioProject>> getPortfolioProjects(String userId) {
    try {
      return _firestore
          .collection('users')
          .doc(userId)
          .collection('portfolio')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => PortfolioProject.fromDocumentSnapshot(doc))
              .toList());
    } on FirebaseException catch (e) {
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          content: Text('Error getting portfolio projects!'),
        ),
      );
      print(e);
      throw Exception(e.message);
    }
  }

  // Add Portfolio Project
  Future<void> addPortfolioProject(
      String userId, PortfolioProject project, List<XFile> images) async {
    try {
      // Save Project Images to Firebase Storage
      List<String> imageUrls = await savePortfolioProjectImages(userId, images);
      PortfolioProject projectWithImages = project.copyWith(images: imageUrls);
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('portfolio')
          .add(projectWithImages.toDocumentSnapshot());
    } on FirebaseException catch (e) {
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          content: Text('Error adding portfolio project!'),
        ),
      );
      throw Exception(e.message);
    }
  }

  // Update Portfolio Project
  Future<void> updatePortfolioProject(
      String userId, PortfolioProject project) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('portfolio')
          .doc(project.id)
          .update(project.toDocumentSnapshot());
    } on FirebaseException catch (e) {
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          content: Text('Error updating portfolio project!'),
        ),
      );
      throw Exception(e.message);
    }
  }

  // Delete Portfolio Project
  Future<void> deletePortfolioProject(
      String userId, PortfolioProject project) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('portfolio')
          .doc(project.id)
          .delete();
    } on FirebaseException catch (e) {
      scaffoldKey.currentState!.showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        content: Text('Error deleting portfolio project!'),
      ));
      throw Exception(e.message);
    }
  }

  /// Save Portfolio Project Images to Firebase Storage
  Future<List<String>> savePortfolioProjectImages(
      String userId, List<XFile> images) async {
    try {
      List<String> imageUrls = [];
      for (var image in images) {
        var ref = _firebaseStorage
            .ref()
            .child('users')
            .child(userId)
            .child('portfolio')
            .child(image.name);
        await ref.putFile(File(image.path));
        var url = await ref.getDownloadURL();
        imageUrls.add(url);
      }
      return imageUrls;
    } on FirebaseException catch (e) {
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          content: Text('Error saving images!'),
        ),
      );
      throw Exception(e.message);
    }
  }

  /// Delete Portfolio Project Images from Firebase Storage
  Future<void> deletePortfolioProjectImages(
      String userId, List<String> imageUrls) async {
    try {
      for (var url in imageUrls) {
        var ref = _firebaseStorage.refFromURL(url);
        await ref.delete();
      }
    } on FirebaseException catch (e) {
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          content: Text('Error deleting images!'),
        ),
      );
      throw Exception(e.message);
    }
  }

  /// Delete Portfolio Project Image from Firebase Storage
  Future<void> deletePortfolioProjectImage(
      String userId, String imageUrl) async {
    try {
      var ref = _firebaseStorage.refFromURL(imageUrl);
      await ref.delete();
    } on FirebaseException catch (e) {
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          content: Text('Error deleting image!'),
        ),
      );
      throw Exception(e.message);
    }
  }
}
