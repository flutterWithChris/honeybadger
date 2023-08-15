import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:OutsourcedX/profile/model/category.dart';

class CategoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<List<String>> getCategories() async {
    List<String> categories = [];
    await _firestore.collection('categories').get().then((value) {
      for (var doc in value.docs) {
        categories.add(doc['name']);
      }
    });
    return categories;
  }

  Future<List<String>> getSubcategories(String category) async {
    List<String> subcategories = [];
    await _firestore
        .collection('categories')
        .doc(category)
        .collection('subcategories')
        .get()
        .then((value) {
      for (var doc in value.docs) {
        subcategories.add(doc['name']);
      }
    });
    return subcategories;
  }

  /// Creates a new category in the database.
  Future<void> createCategory(String category) async {
    await _firestore.collection('categories').doc().set({
      'name': category,
      'description': null,
    });
  }

  /// Add category to user's profile.
  Future<void> addCategoryToProfile(Category category) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('categories')
        .doc()
        .set(category.toDocument());
  }
}
