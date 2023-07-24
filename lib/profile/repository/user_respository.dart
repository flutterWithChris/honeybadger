import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/profile/model/user.dart';
import 'package:honeybadger/profile/repository/base_user_repository.dart';
import 'package:image_picker/image_picker.dart';

class UserRepository extends BaseUserRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  @override
  Future<void> createUser(User user) {
    return _firebaseFirestore
        .collection('users')
        .doc(user.id)
        .set(user.toJson());
  }

  @override
  Future<void> deleteUser(User user) {
    return _firebaseFirestore.collection('users').doc(user.id).delete();
  }

  @override
  Future<User> getUser(String userId) async {
    return _firebaseFirestore
        .collection('users')
        .doc(userId)
        .get()
        .then((doc) => User.fromDocument(doc));
  }

  @override
  Future<void> updateUser(User user) {
    return _firebaseFirestore
        .collection('users')
        .doc(user.id)
        .update(user.toJson());
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
          .collection('users')
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
