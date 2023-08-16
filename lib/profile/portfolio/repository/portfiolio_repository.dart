import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:OutsourcedX/core/constants.dart';
import 'package:OutsourcedX/profile/model/portfolio_project.dart';
import 'package:image_picker/image_picker.dart';

class PortfolioRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  // Get Portfolio Projects List
  Stream<List<PortfolioProject>> getPortfolioProjects(String userId) {
    try {
      return _firestore
          .collection('freelancers')
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
          content: Text('Error getting portfolio projects!',
              style: TextStyle(color: Colors.white)),
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
          .collection('freelancers')
          .doc(userId)
          .collection('portfolio')
          .add(projectWithImages.toDocumentSnapshot());
    } on FirebaseException catch (e) {
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          content: Text('Error adding portfolio project!',
              style: TextStyle(color: Colors.white)),
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
          .collection('freelancers')
          .doc(userId)
          .collection('portfolio')
          .doc(project.id)
          .update(project.toDocumentSnapshot());
    } on FirebaseException catch (e) {
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          content: Text('Error updating portfolio project!',
              style: TextStyle(color: Colors.white)),
        ),
      );
      throw Exception(e.message);
    }
  }

  // Delete Portfolio Project
  Future<void> deletePortfolioProject(
      String userId, PortfolioProject project) async {
    try {
      Future.wait([
        for (var image in project.images!)
          _firebaseStorage
              .ref()
              .child('freelancers')
              .child(userId)
              .child('portfolio')
              .child(image)
              .delete(),
        _firestore
            .collection('freelancers')
            .doc(userId)
            .collection('portfolio')
            .doc(project.id)
            .delete()
      ]);
    } on FirebaseException catch (e) {
      scaffoldKey.currentState!.showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        content: Text('Error deleting portfolio project!',
            style: TextStyle(color: Colors.white)),
      ));
      throw Exception(e.message);
    }
  }

  /// Save Portfolio Project Images to Firebase Storage
  Future<List<String>> savePortfolioProjectImages(
      String userId, List<XFile> images) async {
    try {
      // Save Project Images to Firebase Storage in Parallel
      List<Future<String>> tasks = images.map((image) async {
        var ref = _firebaseStorage
            .ref()
            .child('freelancers')
            .child(userId)
            .child('portfolio')
            .child(image.name);
        await ref.putFile(File(image.path));
        return ref.getDownloadURL();
      }).toList();

      return await Future.wait(tasks);
    } on FirebaseException catch (e) {
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          content: Text('Error saving images!',
              style: TextStyle(color: Colors.white)),
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
          content: Text('Error deleting images!',
              style: TextStyle(color: Colors.white)),
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
          content: Text('Error deleting image!',
              style: TextStyle(color: Colors.white)),
        ),
      );
      throw Exception(e.message);
    }
  }
}
