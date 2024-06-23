// ignore_for_file: unused_import

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class PostService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> addPost(File imageFile) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated.');
      }
      final ref = _storage
          .ref()
          .child('images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(imageFile);
    } catch (e) {
      print('Error adding post: $e');
      rethrow; // Rethrow the exception to handle it in the calling context
    }
  }

  Future<void> editPost(String imageUrl, File newImageFile) async {
    try {
      final firebase_storage.Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete(); // Delete current img

      // Upload new img
      final newRef = _storage
          .ref()
          .child('images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      await newRef.putFile(newImageFile);
    } catch (e) {
      print('Error editing post: $e');
      rethrow; // Rethrow the exception to handle it in the calling context
    }
  }

  Future<void> deletePost(String imageUrl) async {
    try {
      final firebase_storage.Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete(); // Delete img from Firebase Storage
    } catch (e) {
      print('Error deleting post: $e');
      rethrow; // Rethrow the exception to handle it in the calling context
    }
  }
}
