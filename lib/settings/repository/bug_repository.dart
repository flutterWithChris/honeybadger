import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:outsourcedx/core/constants.dart';
import 'package:outsourcedx/settings/models/bug.dart';

class BugRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> reportBug(Bug bug) async {
    try {
      await _firestore.collection('bug-reports').doc().set(bug.toDocument());
    } on FirebaseException catch (e) {
      print(e);
      // Show an error message in snackbar
      scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Error sending report: ${e.message}'),
        ),
      );
    }
  }
}
