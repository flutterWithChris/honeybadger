import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:outsourcedx/core/constants.dart';
import 'package:outsourcedx/profile/model/user.dart';
import 'package:outsourcedx/profile/repository/base_user_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

class UserRepository extends BaseUserRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String getUserPath(User user) {
    if (user.userType == UserType.freelancer) {
      return 'freelancers';
    } else {
      return 'clients';
    }
  }

  @override
  Future<void> createUser(User user) async {
    return await _firebaseFirestore
        .collection(getUserPath(user))
        .doc(user.id)
        .set(user.toDocument());
  }

  @override
  Future<void> deleteUser(User user) async {
    return await _firebaseFirestore
        .collection(getUserPath(user))
        .doc(user.id)
        .delete();
  }

  @override
  Future<User?> getUser(User user) async {
    try {
      return await _firebaseFirestore
          .collection(getUserPath(user))
          .doc(user.id)
          .get()
          .then((doc) => doc.exists ? User.fromDocument(doc) : null);
    } on FirebaseException catch (e) {
      print(e);
      scaffoldKey.currentState!.showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'An error occurred while getting your profile.',
          style: TextStyle(color: Colors.white),
        ),
      ));
      return null;
    }
  }

  @override
  Future<User?> getFreelancerFromId(String userId) async {
    try {
      return await _firebaseFirestore
          .collection('freelancers')
          .doc(userId)
          .get()
          .then((doc) => doc.exists ? User.fromDocument(doc) : null);
    } on FirebaseException catch (e) {
      print(e);
      scaffoldKey.currentState!.showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'An error occurred while getting your profile.',
          style: TextStyle(color: Colors.white),
        ),
      ));
      return null;
    }
  }

  /// Get user as a stream
  @override
  Stream<User> getUserAsStream(User user) {
    try {
      return _firebaseFirestore
          .collection(getUserPath(user))
          .doc(user.id)
          .snapshots()
          .map((doc) {
        return User.fromDocument(doc);
      }).onErrorResume((error, stackTrace) {
        if (getUserPath(user) == 'freelancers') {
          return _firebaseFirestore
              .collection('clients')
              .doc(user.id)
              .snapshots()
              .map((doc) {
            return User.fromDocument(doc);
          });
        } else {
          return _firebaseFirestore
              .collection('freelancers')
              .doc(user.id)
              .snapshots()
              .map((doc) {
            return User.fromDocument(doc);
          });
        }
      });
    } catch (e) {
      scaffoldKey.currentState!.showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'An error occurred while getting your profile.',
          style: TextStyle(color: Colors.white),
        ),
      ));
      return const Stream.empty();
    }
  }

  @override
  Future<void> updateUser(User user) {
    try {
      return _firebaseFirestore
          .collection(getUserPath(user))
          .doc(user.id)
          .update(user.toDocument());
    } on FirebaseException catch (e) {
      print(e);
      scaffoldKey.currentState!.showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'An error occurred while updating your profile.',
          style: TextStyle(color: Colors.white),
        ),
      ));
      return Future<void>.value();
    }
  }

  @override
  Future<String?> setUserProfilePicture(XFile profilePicture, User user) async {
    try {
      await _firebaseStorage
          .ref('profile_pictures/${user.id}')
          .putFile(File(profilePicture.path));
      final String downloadUrl = await _firebaseStorage
          .ref('profile_pictures/${user.id}')
          .getDownloadURL();
      await _firebaseFirestore
          .collection(getUserPath(user))
          .doc(user.id)
          .update({'photoUrl': downloadUrl});
      return downloadUrl;
    } on FirebaseException catch (e) {
      print(e);
      scaffoldKey.currentState!.showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'An error occurred while uploading your profile picture.',
          style: TextStyle(color: Colors.white),
        ),
      ));
      return null;
    }
  }
}
